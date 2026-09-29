// Nougat-ABI android::GraphicBuffer constructor for the MediaTek blobs.
//
// libui_ext (in the hwcomposer closure) and several camera/OMX blobs import
//   GraphicBuffer(uint32_t w, uint32_t h, PixelFormat format, uint32_t usage)
//   = _ZN7android13GraphicBufferC1Ejjij,
// which libui no longer exports. The current constructor takes a trailing
// std::string requestorName, so this forwards with "<Unknown>", the header's
// default.
//
// The caller allocates the object with the Nougat size (232 bytes on arm64,
// 136 on arm32), smaller than the current object (256 / 160). Callers are
// byte-patched at import time to allocate the larger size (shims/bytepatch.txt).
// An unpatched caller aborts here with its return address instead of
// corrupting the heap.
//
// ABI: std::string is not trivially copyable, so the Itanium C++ ABI passes it
// by reference to a caller-owned temporary; declared here as a pointer, like
// the other manual declarations in ui.cpp.
#include <malloc.h>
#include <stdint.h>

#include <string>

#include <log/log.h>

namespace {
constexpr size_t kA13GraphicBufferSize = sizeof(void*) == 8 ? 256 : 160;
}

extern "C" {

void _ZN7android13GraphicBufferC1EjjijNSt3__112basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEE(
        void* self, uint32_t w, uint32_t h, int32_t format, uint32_t usage, std::string* requestorName);

void _ZN7android13GraphicBufferC1Ejjij(void* self, uint32_t w, uint32_t h, int32_t format,
                                       uint32_t usage) {
    size_t have = malloc_usable_size(self);
    if (have < kA13GraphicBufferSize) {
        LOG_ALWAYS_FATAL("N GraphicBuffer(%u, %u, %d, %#x) on a %zu-byte object (caller %p): A13 "
                         "needs %zu - byte-patch the caller's operator new (shims/bytepatch.txt)",
                         w, h, format, usage, have, __builtin_return_address(0),
                         kA13GraphicBufferSize);
    }
    std::string name("<Unknown>");
    _ZN7android13GraphicBufferC1EjjijNSt3__112basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEE(
            self, w, h, format, usage, &name);
}

}  // extern "C"
