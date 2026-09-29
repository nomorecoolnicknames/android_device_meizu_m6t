# Meizu M6T (M6T)

Device tree for the Meizu M6T for LineageOS 16.0.

## Specifications

| | |
| --- | --- |
| Codename | `M6T` |
| SoC | MediaTek MT6750 |
| CPU | Cortex-A53 |
| GPU | Mali-T860 |
| Display | 720 x 1440 |
| Kernel | Linux 3.18 (stock prebuilt, optional source build) |

## Status

- Booted on hardware: untested
- Display / touch: untested
- Wi-Fi: untested
- Bluetooth: untested
- SIM / calls / data: untested
- Camera: untested
- Audio, sensors, fingerprint: untested
- GPS: location fix untested

## Building

Sync the LineageOS 16.0 sources, place this tree at `device/meizu/M6T` and
provide the external inputs:

- common tree in `device/meizu/m3_meizu_m6-common`
- matching `vendor/mediatek` sources, including the MediaTek telephony headers
- vendor tree in `vendor/meizu/M6T`
- kernel source in `kernel/meizu/M6T/kernel-3.18`
- prebuilt kernel at `device/meizu/M6T/prebuilt-kernel/Image.gz-dtb`

```sh
source build/envsetup.sh
breakfast M6T
brunch M6T
```

To build the kernel from source, set `M6_KERNEL_FROM_SOURCE=true`
(`M6T_defconfig`). The in-tree AArch64 GCC 4.9 is used; if it is missing, set
an absolute `M6T_KERNEL_CROSS_COMPILE_PREFIX`.

See the [ReMeizu project](https://github.com/nomorecoolnicknames/remeizu) for
the related device, common and kernel trees. Historical upstream notes are in
[UPSTREAM_README.md](UPSTREAM_README.md).
