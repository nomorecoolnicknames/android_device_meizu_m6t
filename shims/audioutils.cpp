// Echo reference stubs for the Nougat primary audio HAL.
//
// create/release_echo_reference were removed from libaudioutils. Nougat ABI:
//   int create_echo_reference(audio_format_t, uint32_t, uint32_t,
//                             audio_format_t, uint32_t, uint32_t,
//                             echo_reference_itfe**);
//   void release_echo_reference(echo_reference_itfe*);
// They are only used for voice call echo cancellation. Return -ENOSYS so the
// HAL takes its no-EC path; a null reference with success would crash.
#include <errno.h>
#include <stdint.h>

extern "C" {

struct echo_reference_itfe;

int create_echo_reference(int /*rdFormat*/, uint32_t /*rdChannelCount*/,
                          uint32_t /*rdSamplingRate*/, int /*wrFormat*/,
                          uint32_t /*wrChannelCount*/,
                          uint32_t /*wrSamplingRate*/,
                          struct echo_reference_itfe** reference) {
    if (reference) *reference = 0;
    return -ENOSYS;
}

void release_echo_reference(struct echo_reference_itfe* /*reference*/) {
}

}  // extern "C"

// ---- android::AudioSystem::getDeviceConnectionState(audio_devices_t, const char*)
// Called by the HAL from adev_open(). Inside the audio HAL service this would
// wait on media.audio_policy over vndbinder, which is never published there,
// and deadlock audioserver. Report "unavailable"; the policy manager pushes
// the real state via set_parameters once the module is loaded. This library
// precedes libaudioclient in the blob's DT_NEEDED, so this definition wins.
extern "C" int _ZN7android11AudioSystem24getDeviceConnectionStateEjPKc(
        unsigned int /*device*/, const char* /*device_address*/) {
    return 0;  // AUDIO_POLICY_DEVICE_STATE_UNAVAILABLE
}

// ---- AudioSystem::getParameters / setParameters (audio_io_handle_t, String8)
// libaudio_param_parser calls getParameters() from adev_open(), which hits the
// same vndbinder deadlock. getParameters returns an empty String8 (the parser
// then uses the NVRAM parameters), setParameters reports success. String8 is
// returned by value (sret); a one-pointer struct with a user-provided
// destructor is returned the same way, and the real String8::String8() builds
// the empty string so libutils keeps its own SharedBuffer accounting.
namespace { struct M95String8Ret { void* p; ~M95String8Ret() {} }; }
extern "C" void _ZN7android7String8C1Ev(void* self);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wreturn-type-c-linkage"
extern "C" M95String8Ret _ZN7android11AudioSystem13getParametersEiRKNS_7String8E(
        int /*ioHandle*/, const void* /*keys*/) {
    M95String8Ret r;
    _ZN7android7String8C1Ev(&r);
    return r;
}
#pragma clang diagnostic pop
extern "C" int _ZN7android11AudioSystem13setParametersEiRKNS_7String8E(
        int /*ioHandle*/, const void* /*keyValuePairs*/) {
    return 0;  // NO_ERROR
}
