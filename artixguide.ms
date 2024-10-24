.TL
Installing Artix Linux OpenRC
.AU
Bak Svyatoslav
.NH
Partitioning
.PP
UEFI GPT
.TS
allbox tab(|);
c c c c c
c c c c c
c c c c c.
Number|Type|Size|Filesystem|Mount point
1|EFI System (1)|512 Mib|FAT32|/mnt/boot
2|Linux swap (19)|2 Gib - 8 Gib|Swap|[SWAP]
3|Linux root (x86-64)|at least 32 Gib|ext4|/mnt
.TE
.P
Partition your hard drive with fdisk according to this table.

.B "Then format format the partitions with these commands:"
.nf
mkfs.fat -F32 /dev/efi_partition
.nf
mkswap /dev/swap_partition
.nf
mkfs.ext4 /dev/root_partition

.B "And mount them:"
.nf
mount /dev/root_partition /mnt
.nf
mount --mkdir /dev/efi_partition /mnt/boot
.nf
swapon /dev/swap_partition

.PP
BIOS GPT
.TS
allbox tab(|);
c c c c c
c c c c c
c c c c c.
Number|Type|Size|Filesystem|Mount point
1|BIOS boot(4)|16 Mib|None|None
2|Linux swap (19)|2 Gib - 8 Gib|Swap|[SWAP]
3|Linux root (x86-64)|at least 32 Gib|ext4|/mnt
.TE
.P
Partition your hard drive with fdisk according to this table. Now execute the same commands as for UEFI GPT except those that had "/dev/efi_partition" in them.
.P

BIOS MBR 
.TS
allbox tab(|);
c c c c c
c c c c c
c c c c c.
Number|Type|Size|Filesystem|Mount point
1|Linux swap / Solaris (82)|2 Gib - 8 Gib|Swap|[SWAP]
2|Linux (83)|at least 32 Gib|ext4|/mnt
.TE
.P
Partition your hard drive with fdisk according to this table. Now execute the same commands as for UEFI GPT except those that had "/dev/efi_partition" in them.
.NH
Installing base system
.PP
basestrap -K /mnt base base-devel linux linux-firmware openrc elogind-openrc
.nf
.B "Generataing fstab:"
fstabgen -U /mnt > /mnt/etc/fstab
.nf
.B "Chrooting into the system"
.nf
artix-chroot /mnt


.B "Setting up system time:"
.nf
ln -sf /usr/share/zoneinfo/Xxxx/xxxx > /etc/localtime
.nf
hwclock --systohc
.nf
.B "Generating locales:"
.nf
pacman -S neovim
.nf
nvim /etc/locale.gen
.nf
Uncomment en_US.UTF.8 locale and others you might need.
.nf
locale-gen
.nf
.B "Setting up internet connection:"
.nf
pacman -S dhcpcd-openrc
.nf
rc-update add dhcpcd boot
.nf
.B "Setting up users and sudo:"
.nf
passwd
.nf
useradd -m user
.nf
passwd user
.nf
usermod -aG wheel,video,audio,storage user
.nf
pacman -S sudo
.nf
EDITOR=nvim visudo
.nf
Then uncomment line 121. Lines aren't numbered by default in neovim, so you need to enter command :set number to show them.
.nf
.NH
Installing an desktop enviroment
.PP
We're gonna be installing Xfce in this tutorial, you can check Arch wiki for other DEs, it should work with Artix Linux.

.B "Installing DE:"
.nf
pacman -S xorg xfce4 xfce4-goodies
.nf
rc-update add elogind boot
.nf
.B "And optionally you can also install a display manager:"
.nf
pacman -S lightdm-openrc lightdm-gtk-greeter
rc-update add lightdm boot
.NH
Installing a bootloader
.nf
.PP
pacman -S grub efibootmgr
.nf
.B "BIOS MBR/GPT"
.nf
grub-install /dev/your_hard_drive
.nf
.B "UEFI GPT"
.nf
grub-install --efi-directory=/boot
.nf
.B "Generating a config file"
.nf
grub-mkconfig -o /boot/grub/grub.cfg
.nf
.NH
Rebooting to the system
.PP
.nf
exit
.nf
reboot
.nf
That's it! You've installed Artix Linux.
