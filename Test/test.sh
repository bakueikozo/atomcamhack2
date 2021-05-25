#!/bin/sh

#set -x

echo "called from app_init.sh"

echo "overmount busybox and passwords"

cp /tmp/Test/busybox /tmp
cp /tmp/Test/passwd /tmp
cp /tmp/Test/shadow /tmp

mount -o bind /tmp/busybox /bin/busybox
mount -o bind /tmp/passwd /etc/passwd
mount -o bind /tmp/shadow /etc/shadow


echo "run original scripts"

/system/bin/hl_client &
/system/bin/iCamera_app &
/system/bin/dongle_app &

sleep 3


tcpsvd -vE 0.0.0.0 21 busybox ftpd / &
ProcessName=telnetd

while true
do
count=`ps | grep $ProcessName | grep -v grep | wc -l`
if [ $count = 0 ]; then
  echo "$ProcessName is dead."
  telnetd 
else
  echo "$ProcessName is alive."
fi
sleep 5
done


echo "finish. login root from UART or telnet"

#echo "make overmount filesystems"

#mkdir /tmp/dump
#mount /dev/mmcblk0p1 /tmp/dump
#mkdir /tmp/dump/rw
#mkdir /tmp/dump/rw/rootfs
#mkdir /tmp/dump/rw/app

#dd if=/dev/mtdblock0 of=/tmp/dump/0_boot.bin
#dd if=/dev/mtdblock1 of=/tmp/dump/1_kernel.bin

#if [ ! -e "/tmp/dump/rootfs.org" ];then
#	dd if=/dev/mtdblock2 of=/tmp/dump/rootfs.org
#	cp /tmp/dump/rootfs.org /tmp/dump/rootfs.bin
#	mount /tmp/dump/rootfs.bin /tmp/dump/rw/rootfs
#fi

#if [ ! -e "/tmp/dump/app.org" ];then
#	dd if=/dev/mtdblock3 of=/tmp/dump/app.org
#	cp /tmp/dump/app.org /tmp/dump/app.bin
#	mount /tmp/dump/app.bin /tmp/dump/rw/app
#fi

#umount /tmp/dump/rw/app
#umount /tmp/dump/rw/rootfs

#dd if=/dev/mtdblock4 of=/tmp/dump/4_kback.bin
#dd if=/dev/mtdblock5 of=/tmp/dump/5_aback.bin
#dd if=/dev/mtdblock6 of=/tmp/dump/6_cfg.bin
#dd if=/dev/mtdblock7 of=/tmp/dump/7_para.bin



