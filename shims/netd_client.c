/* libnetd_client.so for the vendor partition (lib and lib64).
 *
 * mtk-ril.so and mtk-rilmd2.so need libnetd_client.so for protectFromVpn,
 * but libnetd_client is system-only. The IMS blobs import setNetworkForSocket
 * and protectFromVpn as well.
 *
 * protectFromVpn performs the same fwmarkd round trip as the system library:
 * a FwmarkCommand{PROTECT_FROM_VPN} over /dev/socket/fwmarkd with the socket
 * fd passed as SCM_RIGHTS, returning the status netd sends back. As upstream,
 * it reports success if fwmarkd cannot be reached.
 *
 * setNetworkForSocket forwards to the LLNDK android_setsocknetwork() with the
 * netId packed into a net_handle_t.
 */
#include <android/multinetwork.h>
#include <errno.h>
#include <stdint.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

#define NETID_UNSET 0u /* system/netd/include/netid_client.h */

/* Must match kHandleMagic in frameworks/base/native/android/net.c. */
static const uint32_t kHandleMagic = 0xcafed00d;

/* system/netd/include/FwmarkCommand.h: enum CmdId + three words. */
enum { FWMARK_PROTECT_FROM_VPN = 3 };
struct fwmark_command {
    int cmd_id;
    unsigned net_id;
    uid_t uid;
    uint32_t traffic_ctrl_info;
};

int setNetworkForSocket(unsigned netId, int socketFd) {
    net_handle_t handle = netId == NETID_UNSET
            ? NETWORK_UNSPECIFIED
            : ((net_handle_t)netId << 32) | kHandleMagic;

    if (android_setsocknetwork(handle, socketFd) == 0)
        return 0;
    return -errno;
}

int protectFromVpn(int socketFd) {
    /* NetdClient.cpp checkSocket(): only inet sockets carry a fwmark. */
    int family;
    socklen_t len = sizeof(family);
    if (socketFd < 0)
        return -EBADF;
    if (getsockopt(socketFd, SOL_SOCKET, SO_DOMAIN, &family, &len) == -1)
        return -errno;
    if (family != AF_INET && family != AF_INET6)
        return -EAFNOSUPPORT;

    int ch = socket(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0);
    if (ch == -1)
        return -errno;
    struct sockaddr_un addr = {.sun_family = AF_UNIX, .sun_path = "/dev/socket/fwmarkd"};
    if (TEMP_FAILURE_RETRY(connect(ch, (const struct sockaddr*)&addr, sizeof(addr))) == -1) {
        close(ch);
        return 0; /* upstream: "assume there's no error" */
    }

    struct fwmark_command cmd = {FWMARK_PROTECT_FROM_VPN, 0, 0, 0};
    struct iovec iov = {&cmd, sizeof(cmd)};
    union {
        struct cmsghdr cmh;
        char buf[CMSG_SPACE(sizeof(int))];
    } cmsgu;
    memset(&cmsgu, 0, sizeof(cmsgu));
    struct msghdr msg = {.msg_iov = &iov, .msg_iovlen = 1,
                         .msg_control = cmsgu.buf, .msg_controllen = sizeof(cmsgu.buf)};
    struct cmsghdr* c = CMSG_FIRSTHDR(&msg);
    c->cmsg_len = CMSG_LEN(sizeof(int));
    c->cmsg_level = SOL_SOCKET;
    c->cmsg_type = SCM_RIGHTS;
    memcpy(CMSG_DATA(c), &socketFd, sizeof(int));

    int ret = 0;
    if (TEMP_FAILURE_RETRY(sendmsg(ch, &msg, 0)) == -1 ||
        TEMP_FAILURE_RETRY(recv(ch, &ret, sizeof(ret), 0)) == -1)
        ret = -errno;
    close(ch);
    return ret;
}
