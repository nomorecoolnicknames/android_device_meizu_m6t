LOCAL_PATH := device/meizu/M6T
TARGET_MEIZU_MT675X_DEVICE := M6T

# Inherit from the proprietary version
-include vendor/meizu/M6T/BoardConfigVendor.mk

include device/meizu/m3_meizu_m6-common/BoardConfigCommon.mk

# Platform / boot image geometry (factory layout)
TARGET_CPU_VARIANT := cortex-a53
TARGET_SCREEN_WIDTH := 720
TARGET_SCREEN_HEIGHT := 1440
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 4294967296
BOARD_MKBOOTIMG_ARGS := --kernel_offset 0x00008000 --ramdisk_offset 0x04f88000 --second_offset 0x00e88000 --tags_offset 0x03f88000 --board 1550465732

# The MediaTek libril wrapper needs the MediaTek telephony/ril.h extensions
# ahead of hardware/ril.
TARGET_SPECIFIC_HEADER_PATH := vendor/mediatek/include $(COMMON_PATH)/include


# system.prop
TARGET_SYSTEM_PROP := $(LOCAL_PATH)/system.prop

# Radio
ADD_RADIO_FILES := true
TARGET_RELEASETOOLS_EXTENSIONS := $(LOCAL_PATH)
# MediaTek HIDL RIL wrapper for the stock modem blobs.
BOARD_PROVIDES_RILD := true
BOARD_PROVIDES_LIBRIL := true

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(LOCAL_PATH)/bluetooth

# Assert
TARGET_OTA_ASSERT_DEVICE := M6T
BOARD_NAME := M6T
TARGET_SYSTEM_PROP := device/meizu/M6T/system.prop

# Gatekeeper
# No gatekeeper HAL; use the gatekeeperd software fallback.
BOARD_USE_SOFT_GATEKEEPER := true

# ABIs
# Both app ABIs are supported; M6_PURE_ARM64=true is a debug-only override.
M6_PURE_ARM64 ?= false
ifeq ($(M6_PURE_ARM64),true)
TARGET_CPU_ABI_LIST_64_BIT := $(TARGET_CPU_ABI)
TARGET_CPU_ABI_LIST_32_BIT :=
TARGET_CPU_ABI_LIST := $(TARGET_CPU_ABI_LIST_64_BIT)
TARGET_SUPPORTS_32_BIT_APPS := false
TARGET_SUPPORTS_64_BIT_APPS := true
else
TARGET_SUPPORTS_32_BIT_APPS := true
TARGET_SUPPORTS_64_BIT_APPS := true
endif

# Audio
# The stock audio.primary is unstable in the 64-bit HAL service; use 32-bit.
AUDIOSERVER_MULTILIB := 32

# Camera
# cameraserver is 32-bit only here; publish CameraService from mediaserver.
TARGET_HAS_LEGACY_CAMERA_HAL1 := true

# Shims
# The camera blobs need legacy graphics symbols, and the stock vendor ICU must
# coexist with system libraries that need ICU 58 symbols.
TARGET_LD_SHIM_LIBS += \
    /system/lib/libandroid_runtime.so|/system/lib/libicuuc.so \
    /system/lib/libmedia.so|/system/lib/libicuuc.so \
    /system/lib/libmedia.so|/system/lib/libicui18n.so \
    /system/lib/libsqlite.so|/system/lib/libicuuc.so \
    /system/lib/libsqlite.so|/system/lib/libicui18n.so \
    /system/vendor/lib/libicui18n.so|/system/vendor/lib/libicuuc.so \
    /system/vendor/lib/libxml2.so|/system/vendor/lib/libicuuc.so \
    /system/vendor/lib/libcam_utils.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libcam.client.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libcam.camnode.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libeffecthal.base.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libjni_lomoeffect.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libvfb_render.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libMtkOmxVenc.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libmtk_mmutils.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libshowlogo.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libgui_ext.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib/libui_ext.so|/system/vendor/lib/libmtkshim_gui.so \
    /system/vendor/lib64/libcam_utils.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libcam.client.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libcam.camnode.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libeffecthal.base.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libjni_lomoeffect.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libvfb_render.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libmtk_mmutils.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libgui_ext.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/vendor/lib64/libui_ext.so|/system/vendor/lib64/libmtkshim_gui.so \
    /system/lib64/libandroid_runtime.so|/system/lib64/libicuuc.so \
    /system/lib64/libmedia.so|/system/lib64/libicuuc.so \
    /system/lib64/libmedia.so|/system/lib64/libicui18n.so \
    /system/lib64/libsqlite.so|/system/lib64/libicuuc.so \
    /system/lib64/libsqlite.so|/system/lib64/libicui18n.so \
    /system/vendor/lib64/libicui18n.so|/system/vendor/lib64/libicuuc.so \
    /system/vendor/lib64/libxml2.so|/system/vendor/lib64/libicuuc.so

# Kernel
# The stock 3.18.35 kernel is used as a prebuilt by default;
# M6_KERNEL_FROM_SOURCE=true builds kernel/meizu/M6T/kernel-3.18 instead.
TARGET_NO_KERNEL := false

M6_KERNEL_FROM_SOURCE ?= false

ifeq ($(M6_KERNEL_FROM_SOURCE),true)
# Source build: arm64, GCC 4.9, M6T_defconfig, Image.gz-dtb.
TARGET_KERNEL_SOURCE := kernel/meizu/M6T/kernel-3.18
TARGET_KERNEL_CONFIG := M6T_defconfig
TARGET_KERNEL_ARCH := arm64
# Prefer the in-tree AArch64 GCC 4.9 toolchain.
# CROSS_COMPILE must be absolute because kernel.mk changes into the kernel source directory.
# The legacy in-tree compiler wrapper requires Python 2.
M6T_KERNEL_TC_INTREE := $(abspath prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin)/aarch64-linux-android-
ifneq ($(wildcard $(M6T_KERNEL_TC_INTREE)gcc),)
TARGET_KERNEL_CROSS_COMPILE_PREFIX := $(M6T_KERNEL_TC_INTREE)
else
ifeq ($(strip $(M6T_KERNEL_CROSS_COMPILE_PREFIX)),)
$(error Set M6T_KERNEL_CROSS_COMPILE_PREFIX to the absolute AArch64 GCC 4.9 prefix when the in-tree compiler is unavailable)
endif
ifeq ($(filter /%,$(strip $(M6T_KERNEL_CROSS_COMPILE_PREFIX))),)
$(error M6T_KERNEL_CROSS_COMPILE_PREFIX must be an absolute AArch64 GCC 4.9 prefix)
endif
TARGET_KERNEL_CROSS_COMPILE_PREFIX := $(strip $(M6T_KERNEL_CROSS_COMPILE_PREFIX))
endif
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
# Clear prebuilt vars so kernel.mk takes the FULL_KERNEL_BUILD path
TARGET_PREBUILT_KERNEL :=
M6_DISPLAY_KERNEL_PREBUILT :=
else
# Prebuilt kernel (default). Headers still come from the M6T kernel source.
TARGET_KERNEL_SOURCE := kernel/meizu/M6T/kernel-3.18
TARGET_KERNEL_CONFIG :=
M6_DISPLAY_KERNEL_PREBUILT := device/meizu/M6T/prebuilt-kernel/Image.gz-dtb
TARGET_PREBUILT_KERNEL := $(M6_DISPLAY_KERNEL_PREBUILT)
BOARD_KERNEL_IMAGE_NAME := kernel
PRODUCT_COPY_FILES += \
    $(M6_DISPLAY_KERNEL_PREBUILT):kernel
endif
