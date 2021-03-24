echo -ne setting timezone... && ln -sf /usr/share/zoneinfo/US/Central /etc/localtime && echo done

echo -ne setting hostname... && echo archbox > /etc/hostname && echo done

echo -ne generating locales... && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen &> /dev/null && echo 'LANG="en_US.UTF-8"' > /etc/locale.conf && echo done

echo -ne running mkinitcpio... && mkinitcpio -p linux-lts &> /dev/null && echo done

echo -ne configuring vconsole... && echo KEYMAP=us > /etc/vconsole.conf && echo FONT=Lat2-Terminus16.psfu.gz >> /etc/vconsole.conf && echo FONT_MAP=8859-2 >> /etc/vconsole.conf && echo done

echo -ne configuring pacman and the mirrorlist... && echo '[multilib]' >> /etc/pacman.conf && echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf && reflector --country US --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist &> /dev/null && pacman -Syy &> /dev/null && echo done 

echo -ne configuring networking utilities... && pacman --noconfirm -S wpa_supplicant networkmanager &> /dev/null && systemctl enable NetworkManager &> /dev/null && echo done

echo -ne configuring the sudoers file... && echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && echo done

echo -ne installing bootloader... && pacman --noconfirm -S grub &> /dev/null && grub-install --recheck $(<drive.tmp) &> /dev/null && grub-mkconfig -o /boot/grub/grub.cfg &> /dev/null && rm drive.tmp && echo done

echo
echo enter root password 
passwd

exit
