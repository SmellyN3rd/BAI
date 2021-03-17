ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime 
hwclock --systohc 
echo archbox > /etc/hostname 
echo "pl_PL.UTF-8 UTF-8" >> /etc/locale.gen 
locale-gen 
echo 'LANG="pl_PL.UTF-8"' > /etc/locale.conf 
echo KEYMAP=pl > /etc/vconsole.conf 
echo FONT=Lat2-Terminus16.psfu.gz >> /etc/vconsole.conf 
echo FONT_MAP=8859-2 >> /etc/vconsole.conf 
echo '[multilib]' >> /etc/pacman.conf 
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf 
pacman -Syy 
pacman -S dialog wpa_supplicant networkmanager network-manager-applet ppp --noconfirm  
pacman -S grub --noconfirm  
mkinitcpio -p linux-lts
grub-install --target=x86_64 --recheck
grub-mkconfig -o /boot/grub/grub.cfg 
clear 
echo enter root password 
passwd su
read -p "enter your username: " username 
useradd -m -g users -G wheel,storage,power -s /bin/bash $username 
echo enter password for the new user 
passwd $username 
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers 
systemctl enable NetworkManager
exit
