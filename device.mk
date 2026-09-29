#
# device.mk - Meizu M6T (M6T / M811H), MT6750
#
# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/meizu/M6T

# Soong namespaces
# Pairs with soong_namespace {} in Android.bp: the modules of this tree reach
# Make only for products that list the namespace.
PRODUCT_SOONG_NAMESPACES += \
    device/meizu/M6T

# Screen density
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xhdpi

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Rootdir
# First-stage init mounts the first_stage_mount entries of this fstab.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt6755:$(TARGET_COPY_OUT_RAMDISK)/fstab.mt6755 \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt6755:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.mt6755

# Init only imports /vendor/etc/init/hw/init.${ro.hardware}.rc; the other hw/
# files are imported from it.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/ueventd.mt6755.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
    $(LOCAL_PATH)/rootdir/etc/init/hw/init.mt6755.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.mt6755.rc \
    $(LOCAL_PATH)/rootdir/etc/init/hw/init.mt6755.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.mt6755.usb.rc \
    $(LOCAL_PATH)/rootdir/etc/init/hw/init.M6T.nvram.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.M6T.nvram.rc \
    $(LOCAL_PATH)/rootdir/etc/init/hw/init.M6T.modem.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.M6T.modem.rc \
    $(LOCAL_PATH)/rootdir/etc/init/hw/init.M6T.tee.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.M6T.tee.rc \
    $(LOCAL_PATH)/rootdir/etc/init/hw/init.M6T.connectivity.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.M6T.connectivity.rc \
    $(LOCAL_PATH)/rootdir/etc/init/hw/init.M6T.thermal.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.M6T.thermal.rc \
    $(LOCAL_PATH)/rootdir/etc/init/init.M6T.sensors.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.M6T.sensors.rc

# VINTF
DEVICE_MANIFEST_FILE := $(LOCAL_PATH)/manifest.xml

# Wi-Fi
# wpa_supplicant.conf is not a module; it is copied below.
PRODUCT_PACKAGES += \
    libwpa_client \
    wpa_supplicant \
    hostapd

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
    $(LOCAL_PATH)/wifi/p2p_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant.conf

# The only wpa_supplicant service definition in the image.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init/init.M6T.wifi.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.M6T.wifi.rc

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service


# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml

# Proprietary files
$(call inherit-product, $(LOCAL_PATH)/vendor-blobs.mk)

# Shims
# Nougat-ABI shims (Android.bp); which blob needs which is in shims/wiring.txt.
# libM6Tshim_power has no consumer in this blob set and is not installed.
PRODUCT_PACKAGES += \
    libM6Tshim_netd_client \
    libM6Tshim_ssl \
    libM6Tshim_gui \
    libM6Tshim_ui \
    libM6Tshim_sf \
    libM6Tshim_utils \
    libM6Tshim_audioutils \
    libM6Tshim_region \
    libM6Tshim_net

# Vendor-side libraries the blobs need and cannot load from /system:
# libcamera_client_vendor exports the symbols libsource.so imports; the tinyalsa
# and tinyxml libraries are needed by the audio HAL blobs.
PRODUCT_PACKAGES += \
    libstdc++.vendor \
    libgui_vendor \
    libgui_fwd_M6T \
    libcamera_client_vendor \
    libfs_mgr_shim_M6T \
    libtinycompress \
    libtinyxml \
    libalsautils

# HIDL HALs
# Only HALs the blob set can back. The Nougat gatekeeper blob does not load,
# so the software gatekeeper is used; vibrator.default drives timed_output.
# Every passthrough *-service needs its *-impl in /vendor/lib*/hw.
# media.omx and configstore come from base_vendor.mk.
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service \
    vibrator.default \
    android.hardware.audio.service \
    android.hardware.audio@6.0-impl \
    android.hardware.audio.effect@6.0-impl \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service \
    android.hardware.gatekeeper@1.0-service.software \
    android.hardware.drm@1.4-service.clearkey \
    android.hardware.gnss@1.0-impl \
    android.hardware.gnss@1.0-service \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service \
    android.hardware.sensors@1.0-impl \
    android.hardware.sensors@1.0-service
