#!/bin/sh

qemu-img resize rpi-os.img 16G

qemu-system-aarch64 \
--machine raspi3b \
--cpu cortex-a53 \
-smp 4 --m 1024m \
--drive format=raw,file=rpi-os.img -netdev user,id=net0,hostfwd=tcp::5022-:22 -device usb-net,netdev=net0 \
--dtb bcm2710-rpi-3-b-plus.dtb \
--kernel kernel8.img \
--append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1 rootwait panic=1 dwc_otg.fiq_fsm_enable=0" \
--no-reboot \
--display none \
--serial mon:stdio -usb -device usb-mouse -device usb-kbd
