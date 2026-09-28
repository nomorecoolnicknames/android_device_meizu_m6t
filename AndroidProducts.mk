# Use the explicit name:path form; a path-only entry derives the product
# name from the file name.
PRODUCT_MAKEFILES := \
    lineage_M6T:$(LOCAL_DIR)/lineage.mk

COMMON_LUNCH_CHOICES := \
    lineage_M6T-userdebug \
    lineage_M6T-eng
