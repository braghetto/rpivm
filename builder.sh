#!/bin/bash


IMG_FILE_NAME="rpi-os.img"
IMG_OFFSET=4194304
IMG_FILE_URL="https://downloads.raspberrypi.org/raspios_lite_arm64/images/raspios_lite_arm64-2022-09-26/2022-09-22-raspios-bullseye-arm64-lite.img.xz"

# Download RaspiOS image
if [ ! -f $IMG_FILE_NAME ]
then
    wget --show-progress $IMG_FILE_URL -O $IMG_FILE_NAME.xz
    unxz $IMG_FILE_NAME.xz
fi

# mount point
mkdir mnt

# Mount image
sudo mount -o loop,offset=$IMG_OFFSET $IMG_FILE_NAME $(pwd)/mnt

# Enable sshd and default login user
sudo touch mnt/ssh.txt
sudo touch mnt/userconf.txt
echo 'pi:$6$c70VpvPsVNCG0YR5$l5vWWLsLko9Kj65gcQ8qvMkuOoRkEagI90qi3F/Y7rm8eNYZHW8CY6BOIKwMH7a3YYzZYL90zf304cAHLFaZE0' | sudo tee mnt/userconf.txt

# Copy kernel and dtb
cp mnt/kernel8.img .
cp mnt/bcm2710-rpi-3-b-plus.dtb .

# Umount image
sudo umount $(pwd)/mnt
rm -rf mnt

# Build container
docker build . -t rpivm

# Cleanup
rm kernel8.img
rm bcm2710-rpi-3-b-plus.dtb
rm rpi-os.img
