LOCAL_PATH := $(call my-dir)

# Camera shims, preloaded (LD_PRELOAD) into mediaserver and the camera
# provider service:
#
#   libm6_camera_glconsumer_compat.so
#     Provides the old no-argument android::GLConsumer::getCurrentBuffer()
#     the stock blobs expect.
#
#   libm6_camera_tsf_bypass.so
#     Stubs TsfCore::TsfCoreProcess() / Shading_TSF_int_gain() / isEnableTSF()
#     in libcamalgo.so, which crash without TSF/LSC calibration data in NVRAM.
#     Prebuilt aarch64 library without dependencies; the source is
#     libm6_camera_tsf_bypass.cpp.
#
# The LD_PRELOAD is set in mediaserver.rc and
# android.hardware.camera.provider@2.4-service.rc.

include $(CLEAR_VARS)
LOCAL_MODULE := libm6_camera_glconsumer_compat
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MULTILIB := 64
LOCAL_PROPRIETARY_MODULE := true
LOCAL_SRC_FILES := libm6_camera_glconsumer_compat.cpp
LOCAL_SHARED_LIBRARIES := libgui libui libutils liblog
LOCAL_ALLOW_UNDEFINED_SYMBOLS := true
LOCAL_C_INCLUDES := \
    frameworks/native/include \
    system/core/include
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libm6_camera_tsf_bypass
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_SUFFIX := .so
LOCAL_MULTILIB := 64
LOCAL_PROPRIETARY_MODULE := true
LOCAL_SRC_FILES_64 := libm6_camera_tsf_bypass.so
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := m6_nvram_camera_seed
LOCAL_MODULE_TAGS := optional
LOCAL_PROPRIETARY_MODULE := true
LOCAL_SRC_FILES := nvram_camera_seed.c
LOCAL_CFLAGS := -std=gnu99 -Wall -Wextra
LOCAL_SHARED_LIBRARIES := libdl
include $(BUILD_EXECUTABLE)
