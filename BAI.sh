clear
lsblk -do NAME,SIZE
echo 
read -p 'Pick the drive to install to: ' DRIVE
DRIVE=/dev/$DRIVE
SWAPSIZE=+$(grep MemTotal /proc/meminfo | awk '{print $2 / 900000}')G

echo
echo -ne partitioning the drive... && dd if=/dev/zero of=$DRIVE bs=512 count=1 conv=notrunc &> /dev/null && (
  echo o;

  echo n;
  echo;
  echo;
  echo;
  echo $SWAPSIZE;

  echo n;
  echo;
  echo;
  echo;
  echo a;
  echo;

  echo w;
) | fdisk $DRIVE &> /dev/null && echo done

echo -ne creating file systems... && mkfs.ext4  $DRIVE\2 -L root &> /dev/null && mkswap $DRIVE\1 -L swap &> /dev/null && echo done

echo -ne mounting partitions... && mount $DRIVE\2 /mnt &> /dev/null && swapon $DRIVE\1 &> /dev/null && echo done

echo -ne downloading needed files and creating the file structure... && pacstrap /mnt base base-devel linux-lts linux-firmware reflector &> /dev/null && echo done

echo -ne generating fstab... && genfstab -U -p /mnt >> /mnt/etc/fstab && echo done
echo $DRIVE > /mnt/drive.tmp

echo
read -p 'choose your language (available: en, pl): ' LANG

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/SmellyN3rd/BAI/main/chroot_$LANG.sh)"
reboot
