#!/bin/bash
##########################################################
#
#   Arch Installation Script
#     For Wm
#
#
##########################################################
# Helper functions
##########################################################
function pause {
               read -rsp $'Press enter to continue...\n'
           }

##########################################################
# Configurations 
##########################################################

HOSTNAME="$USER-pc"

SWAP_DIM="4G"

#SSID="Wifierino"
#WIFI_PASS="WifiPasswarderino"

##########################################################
# Wifi Setup
##########################################################

# Get the interface name
#INTERFACE=`iwconfig 2> /dev/null | grep -sho "wlp[^ ]*"`
# Turn up the interface
#ip link set $INTERFACE up
# Connect to the wifi
#wpa_supplicant -B -i interfaccia -c <(wpa_passphrase $SSID $WIFI_PASS)
# Get an Ip from the DHCP
#dhcpcd $INTERFACE

##########################################################
# General System Setup
##########################################################
# Set the us keyboard layout, it for italian
loadkeys us
# Update the system clock
timedatectl set-ntp true
##########################################################
# Disk Setup (FOR VM)
##########################################################
#   Device  Size    Type
# /dev/sda1 200M    Ext4
# /dev/sda3  ~      Ext4
##########################################################
# Get the path to the first disk
DISK=`fdisk -l | grep -ho /dev/sd[a-z] | head -n 1`

# Remove all the partitions
(   
    # Delete partitions, 4 since its the non extended max
    printf "d\n"; # Delete the previous partitions
    printf "\n";  # Delete the previous partitions
    printf "d\n"; # Delete the previous partitions
    printf "\n";  # Delete the previous partitions
    printf "d\n"; # Delete the previous partitions
    printf "\n";  # Delete the previous partitions
    printf "d\n"; # Delete the previous partitions
    printf "\n";  # Delete the previous partitions
    # Save and exit
    printf "w\n"; # The rest of the disk
    printf "Y\n" # 
) | fdisk $DISK

fdisk -l

pause
# Create the new partitions
(   
    # Delete partitions, 4 since its the non extended max
    # Create the /mnt/boot partition
    printf "n\n"; # new partition
    printf "p\n"; # Primary partition
    printf "1\n"; # Partition number
    printf "\n"; # Start of the partition default
    printf "+200M\n"; # 
    printf "Y\n"; # 
    # Create the Main partition
    printf "n\n"; # new partition
    printf "p\n"; # Primary partition
    printf "2\n"; # Partition number
    printf "\n"; # Start of the partition default
    printf "\n"; # The rest of the disk
    printf "Y\n"; # 
    # Save and exit
    printf "w\n"; # The rest of the disk
    printf "Y\n" # 
) | fdisk $DISK

fdisk -l

pause

# Create the variables for the paths
BOOT_PARTITION="$DISK"
BOOT_PARTITION+="1"
printf "Y\n" | mkfs.ext4 $BOOT_PARTITION
# Mount the Boot partition
mount $BOOT_PARTITION /boot
# Convert the main partition to ext4
MAIN_PARTITION="$DISK"
MAIN_PARTITION+="2"
printf "Y\n" | mkfs.ext4 $MAIN_PARTITION
# Mount the Main partition
mount $MAIN_PARTITION /mnt

pause
##########################################################
# Swap File
##########################################################
# Allocate the space for the file
fallocate -l $SWAP_DIM /mnt/swapfile
# Set the minimum needed permission
chmod 600 /mnt/swapfile
# Format it to swap
mkswap /mnt/swapfile
# Activate the swap
swapon /mnt/swapfile
# Set the configuration if partition
# echo "/mnt/swapfile non swap defaults 0 0" >> /etc/fstab

pause
##########################################################
# System Installation
##########################################################
# Install the base system and the base development tools
pacstrap /mnt base base-devel tmux vim nano networkmanager

pause
# Generate the Fstab file
genfstab -U /mnt >> /mnt/etc/fstab

# Download the script to be executed during the chroot
wget https://raw.githubusercontent.com/zommiommy/System-Configuration-Script/master/chroot-install.sh -o /mnt/tmp/chroot-install.sh

# Change the root to the disk
arch-chroot /mnt bash /tmp/chroot-install.sh

rm /mnt/tmp/chroot-install.sh

pause