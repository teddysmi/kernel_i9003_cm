#!/bin/bash -x
CYANOGENMOD=../../..
TOOLCHAIN=$CYANOGENMOD/prebuilt/linux-x86/toolchain
# Make mrproper
make mrproper

#Patch toolchain

export CROSS_COMPILE=$TOOLCHAIN/arm-eabi-4.4.3/bin/arm-eabi-

# Set config
make latona_galaxysl_defconfig

# Make modules
nice -n 10 make -j8 modules

# Copy modules
find -name '*.ko' -exec cp -av {} $CYANOGENMOD/device/samsung/galaxysl/modules/ \;

# Build kernel
nice -n 10 make -j8 zImage

# Copy kernel
cp arch/arm/boot/zImage $CYANOGENMOD/device/samsung/galaxysl/kernel

# Make mrproper
make mrproper

