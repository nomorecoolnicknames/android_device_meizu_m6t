# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
# BoardConfig.mk - Meizu M6T (M6T / M811H), MediaTek MT6750

# Build
# Nougat blobs are installed with PRODUCT_COPY_FILES (vendor-blobs.mk), which
# rejects ELF files by default. Their DT_NEEDED entries are not validated at
# build time.
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# A blob and a module may install to the same /vendor path
# (e.g. hw/fingerprint.default.so); warn instead of failing.
BUILD_BROKEN_DUP_RULES := true

DEVICE_PATH := device/meizu/M6T

# Architecture
# MT6750: eight Cortex-A53 cores (ARMv8.0, no LSE atomics).
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

TARGET_USES_64_BIT_BINDER := true

# Platform
# The platform name selects the *.mt6750.so hw modules of the blobs.
# ro.hardware stays mt6755 (see the cmdline), matching fstab.mt6755 and
# init.mt6755.rc. GPU: Mali-T860MP2.
TARGET_BOARD_PLATFORM := mt6750
TARGET_BOOTLOADER_BOARD_NAME := mt6750
TARGET_BOARD_PLATFORM_GPU := mali-t860mp2

TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# Assert
BOARD_NAME := M6T
# The device name is case-sensitive.
TARGET_OTA_ASSERT_DEVICE := M6T,MeizuM6T,M811H,m1811

# Display
# 720x1440, density 320.
TARGET_SCREEN_WIDTH := 720
TARGET_SCREEN_HEIGHT := 1440
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888

# Partitions
# A-only, no dynamic partitions; sizes follow the factory scatter file.
BOARD_FLASH_BLOCK_SIZE := 131072

BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 4294967296
BOARD_CACHEIMAGE_PARTITION_SIZE := 452984832
BOARD_USERDATAIMAGE_PARTITION_SIZE := 11683216896

# /vendor lives on the custom partition.
BOARD_VENDORIMAGE_PARTITION_SIZE := 1073729536
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4

# Do not set PRODUCT_USE_DYNAMIC_PARTITIONS here: it is a read-only product
# variable by the time BoardConfig.mk is read.
AB_OTA_UPDATER := false
BOARD_USES_RECOVERY_AS_BOOT := false
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false

# VNDK
TARGET_COPY_OUT_VENDOR := vendor
BOARD_VNDK_VERSION := current
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# Kernel
# Boot image geometry follows the factory boot header.
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x04f88000
BOARD_SECOND_OFFSET := 0x00e88000
BOARD_TAGS_OFFSET := 0x03f88000
BOARD_MKBOOTIMG_ARGS := --board 1550465732 --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --second_offset $(BOARD_SECOND_OFFSET) --tags_offset $(BOARD_TAGS_OFFSET)

BOARD_BOOT_HEADER_VERSION := 0
BOARD_INCLUDE_DTB_IN_BOOTIMG :=
BOARD_INCLUDE_RECOVERY_DTBO :=

# The cmdline selects the mt6755 init/fstab names and the binder devices.
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 androidboot.hardware=mt6755 androidboot.selinux=permissive binder.devices=binder,hwbinder,vndbinder androidboot.usb.config=adb buildvariant=userdebug

# Prebuilt kernel with appended DTB.
TARGET_NO_KERNEL := false
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
# The kernel source (3.18) is still required: the generated_kernel_includes
# genrule runs headers_install from TARGET_KERNEL_SOURCE.
# TARGET_FORCE_PREBUILT_KERNEL keeps the prebuilt in boot.img.
TARGET_KERNEL_SOURCE := kernel/meizu/M6T
TARGET_KERNEL_CONFIG := M6T_a13_defconfig
TARGET_FORCE_PREBUILT_KERNEL := true
TARGET_KERNEL_VERSION := 3.18
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image.gz-dtb
BOARD_KERNEL_IMAGE_NAME := kernel

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.mt6755
BOARD_SUPPRESS_SECURE_ERASE := true
BOARD_CHARGER_SHOW_PERCENTAGE := true

# Wi-Fi
# MediaTek WMT/CONNSYS combo chip. libwifi_hal only writes /dev/wmtWifi (and
# brings up wlan0) when WIFI_DRIVER_STATE_CTRL_PARAM is defined.
BOARD_WLAN_DEVICE := MediaTek
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_mt66xx
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_mt66xx
WIFI_DRIVER_STATE_CTRL_PARAM := /dev/wmtWifi
WIFI_DRIVER_STATE_ON := 1
WIFI_DRIVER_STATE_OFF := 0
WIFI_DRIVER_OPERSTATE_PATH := /sys/class/net/wlan0/operstate
WIFI_DRIVER_STATE_CTRL_RETRIES := 8
WIFI_DRIVER_STATE_CTRL_RETRY_DELAY_US := 1000000

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_MTK := true

# SELinux
# The Nougat MediaTek blobs violate many public-policy neverallows.
SELINUX_IGNORE_NEVERALLOWS := true
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# Mount points for /nvdata, /protect_f and /protect_s: the root is read-only,
# so init cannot create them, and without /nvdata there is no NVRAM (IMEI,
# modem). Labels are in sepolicy/vendor/file_contexts.
BOARD_ROOT_EXTRA_FOLDERS := nvdata protect_f protect_s

# Not a Qualcomm platform.
BOARD_USES_QCOM_HARDWARE := false
TARGET_USES_QCOM_BSP := false

TARGET_SYSTEM_PROP := $(DEVICE_PATH)/system.prop
