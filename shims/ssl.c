/* SSLv3_{client,server}_method for the Nougat MediaTek blobs.
 *
 * Used by mtk_agpsd and libcurl-ss.so. BoringSSL dropped SSLv3; map both
 * names to the version-flexible TLS methods, which is what SUPL/AGPS servers
 * negotiate anyway.
 */
#include <openssl/ssl.h>

const SSL_METHOD *SSLv3_client_method(void) { return TLS_client_method(); }
const SSL_METHOD *SSLv3_server_method(void) { return TLS_server_method(); }
