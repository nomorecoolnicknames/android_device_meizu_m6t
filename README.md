# Meizu M6T (M6T)

Device tree for the Meizu M6T for LineageOS 18.1.

## Specifications

| | |
| --- | --- |
| Codename | `M6T` (model M811H) |
| SoC | MediaTek MT6750 |
| CPU | 8x Cortex-A53 |
| GPU | Mali-T860MP2 |
| Display | 720 x 1440 |
| Kernel | Linux 3.18 (prebuilt) |

## Status

- Booted on hardware: untested
- Display / touch: untested
- Wi-Fi: untested
- Bluetooth: untested
- SIM / calls / data: untested
- Camera: untested
- Audio, sensors, fingerprint, GPS: untested
- SELinux: permissive

## Building

Sync the LineageOS 18.1 sources, place this tree at `device/meizu/M6T` and
provide the external inputs:

- vendor blobs in `device/meizu/M6T/proprietary/` (paths in `vendor-blobs.mk`)
- kernel source in `kernel/meizu/M6T` (used for headers)
- prebuilt kernel at `device/meizu/M6T/prebuilt/Image.gz-dtb`
- the matching legacy MediaTek framework/HAL adaptations

```sh
source build/envsetup.sh
breakfast M6T
brunch M6T
```

See the [ReMeizu project](https://github.com/nomorecoolnicknames/remeizu) for
the related device, common and kernel trees.
