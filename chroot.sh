if [ "$(stat -c %d:%i /)" != "$(stat -c %d:%i /proc/1/root/.)" ]; then
  echo "We are chrooted!"
else
  echo "Business as usual"
fi

sleep 10
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime 
hwclock --systohc 
echo archbox > /etc/hostname 
echo "pl_PL.UTF-8 UTF-8" >> /etc/locale.gen 
echo 'LANG="pl_PL.UTF-8"' > /etc/locale.conf 
locale-gen 
echo KEYMAP=de-latin1 > /etc/vconsole.conf 
echo '[multilib]' >> /etc/pacman.conf 
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf 
pacman -Syy 
pacman -S dialog wpa_supplicant networkmanager network-manager-applet ppp --noconfirm  
pacman -S grub --noconfirm  
mkinitcpio -p linux-lts
grub-install
grub-mkconfig -o /boot/grub/grub.cfg 
clear 
echo enter root password 
passwd 
read -p "enter your username: " username 
useradd -m -g users -G wheel -s /bin/bash $username 
echo enter password for the new user 
passwd $username 
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers 
systemctl enable NetworkManager
