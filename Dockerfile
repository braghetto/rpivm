### Build stage
FROM debian:stable-slim AS builder
ARG QEMU_VERSION=7.1.0
ENV QEMU_TARBALL="qemu-${QEMU_VERSION}.tar.xz"
WORKDIR /qemu

# Install qemu build deps
RUN apt-get update
RUN apt-get -y install \
python \
build-essential \
libglib2.0-dev \
libpixman-1-dev \
ninja-build \
libfdt-dev \
zlib1g-dev \
flex bison \
libnuma-dev \
libqtest-ocaml-dev \
pkg-config

# Get qemu source
ADD "https://download.qemu.org/${QEMU_TARBALL}" .
RUN tar xvf "${QEMU_TARBALL}"

# Build qemu
RUN cd qemu-${QEMU_VERSION} && ./configure --static --disable-gio --target-list=arm-softmmu,aarch64-softmmu
RUN cd qemu-${QEMU_VERSION} && make -j$(nproc)
RUN cd qemu-${QEMU_VERSION}/build && \
    mv qemu-system-arm /qemu && \
    mv qemu-system-aarch64 /qemu && \
    mv qemu-img /qemu 

# Strip binaries to reduce size
RUN strip qemu-system-arm qemu-system-aarch64 qemu-img


### Build rpi emulator container
FROM busybox:1.35 AS rpivm
LABEL maintainer="Arthur Braghetto <arthurmb@gmail.com>"

# Include qemu binaries from build stage
COPY --from=builder /qemu/qemu-system-arm /usr/local/bin/qemu-system-arm
COPY --from=builder /qemu/qemu-system-aarch64 /usr/local/bin/qemu-system-aarch64
COPY --from=builder /qemu/qemu-img /usr/local/bin/qemu-img

# Include raspios image, board specs, kernel and entrypoint script 
ADD ./rpi-os.img /rpi-os.img
ADD ./bcm2710-rpi-3-b-plus.dtb /bcm2710-rpi-3-b-plus.dtb
ADD ./kernel8.img /kernel8.img
ADD ./run.sh /run.sh

# Run
ENTRYPOINT ["./run.sh"]
