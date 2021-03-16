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
PART=$(df / | grep / | cut -d" " -f1) 
grub-install $PART::-1 
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
reboot
