ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime 

echo archbox > /etc/hostname 

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen 
echo "pl_PL.UTF-8 UTF-8" >> /etc/locale.gen 
locale-gen 
echo 'LANG="pl_PL.UTF-8"' > /etc/locale.conf 

mkinitcpio -p linux-lts

echo KEYMAP=pl > /etc/vconsole.conf 
echo FONT=Lat2-Terminus16.psfu.gz >> /etc/vconsole.conf 
echo FONT_MAP=8859-2 >> /etc/vconsole.conf 

echo '[multilib]' >> /etc/pacman.conf 
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf 
pacman -Syy 

pacman -S grub dialog wpa_supplicant networkmanager network-manager-applet ppp --noconfirm  

clear
cat drive.tmp
cat drive.tmp | grub-install --recheck 
sleep 10
grub-mkconfig -o /boot/grub/grub.cfg 

rm drive.tmp
clear 

echo enter root password 
passwd
read -p "enter your username: " username 
useradd -m -g users -G wheel,storage,power -s /bin/bash $username 
echo enter password for the user $username
passwd $username 
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers 

systemctl enable NetworkManager
exit
