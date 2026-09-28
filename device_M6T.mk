# Device configuration for the Meizu M6T.
LOCAL_PATH := device/meizu/M6T
COMMON_PATH := device/meizu/m3_meizu_m6-common

# Screen density
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xhdpi
PRODUCT_AAPT_PREBUILT_DPI := xhdpi xxhdpi hdpi tvdpi mdpi ldpi

# Product common configurations
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Both arm64-v8a and armeabi-v7a are supported; use both zygotes.
# M6_PURE_ARM64=true is a debug-only override.
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.zygote=zygote64_32
PRODUCT_DEFAULT_PROPERTY_OVERRIDES := $(filter-out ro.zygote=%,$(PRODUCT_DEFAULT_PROPERTY_OVERRIDES))
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.secure=0 \
    ro.adb.secure=0 \
    ro.zygote=zygote64_32 \
    persist.service.acm.enable=0 \
    persist.sys.root_access=3 \
    persist.sys.usb.config=adb \
    ro.allow.mock.location=0 \
    ro.debuggable=1 \
    ro.dalvik.vm.native.bridge=0 \
    ro.mount.fs=EXT4 \
    ro.kernel.android.checkjni=0 \
    ro.telephony.ril.config=fakeiccid \
    ro.com.android.mobiledata=false

# Permissions. Sensors and microphone are not advertised yet.
PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/handheld_core_hardware_no_mic.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.faketouch.xml:system/etc/permissions/android.hardware.faketouch.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    $(COMMON_PATH)/configs/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:system/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml

# HIDL manifest
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/manifest.xml:$(TARGET_COPY_OUT_VENDOR)/manifest.xml

# Shipped with Android 6.0
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.first_api_level=23

# Properties
PRODUCT_PROPERTY_OVERRIDES += \
    ro.mediatek.platform=MT6750 \
    ro.hardware=mt6750 \
    ro.hardware.audio=mt6750 \
    ro.hardware.gralloc=mt6750 \
    ro.hardware.hwcomposer=mt6750 \
    ro.hardware.camera=mt6750 \
    ro.hardware.gps=mt6750 \
    ro.opengles.version=196610 \
    media.settings.xml=/vendor/etc/media_profiles.xml \
    persist.media.treble_omx=false \
    debug.stagefright.softenc.ignore_fence_timeout=true \
    debug.sf.disable_hwc=1 \
    debug.composition.type=gpu \
    debug.sf.hw=1 \
    debug.egl.hw=1 \
    persist.sys.usb.config=adb

# Dalvik/HWUI
$(call inherit-product-if-exists, frameworks/native/build/phone-xxhdpi-3072-dalvik-heap.mk)
$(call inherit-product-if-exists, frameworks/native/build/phone-xxhdpi-3072-hwui-memory.mk)

# RIL / modem
# Use the MediaTek HIDL rild/libril wrapper instead of the AOSP rild, so
# telephony can find the radio HALs.
ENABLE_VENDOR_RIL_SERVICE := true
PRODUCT_PACKAGES += \
    rild \
    libccci_util \
    muxreport \
    terservice

# Wi-Fi / BT / connectivity
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0 \
    android.hardware.wifi@1.0-impl \
    android.hardware.wifi@1.0-service \
    lib_driver_cmd_mt66xx \
    libwifi-hal-mt66xx \
    hostapd \
    wificond \
    wifilogd \
    wpa_supplicant \
    wpa_supplicant.conf \
    wmt_loader \
    android.hardware.bluetooth@1.0-service.mtk

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/hostapd_default.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/hostapd_default.conf \
    $(COMMON_PATH)/configs/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
    $(COMMON_PATH)/configs/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf \
    $(LOCAL_PATH)/wifi/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
    $(LOCAL_PATH)/wifi/init.m6.wifi.rc:system/etc/init/init.m6.wifi.rc \
    $(COMMON_PATH)/configs/agps_profiles_conf2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/agps_profiles_conf2.xml \
    $(COMMON_PATH)/keylayout/ACCDET.kl:system/usr/keylayout/ACCDET.kl \
    $(COMMON_PATH)/keylayout/AVRCP.kl:system/usr/keylayout/AVRCP.kl \
    $(COMMON_PATH)/keylayout/mtk-kpd.kl:system/usr/keylayout/mtk-kpd.kl \
    $(COMMON_PATH)/keylayout/mtk-tpd.kl:system/usr/keylayout/mtk-tpd.kl \
    $(COMMON_PATH)/keylayout/Generic.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Generic.kl

# Keylayout: EventHub falls back to Generic.kl for the mBack button, whose
# key 102 is MOVE_HOME. Ship a Generic.kl override (key 102 -> HOME) in
# /vendor/usr/keylayout, which is searched first. With
# config_longPressOnHomeBehavior=2: press = Home, hold = Recents.

# Fingerprint TEE: microtrust.rc starts teei_daemon (post-fs-data) and
# goodixfp once soter.teei.init=INIT_OK.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/microtrust.rc:system/vendor/etc/init/microtrust.rc

# HALs
PRODUCT_PACKAGES += \
    hwservicemanager \
    vndservicemanager \
    servicemanager \
    mediaserver \
    libstlport

# Display
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.memtrack@1.0-impl \
    android.hardware.renderscript@1.0-impl \
    libRSDriver_mtk \
    libion \
    libui_ext \
    libgralloc_extra \
    libgui_ext \
    WallpaperPicker

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/egl.cfg:system/lib/egl/egl.cfg

# Thermal / power / lights / vibrator
PRODUCT_PACKAGES += \
    android.hardware.health@1.0-impl \
    android.hardware.health@1.0-service \
    android.hardware.thermal@1.0-impl \
    android.hardware.thermal@1.0-service \
    thermal_manager \
    android.hardware.power@1.0-impl \
    power.default \
    android.hardware.light@2.0-service.mtk

# Audio. Primary capture is not advertised yet.
PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-impl \
    android.hardware.audio@2.0-service.mtk \
    android.hardware.audio.effect@2.0-impl \
    audio.a2dp.default \
    audio.usb.default \
    audio.r_submix.default \
    libaudiopolicymanagerdefault \
    libaudio-resampler \
    libnbaio \
    libtinyalsa \
    libtinycompress \
    libtinymix \
    libtinyxml \
    libfs_mgr

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/configs/audio_device.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_device.xml \
    vendor/meizu/M6T/proprietary/vendor/etc/audio_policy.conf:system/etc/audio_policy.conf

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl.mtk \
    android.hardware.sensors@1.0-service.mtk

PRODUCT_COPY_FILES += \
    vendor/meizu/M6T/proprietary/vendor/lib/hw/sensors.mt6750.so:system/vendor/lib/hw/sensors.mt6750.so \
    vendor/meizu/M6T/proprietary/vendor/lib64/hw/sensors.mt6750.so:system/vendor/lib64/hw/sensors.mt6750.so \
    vendor/meizu/M6T/proprietary/etc/permissions/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    vendor/meizu/M6T/proprietary/etc/permissions/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
    vendor/meizu/M6T/proprietary/etc/permissions/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    vendor/meizu/M6T/proprietary/etc/permissions/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    vendor/meizu/M6T/proprietary/etc/permissions/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml

# Camera / GNSS / media
PRODUCT_PACKAGES += \
    android.hardware.gnss@1.0-impl \
    android.hardware.gnss@1.0-service \
    libstagefright_soft_avcenc \
    libstagefright_soft_aacdec \
    libstagefright_soft_aacenc \
    libstagefright_soft_amrdec \
    libstagefright_soft_amrnbenc \
    libstagefright_soft_amrwbenc \
    libstagefright_soft_avcdec \
    libstagefright_soft_flacdec \
    libstagefright_soft_flacenc \
    libstagefright_soft_g711dec \
    libstagefright_soft_gsmdec \
    libstagefright_soft_hevcdec \
    libstagefright_soft_mp3dec \
    libstagefright_soft_mpeg2dec \
    libstagefright_soft_mpeg4dec \
    libstagefright_soft_mpeg4enc \
    libstagefright_soft_opusdec \
    libstagefright_soft_rawdec \
    libstagefright_soft_vorbisdec \
    libstagefright_soft_vpxdec \
    libstagefright_soft_vpxenc \
    libcamera_parameters_mtk \
    libcam.client \
    libmtkshim_gui \
    libmmsdkservice.feature \
    libcurl \
    libandroid_net

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:system/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml \
    $(COMMON_PATH)/configs/media_codecs_performance.xml:system/etc/media_codecs_performance.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    $(COMMON_PATH)/configs/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(COMMON_PATH)/configs/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml \
    $(COMMON_PATH)/configs/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml \
    $(COMMON_PATH)/configs/media_codecs_firstboot.xml:system/etc/media_codecs.xml \
    $(COMMON_PATH)/configs/media_codecs_firstboot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(COMMON_PATH)/configs/seccomp_policy/mediacodec-vendor-empty.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    $(COMMON_PATH)/configs/mtk_omx_core.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/mtk_omx_core.cfg

# Keymaster / DRM / filesystems
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service \
    e2fsck \
    fibmap.f2fs \
    fsck.f2fs \
    mkfs.f2fs \
    make_ext4fs \
    resize2fs \
    setup_fs \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

# Fingerprint (Goodix)
# The legacy HAL (fingerprint.default.so) reports module API 2.0, which the
# AOSP @2.1 default service rejects; use the LineageOS @2.0 wrapper service,
# which still registers the V2_1 IBiometricsFingerprint interface.
# It is started by init.microtrust.rc once soter.teei.init=INIT_OK.
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.0-service

# The Nougat fingerprint.default.so needs the Nougat libkeymaster_messages.so;
# the system copy has a different C++ mangling. ld.config.txt prepends
# /vendor/lib64/fp_a7 (the matching Nougat blobs) to the [vendor] namespace
# search path. The [legacy] namespace is unchanged. The generic ld.config.txt
# module is removed so this copy is the only one installed.
PRODUCT_PACKAGES := $(filter-out \
    ld.config.txt \
    ,$(PRODUCT_PACKAGES))
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/ld.config.M6T.txt:system/etc/ld.config.txt

# Ramdisk
# Keep the platform init.rc and init.usb.rc; do not install the legacy
# common ones.
PRODUCT_COPY_FILES += \
    system/core/rootdir/init.zygote64.rc:root/init.zygote64.rc \
    system/core/rootdir/init.zygote64_32.rc:root/init.zygote64_32.rc \
    $(COMMON_PATH)/rootdir/init.mt6755.rc:root/init.mt6755.rc \
    $(COMMON_PATH)/rootdir/init.mt6755.rc:root/init.mt6750.rc \
    $(COMMON_PATH)/rootdir/init.mt6755.usb.rc:root/init.mt6755.usb.rc \
    $(COMMON_PATH)/rootdir/init.mt6755.usb.rc:root/init.mt6750.usb.rc \
    $(COMMON_PATH)/rootdir/init.rilproxy.rc:root/init.rilproxy.rc \
    $(COMMON_PATH)/rootdir/init.modem.rc:root/init.modem.rc \
    $(COMMON_PATH)/rootdir/init.nvdata.rc:root/init.nvdata.rc \
    $(COMMON_PATH)/rootdir/init.aee.rc:root/init.aee.rc \
    $(COMMON_PATH)/rootdir/init.project.rc:root/init.project.rc \
    $(COMMON_PATH)/rootdir/init.trace.rc:root/init.trace.rc \
    $(COMMON_PATH)/rootdir/init.xlog.rc:root/init.xlog.rc \
    $(COMMON_PATH)/rootdir/meta_init.rc:root/meta_init.rc \
    $(COMMON_PATH)/rootdir/meta_init.modem.rc:root/meta_init.modem.rc \
    $(COMMON_PATH)/rootdir/meta_init.project.rc:root/meta_init.project.rc \
    $(COMMON_PATH)/rootdir/vendor_init.mt6755.rc:root/vendor_init.mt6755.rc \
    $(COMMON_PATH)/rootdir/vendor_init.mt6755.rc:root/vendor_init.mt6750.rc \
    $(COMMON_PATH)/rootdir/factory_init.rc:root/factory_init.rc \
    $(COMMON_PATH)/rootdir/factory_init.project.rc:root/factory_init.project.rc \
    $(COMMON_PATH)/rootdir/fstab.mt6755:root/fstab.mt6755 \
    $(COMMON_PATH)/rootdir/fstab.mt6755:root/fstab.mt6750 \
    $(COMMON_PATH)/rootdir/ueventd.mt6755.rc:root/ueventd.mt6755.rc \
    $(COMMON_PATH)/rootdir/ueventd.mt6755.rc:root/ueventd.mt6750.rc \
    $(COMMON_PATH)/rootdir/enableswap.sh:root/enableswap.sh

# Boot diagnostics
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/forge-bootdiag.sh:system/bin/forge-bootdiag.sh \
    $(LOCAL_PATH)/m6-data-space-guard.sh:system/bin/m6-data-space-guard.sh \
    $(LOCAL_PATH)/forge-bootdiag.rc:system/etc/init/forge-bootdiag.rc

# LineageOS essentials
PRODUCT_PACKAGES += \
    LineageSettingsProvider \
    Trebuchet

DEVICE_PACKAGE_OVERLAYS := \
    $(COMMON_PATH)/overlay \
    $(LOCAL_PATH)/overlay

# Proprietary files
$(call inherit-product, vendor/meizu/M6T/M6T-vendor.mk)

# Legacy vendor daemons link stock core libraries from the vendor namespace.
PRODUCT_COPY_FILES += \
    vendor/meizu/M6T/proprietary/lib/libfs_mgr.so:system/vendor/lib/libfs_mgr.so \
    vendor/meizu/M6T/proprietary/lib64/libfs_mgr.so:system/vendor/lib64/libfs_mgr.so \
    vendor/meizu/M6T/proprietary/lib/liblogwrap.so:system/vendor/lib/liblogwrap.so \
    vendor/meizu/M6T/proprietary/lib64/liblogwrap.so:system/vendor/lib64/liblogwrap.so \
    vendor/meizu/M6T/proprietary/lib/libxml2.so:system/vendor/lib/libxml2.so \
    vendor/meizu/M6T/proprietary/lib64/libxml2.so:system/vendor/lib64/libxml2.so \
    vendor/meizu/M6T/proprietary/lib/libicui18n.so:system/vendor/lib/libicui18n.so \
    vendor/meizu/M6T/proprietary/lib64/libicui18n.so:system/vendor/lib64/libicui18n.so \
    vendor/meizu/M6T/proprietary/lib/libicuuc.so:system/vendor/lib/libicuuc.so \
    vendor/meizu/M6T/proprietary/lib64/libicuuc.so:system/vendor/lib64/libicuuc.so

# Camera provider service, so CameraService can fetch legacy/0 from
# hwservicemanager (64-bit camera HAL).
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-service

# Camera HAL shims (camera_compat), preloaded into mediaserver and the
# camera provider:
#   libm6_camera_glconsumer_compat - GLConsumer::getCurrentBuffer() ABI bridge
#   libm6_camera_tsf_bypass        - stubs the TSF/LSC path in libcamalgo.so
PRODUCT_PACKAGES += \
    libm6_camera_glconsumer_compat \
    libm6_camera_tsf_bypass

# Leave out soundtrigger; sensors are enabled.
PRODUCT_PACKAGES := $(filter-out \
    android.hardware.soundtrigger@2.0-impl \
    ,$(PRODUCT_PACKAGES))
PRODUCT_COPY_FILES := $(filter-out \
    %android.hardware.soundtrigger@2.0-impl.so:% \
    ,$(PRODUCT_COPY_FILES))

# GPS assistance (NTP time injection, SUPL/XTRA).
PRODUCT_COPY_FILES += \
    device/meizu/M6T/gps.conf:system/etc/gps.conf \
    device/meizu/M6T/gps.conf:system/vendor/etc/gps.conf

# Device identifier
PRODUCT_NAME := cm_M6T
PRODUCT_DEVICE := M6T
PRODUCT_BRAND := meizu
PRODUCT_MANUFACTURER := Meizu
PRODUCT_MODEL := M6T
PRODUCT_RELEASE_NAME := M6T
TARGET_OTA_ASSERT_DEVICE := M6T
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=cm_M6T \
    PRODUCT_DEVICE=M6T \
    TARGET_DEVICE=M6T
# ADB defaults
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.secure=0 \
    ro.debuggable=1 \
    ro.adb.secure=0
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.secure=0 \
    ro.debuggable=1 \
    ro.adb.secure=0 \
    persist.sys.usb.config=adb \
    persist.service.adb.enable=1 \
    persist.sys.adb.shell=/system/bin/sh

# Drop default HALs after all product inheritance.
PRODUCT_PACKAGES := $(filter-out \
    audio.primary.default \
    audio.primary.goldfish \
    audio_policy.default \
    audio_policy.goldfish \
    gralloc.default \
    gralloc.goldfish \
    gralloc.ranchu \
    camera.goldfish \
    camera.goldfish.jpeg \
    camera.ranchu \
    camera.ranchu.jpeg \
    fingerprint.goldfish \
    fingerprint.ranchu \
    gps.goldfish \
    gps.ranchu \
    lights.goldfish \
    power.goldfish \
    sensors.goldfish \
    sensors.ranchu \
    vibrator.goldfish, \
    $(PRODUCT_PACKAGES))
PRODUCT_COPY_FILES := $(filter-out \
    device/generic/goldfish/% \
    device/generic/mini-emulator-% \
    device/google/atv/init.goldfish.rc:% \
    %:root/fstab.goldfish \
    %:root/fstab.ranchu \
    %:root/init.goldfish.rc \
    %:root/init.ranchu.rc \
    %:root/ueventd.goldfish.rc \
    %:root/ueventd.ranchu.rc \
    %:system/etc/init.goldfish.sh \
    %:system/usr/idc/goldfish_rotary.idc \
    %:system/etc/permissions/com.meizu.camera.xml \
    %:system/lib/hw/audio.primary.default.so \
    %:system/lib64/hw/audio.primary.default.so \
    %:system/vendor/lib/hw/audio.primary.default.so \
    %:system/vendor/lib64/hw/audio.primary.default.so \
    %:system/lib/hw/audio.primary.goldfish.so \
    %:system/lib64/hw/audio.primary.goldfish.so \
    %:system/vendor/lib/hw/audio.primary.goldfish.so \
    %:system/vendor/lib64/hw/audio.primary.goldfish.so \
    %:system/lib/hw/audio_policy.default.so \
    %:system/lib64/hw/audio_policy.default.so \
    %:system/vendor/lib/hw/audio_policy.default.so \
    %:system/vendor/lib64/hw/audio_policy.default.so \
    %:system/lib/hw/audio_policy.goldfish.so \
    %:system/lib64/hw/audio_policy.goldfish.so \
    %:system/vendor/lib/hw/audio_policy.goldfish.so \
    %:system/vendor/lib64/hw/audio_policy.goldfish.so \
    %:system/lib/hw/gralloc.default.so \
    %:system/lib64/hw/gralloc.default.so \
    %:system/vendor/lib/hw/gralloc.default.so \
    %:system/vendor/lib64/hw/gralloc.default.so \
    %:system/lib/hw/gralloc.goldfish.so \
    %:system/lib64/hw/gralloc.goldfish.so \
    %:system/vendor/lib/hw/gralloc.goldfish.so \
    %:system/vendor/lib64/hw/gralloc.goldfish.so \
    %:system/lib/hw/gralloc.ranchu.so \
    %:system/lib64/hw/gralloc.ranchu.so \
    %:system/vendor/lib/hw/gralloc.ranchu.so \
    %:system/vendor/lib64/hw/gralloc.ranchu.so \
    %:system/lib/hw/camera.goldfish.so \
    %:system/lib64/hw/camera.goldfish.so \
    %:system/lib/hw/camera.goldfish.jpeg.so \
    %:system/lib64/hw/camera.goldfish.jpeg.so \
    %:system/lib/hw/camera.ranchu.so \
    %:system/lib64/hw/camera.ranchu.so \
    %:system/lib/hw/camera.ranchu.jpeg.so \
    %:system/lib64/hw/camera.ranchu.jpeg.so \
    %:system/lib/hw/fingerprint.goldfish.so \
    %:system/lib64/hw/fingerprint.goldfish.so \
    %:system/lib/hw/fingerprint.ranchu.so \
    %:system/lib64/hw/fingerprint.ranchu.so \
    %:system/lib/hw/gps.goldfish.so \
    %:system/lib64/hw/gps.goldfish.so \
    %:system/lib/hw/gps.ranchu.so \
    %:system/lib64/hw/gps.ranchu.so \
    %:system/lib/hw/lights.goldfish.so \
    %:system/lib64/hw/lights.goldfish.so \
    %:system/lib/hw/power.goldfish.so \
    %:system/lib64/hw/power.goldfish.so \
    %:system/lib/hw/sensors.goldfish.so \
    %:system/lib64/hw/sensors.goldfish.so \
    %:system/lib/hw/sensors.ranchu.so \
    %:system/lib64/hw/sensors.ranchu.so \
    %:system/lib/hw/vibrator.goldfish.so \
    %:system/lib64/hw/vibrator.goldfish.so \
    %:system/vendor/lib/hw/gralloc.mt6755.so \
    %:system/vendor/lib64/hw/gralloc.mt6755.so \
    %:system/vendor/lib/hw/hwcomposer.mt6755.so \
    %:system/vendor/lib64/hw/hwcomposer.mt6755.so \
    %:system/vendor/lib/hw/keystore.mt6750.so \
    %:system/vendor/lib64/hw/keystore.mt6750.so, \
    $(PRODUCT_COPY_FILES))
PRODUCT_CHARACTERISTICS := phone
