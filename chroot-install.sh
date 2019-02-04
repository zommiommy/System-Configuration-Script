#!/bin/bash
##########################################################
# Script to be run inside the chroot during the installation
##########################################################
# Helper functions
##########################################################
function pause {
               read -rsp $'Press enter to continue...\n'
           }

##########################################################
# Configurations 
##########################################################
USER_NAME="userino"
PASSWD="testerino"

ROOT_PASSWD=PASSWD

##########################################################

# Add the networkmanager start on startup
systemctl enable NetworkManager

##########################################################
# Bootloader Installation
##########################################################
# Silently install Grub
pacman --noconfirm -S grub efibootmgr

pause
# Install Grub
grub-install --target=i386-pc $DISK
# Make the configs
grub-mkconfig -o /boot/grub/grub.cfg

# Install microcode
# For Intel
pacman -S intel-ucode
# For Amd
# pacstrap /mnt amd-ucode
# Update Grub to get the microcode working
grub-mkconfig -o /boot/grub/grub.cfg

pause

##########################################################
# System configuration
##########################################################
# Set Time Zone
ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
# Generate the file /etc/adjtime
hwclock --systohc
# Set the configuration of the localization
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
# Generate the locale
locale-gen
# Set the Locale of the system
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
# Set the Kayboard layout of the system
echo "KEYMAP=us-latin1" >> /etc/vconsole.conf
# Set hostname
echo $HOSTNAME >> /etc/hostname
# Complete the hosts file
echo "127.0.0.1     $HOSTNAME" >> /etc/hostname
echo "::1           $HOSTNAME" >> /etc/hostname
echo "127.0.0.1     $HOSTNAME.locadomain $HOSTNAME" >> /etc/hostname
# OPTIONAL
# Generate RamDisk image using the linux preset
#mkinitcpio -p linux
# END OPTIONAL
# Set Root Password
echo "$ROOT_PASSWD" | passwd --stdin
# Add the user
adduser "$USER"
# Set the password of the user
echo "$PASSWD" | passwd "$USER" --stdin

pause
# Silently update the System 
pacman --noconfirm -Syu

pause
# Remove system beeps
rmmod pcspkr
echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
##########################################################
# Install stuff
##########################################################
# Install fonts
pacman --noconfirm -S noto-fonts
pacman --noconfirm -S nerd-fonts-complete
pacman --noconfirm -S fish
##########################################################
# Budgie Installation
##########################################################
# Install xorg
pacman --noconfirm -S xorg-server xorg-xinit
# Install Budgie
pacman --noconfirm -S budgie-desktop-git
# Set it as the defualt display manager
printf "export XDG_CURRENT_DESKTOP=Budgie:GNOME\nexec budgie-desktop" >> /home/$USER/.xinitrc
