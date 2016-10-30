#!bin/bash

read -p "Do you want to clean the kernel? yes/no:" re
while [ "${re}" != "yes" -a \
        "${re}" != "y" -a \
        "${re}" != "YES" -a \
        "${re}" != "Y" -a \
        "${re}" != "no" -a \
        "${re}" != "n" -a \
        "${re}" != "NO" -a \
        "${re}" != "N" ]
do
    read -p "Do you want to clean the kernel? yes/no:" re
done
 
if [ "${re}" = "yes" -o \
     "${re}" = "y" -o \
     "${re}" = "YES" -o \
     "${re}" = "Y" ];then
    make mrproper
    make clean
    rm -rf dist/
else
    echo "skip"
fi
 
read -p "Which defconfig:
(1)bcm2709_defconfig
(2)defconfig
(3)skip
" def

until [ -n "${def}" ]
do
    read -p "Which defconfig:" def
done

if [ "${def}" = "1" ]; then
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
elif [ "${def}" = "2" ]; then
    make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- defconfig
elif [ "${def}" = "3" ]; then
    echo "skip"    
else
    echo "Wrong input!"
    exit
fi

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig

read -p "How many threads for compile or skip: " num 

until [ -n "${num}" ]
do
    read -p "How many threads for compile:" num
done

if [ "${num}" = "skip" ]; then
    echo "skip"
else
    make -j ${num} ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs 2> error_log
fi

##read -p "Module install path:" mod

##until [ -n "${mod}" ]
##do
##    read -p "Module install path:" mod
##done

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=dist modules_install

#read -p "Do you want to compress boot & modules? yes/no:" re

#while [ "${re}" != "yes" -a \
#	"${re}" != "y" -a \
#	"${re}" != "YES" -a \
#	"${re}" != "Y" -a \
#	"${re}" != "no" -a \
#	"${re}" != "n" -a \
#	"${re}" != "NO" -a \
#	"${re}" != "N" ]
#do
#    read -p "Do you want compress boot & modules? yes/no:" re
#done

#if [ "${re}" = "yes" -o \
#     "${re}" = "y" -o \
#     "${re}" = "YES" -o \
#     "${re}" = "Y" ];then
#    tar Jcvf boot.tar.xz arch/arm/boot
#    tar Jcvf modules.tar.xz dist/lib/modules
#else
#    exit
#fi




