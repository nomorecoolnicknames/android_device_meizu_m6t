/* libnetutils additions for the MediaTek Nougat RIL and thermal blobs.
 *
 * ifc_ipv6_trigger_rs is a MediaTek addition to libnetutils used on data call
 * setup: send an ICMPv6 Router Solicitation on the given interface so SLAAC
 * does not wait for the next unsolicited Router Advertisement. rild holds
 * CAP_NET_RAW; the kernel computes the ICMPv6 checksum for raw sockets.
 */
#include <arpa/inet.h>
#include <net/if.h>
#include <netinet/icmp6.h>
#include <netinet/in.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

int ifc_ipv6_trigger_rs(const char *ifname) {
    struct icmp6_hdr rs;
    struct sockaddr_in6 dst;
    int s, hops = 255, ret = -1;

    if (ifname == NULL)
        return -1;

    memset(&rs, 0, sizeof(rs));
    rs.icmp6_type = ND_ROUTER_SOLICIT;

    memset(&dst, 0, sizeof(dst));
    dst.sin6_family = AF_INET6;
    inet_pton(AF_INET6, "ff02::2", &dst.sin6_addr); /* all-routers */
    dst.sin6_scope_id = if_nametoindex(ifname);
    if (dst.sin6_scope_id == 0)
        return -1;

    s = socket(AF_INET6, SOCK_RAW | SOCK_CLOEXEC, IPPROTO_ICMPV6);
    if (s < 0)
        return -1;

    /* RFC 4861 section 4.1: an RS must be sent with hop limit 255, and the
     * receiver must discard it otherwise. */
    setsockopt(s, IPPROTO_IPV6, IPV6_MULTICAST_HOPS, &hops, sizeof(hops));
    setsockopt(s, IPPROTO_IPV6, IPV6_UNICAST_HOPS, &hops, sizeof(hops));

    if (sendto(s, &rs, sizeof(rs), 0, (struct sockaddr *)&dst,
               sizeof(dst)) == (ssize_t)sizeof(rs))
        ret = 0;

    close(s);
    return ret;
}

/* ifc_set_txq_state (transmit queue toggle) and ifc_ccmni_md_cfg (CCMNI
 * modem interface config) are needed by mtk-ril and thermal at load time.
 * The data path works without them; report success. */
int ifc_set_txq_state(const char *ifname, int state) {
    (void)ifname; (void)state;
    return 0;
}
int ifc_ccmni_md_cfg(const char *ifname, int md_id, int ccmni_idx, int op) {
    (void)ifname; (void)md_id; (void)ccmni_idx; (void)op;
    return 0;
}

/* ifc_set_throttle: used by the thermal daemon's network throttling
 * mitigation. Not needed on this device; report success. */
int ifc_set_throttle(const char *ifname, int rxKbps, int txKbps) {
    (void)ifname; (void)rxKbps; (void)txKbps;
    return 0;
}
