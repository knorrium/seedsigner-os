# Raspberry Pi Zero emulation image

This repository includes an experimental, standalone emulation image for the
original Raspberry Pi Zero / Zero W and the Waveshare 1.3-inch 240x240 ST7789VW
LCD HAT used by SeedSigner.

> **Do not use this image to sign Bitcoin transactions.** It is intentionally a
> separate appliance with a larger attack surface. It does not contain the
> SeedSigner application and cannot switch back into signing mode.

## Included systems

- Game Boy and Game Boy Color (Gambatte)
- Nintendo Entertainment System (FCEUmm)

The original Zero has one ARMv6 core and 512 MB RAM. More demanding systems are
outside the supported scope of this target.

## Build

Initialize the pinned Buildroot submodule, then use the normal Docker build:

```bash
git submodule update --init --recursive
export DOCKER_DEFAULT_PLATFORM=linux/amd64
SS_ARGS="--pi0 --emulation" docker compose up --force-recreate --build
```

The image is written to `images/seedsigner_os.<app-branch>.pi0-emu.img`. The
emulation target does not clone or bundle the SeedSigner application; the app
branch only remains in the output filename for compatibility with the existing
build script.

A native build is also possible after installing the dependencies documented in
[without_docker.md](without_docker.md):

```bash
cd opt
./build.sh --pi0 --emulation
```

## Storage and ROMs

The image has two partitions:

1. a 256 MiB FAT boot partition;
2. a 512 MiB ext4 partition labeled `seedsigner-roms`.

On first boot the second partition is mounted at `/mnt/romdata` and these
folders are created:

```text
roms/gb
roms/nes
saves
states
config
```

No copyrighted ROMs are included. Copy ROMs you are legally entitled to use to
the matching directory before booting. The data partition is mounted with
`nodev,nosuid,noexec`.

## Controls

| HAT control | Function |
| --- | --- |
| Joystick | Direction / menu navigation |
| Joystick press | Start / confirm |
| KEY1 | A |
| KEY2 | B |
| KEY3 | Select / RetroArch menu |

The controls are exposed through Linux `gpio-key` overlays and consumed as an
SDL keyboard. Audio is disabled because the Zero and LCD HAT provide no speaker
or audio jack.

## Display design

Generic RetroPie, Lakka, and Recalbox images normally render to HDMI and do not
drive the SeedSigner HAT. This target renders RetroArch to a forced 240x240
VideoCore framebuffer, then uses a pinned ARMv6 build of `fbcp-ili9341`'s
Waveshare ST7789VW backend to transfer frames over SPI. This is why copying only
`config.txt` into another distribution is insufficient.

The display mirror uses legacy VideoCore/DispmanX APIs that match the pinned
Raspberry Pi 5.15 kernel and userland in this repository. Updating those
components requires hardware retesting.
