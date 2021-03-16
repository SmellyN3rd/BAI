lsblk -do NAME,SIZE
echo 
read -p 'Pick the drive to install to: ' DRIVE
DRIVE=/dev/$DRIVE
SWAPSIZE=+$(grep MemTotal /proc/meminfo | awk '{print $2 / 900000}')G

(
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
  echo;
  echo;

  echo w;
) | fdisk $DRIVE

mkfs.ext4  $DRIVE\2 -L root
mkswap $DRIVE\1 -L swap

mount $DRIVE\2 /mnt
swapon $DRIVE\1

pacstrap /mnt base base-devel linux-lts linux-firmware nano dhcpcd netctl

genfstab -pU /mnt >> /mnt/etc/fstab
