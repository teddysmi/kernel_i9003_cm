#!/bin/bash

echo "Builder made for samsung i9003"
echo "Requieriments to build"
echo "ubuntu 10.04 or higher"
#--------------------------------------------------------------------------------------------------------------#
echo "Installing packages"

#sudo apt-get install git-core gnupg flex bison gperf libsdl-dev libesd0-dev libwxgtk2.6-dev build-essential zip curl libncurses5-dev zlib1g-dev
#--------------------------------------------------------------------------------------------------------------#
TOOLCHAIN=$HOME/kernel_i9003_cm/toolchain/
KERNEL=$HOME/kernel_i9003_cm/kernel/
#ramdisk modules
STRIP=$HOME/kernel_i9003_cm/tmp
HEIMDALL=$BUILD/tools/heimdall/
ZIMAGE=$KERNEL/arch/arm/boot/
#patch your cm
CM7=$HOME/cm71/device/samsung/galaxysl/modules
PCK=$BUILD/kernel_build/
#--------------------------------------------------------------------------------------------------------------#
#add permit
sudo chmod -R 0777 $HOME/kernel_i9003_cm/
#--------------------------------------------------------------------------------------------------------------#
# Export to where the cross compiler is and the compiler we are building for arm.
cd $KERNEL
export ARCH=arm
export CROSS_COMPILE=$TOOLCHAIN/arm-eabi-4.4.3/bin/arm-eabi-
#--------------------------------------------------------------------------------------------------------------#
echo "Clean de directory an kernel"
cd $KERNEL
make mrproper
cd $BUILD
#find -name '*.img' -exec rm  {} \;
#find -name 'zImage' -exec rm  {} \;
#find -name '*.gz' -exec rm  {} \;

cd $STRIP
find -name '*.ko' -exec rm  {} \;
#--------------------------------------------------------------------------------------------------------------#
echo 'Make defconfig'
cd $KERNEL
make latona_galaxysl_defconfig

#--------------------------------------------------------------------------------------------------------------#
echo "Add new modules with de config EXPERIMENTAL"
#make menuconfig
#--------------------------------------------------------------------------------------------------------------#
echo "=================================================================================="
echo "Build kernel"
echo "=================================================================================="
cd $KERNEL
nice -n 10 make -j8 modules


#--------------------------------------------------------------------------------------------------------------#
#striping modules to decrease size.
cd $KERNEL
sudo find -name '*.ko' -exec cp -av {} $STRIP/ \;


#--------------------------------------------------------------------------------------------------------------#
cd $STRIP

cp $STRIP/rfs_glue.ko $MODULES5/
cp $STRIP/param.ko $MODULES5/
cp $STRIP/j4fs.ko  $MODULES5/
cp $STRIP/ext4.ko $MODULES5/
cp $STRIP/rfs_fat.ko  $MODULES5/
cp $STRIP/fsr_stl.ko $MODULES5/
cp $STRIP/j4fs.ko  $MODULES5/
cp $STRIP/fsr.ko  $MODULES5/




#--------------------------------------------------------------------------------------------------------------#Cyanogenify

# Copy modules
cd $KERNEL
find -name '*.ko' -exec cp -av {} $CM7/ \;

#Build zimage

nice -n 10 make -j8 zImage


#--------------------------------------------------------------------------------------------------------------#build pckg

        cd $ZIMAGE
	sudo cp zImage $HOME/cm71/device/samsung/galaxysl/kernel	




"
