lsblk -do NAME,SIZE
echo 
read -p 'Pick the drive to install to: ' DRIVE
DRIVE=/dev/$DRIVE
SWAPSIZE=+$(grep MemTotal /proc/meminfo | awk '{print $2 / 900000}')G

(
  echo d;
  echo d;
  echo d;
  echo d;
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

pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl

genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime && hwclock --systohc && echo archbox > /etc/hostname && echo "pl_PL.UTF-8 UTF-8" >> /etc/locale.gen && echo 'LANG="pl_PL.UTF-8"' > /etc/locale.conf && locale-gen && echo KEYMAP=de-latin1 > /etc/vconsole.conf && mkinitcpio -p linux && echo '[multilib]' >> /etc/pacman.conf && echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf && pacman -Syy && pacman -S dialog wpa_supplicant --noconfirm  && pacman -S grub --noconfirm  && PART=$(df / | grep / | cut -d" " -f1) && grub-install $PART && grub-mkconfig -o /boot/grub/grub.cfg && clear && echo enter root password && passwd && read -p "enter your username: " username && useradd -m -g users -G wheel -s /bin/bash $username && echo enter password for the new user && passwd $username && echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers && reboot
