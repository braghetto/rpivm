# Raspberry Pi 3B+ Qemu Container
This docker container emulates a Raspberry Pi 3B+ board using qemu native emulation and official RaspiOS.

## VM Specifications
* Raspberry Pi 3B+
* RaspiOS Bullseye Lite 64Bits (2022-09-22)
* This raspios image was modified to enable ssh and default user pi

## Build
* Builder script will download the raspios image, modify it and extract needed files.
* Builder script will use sudo, must be executed only inside repo folder.
* Clone this repo: `git clone https://github.com/braghetto/rpivm.git`
* Change to repo folder: `cd rpivm`
* Execute builder script: `./builder.sh`

## Run
* Run your build:
* `docker run -it rpivm:latest`

## Login
* Default user: pi
* Default password: raspberry
* SSH port: 5022

## Extend root partition
* Just execute this script:
* `/boot/resizeme.sh`
* Or into your rpi:
* `sudo parted /dev/mmcblk0 resizepart 2 15GB`
* `partprobe`
* `sudo resize2fs /dev/mmcblk0p2`
