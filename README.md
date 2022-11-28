# Raspberry Pi 3B+ Qemu Container
This docker container emulates a Raspberry Pi 3B+ board using qemu native emulation and official RaspiOS.

## VM Specifications
* Raspberry Pi 3B+
* RaspiOS Bullseye Lite 64Bits (2022-09-22)
* This raspios image was modified to enable ssh and default user pi

## Build
* Builder script will download the raspios image, modify it and extract neeeded files.
* Builder script will use sudo, must be executed only inside repo folder.
* Clone this repo: `git clone https://github.com/braghetto/rpivm.git`
* Cd to repo folder: `cd rpivm`
* Execute builder script: `./builder.sh`

## Run
* Run your own build:
* `docker run -it rpivm`
* Run my dockerhub build:
* `docker run -it arthurmb/rpivm:latest`

## Login
* Default user: pi
* Default password: raspberry
* SSH port: 5022
