# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
# lineage_M6T.mk - Meizu M6T (M6T / M811H), MediaTek MT6750

# arm64 with a 32-bit second ABI.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from the device configuration.
$(call inherit-product, device/meizu/M6T/device.mk)

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Device identifier. The codename is case-sensitive.
PRODUCT_DEVICE := M6T
PRODUCT_NAME := lineage_M6T
PRODUCT_BRAND := Meizu
PRODUCT_MODEL := M6T
PRODUCT_MANUFACTURER := Meizu

PRODUCT_GMS_CLIENTID_BASE := android-meizu

# Shipped with Android 7.0.
PRODUCT_SHIPPING_API_LEVEL := 24

# Force full Treble (linker namespaces, split sepolicy, VINTF enforcement)
# without raising the shipping API level.
PRODUCT_FULL_TREBLE_OVERRIDE := true

PRODUCT_CHARACTERISTICS := phone

# Boot animation
TARGET_BOOT_ANIMATION_RES := 720

# Build fingerprint
PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=MeizuM6T \
    PRIVATE_BUILD_DESC="Meizu_M6T_RU-user 7.0 NRD90M 1550240131 release-keys"

BUILD_FINGERPRINT := Meizu/Meizu_M6T_RU/MeizuM6T:7.0/NRD90M/1550240131:user/release-keys

# Dual SIM
PRODUCT_PROPERTY_OVERRIDES += \
    persist.radio.multisim.config=dsds \
    ro.telephony.default_network=10,10

# This branch targets Android 11 (API 30) only.
ifneq ($(PLATFORM_SDK_VERSION),30)
$(error M6T lineage-18.1 requires PLATFORM_SDK_VERSION=30)
endif
