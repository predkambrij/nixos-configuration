# Edit this configuration file to define what should be installed on
# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

{
    nixpkgs.config = {
        allowUnfree = true;
        packageOverrides = pkgs: {
            firefox = pkgs.firefox.override{jre = true;};
            #chromium = pkgs.chromium.override{enablePepperFlash = true; enablePepperPDF = true;};
            chromium = pkgs.chromium.override{enablePepperFlash = true; };
            evince = pkgs.evince.override{ gtk3=pkgs.gtk384;  };
#            linux_3_4 = pkgs.linux_3_4.override {
#                extraConfig =''
#                   PM_TRACE y 
#                   PM_TRACE_RTC y 
#                  '';
#              };
#             linuxPackages = pkgs.linuxPackages_3_4;
}; # overrides
}; # config 

powerManagement.enable = true;

systemd.services."my-pre-suspend" =
{   description = "Pre-Suspend Actions";
wantedBy = [ "suspend.target" ];
before = [ "systemd-suspend.service" ];
script = ''
	# sync filesystems if suspend fails
	/run/current-system/sw/bin/sync 
	# usefull for debug that this part of code really runs
	/run/current-system/sw/bin/date > /tmp/MY-PRE-RESUME
	# add info to my personal time tracker
	/run/current-system/sw/bin/echo  "$(/run/current-system/sw/bin/date +%Y-%m-%d-%H-%M-%S) PRESUSPEND" >> /home/lojze/newhacks/time_tracking.log 
	# lock screen
	/home/lojze/newhacks/root_exec.sh /run/current-system/sw/bin/xscreensaver-command -lock 2>/tmp/lock_err
    '';

serviceConfig.Type = "simple";
};

systemd.services."my-post-suspend" =
{   description = "Post-Suspend Actions";
wantedBy = [ "suspend.target" ];
after = [ "systemd-suspend.service" ];
script = ''
	# usefull for debug that this part of code really runs
	/run/current-system/sw/bin/date > /tmp/MY-POST-RESUME
	# add info to my personal time tracker
	/run/current-system/sw/bin/echo  "$(/run/current-system/sw/bin/date +%Y-%m-%d-%H-%M-%S) POSTSUSPEND" >> /home/lojze/newhacks/time_tracking.log 
    '';

serviceConfig.Type = "simple";
};

require =
[ # Include the results of the hardware scan.
<nixos/modules/programs/virtualbox.nix>
./hardware-configuration.nix
];
boot.blacklistedKernelModules = [ "mei_me" "e1000e" ]; # 100% cpu load when craches, maybee issue for freezed suspend
boot.kernelModules = [ "tun" "fuse" ];
#boot.crashDump.enable = true;
boot.initrd.kernelModules =
[ # Specify all kernel modules that are necessary for mounting the root
#filesystem."/".device = "/dev/disk/by-label/nixos";
# "xfs" "ata_piix"
];
boot.kernelPackages = pkgs.linuxPackages // {
virtualbox = pkgs.linuxPackages.virtualbox.override {
#      enableExtensionPack = true; #should be 3_2 but with 3_4 also works even that is commented out
};
}; 

# Use the GRUB 2 boot loader.
boot.loader.grub.enable = true;
boot.loader.grub.version = 2;

# Define on which hard drive you want to install Grub.
boot.loader.grub.device = "/dev/sdb";

networking.hostName = "nixos-think"; # Define your hostname.
networking.extraHosts = "54.230.44.9 cache.nixos.org\n54.217.220.47 nixos.org"; # it most likely timed out because of dns
networking.enableIPv6 = false; # postfix may doesn't work with ipv6


networking.networkmanager.enable = true; 

# Add filesystem entries for each partition that you want to see
# mounted at boot time.  This should include at least the root
# filesystem.

fileSystems."/" = {
device = "/dev/disk/by-label/nixos";
fsType = "ext4";      # the type of the partition
 options = "defaults,discard,noatime,nodiratime,errors=remount-ro";
};
fileSystems."/tmp" = {
device = "tmpfs";
fsType = "tmpfs";
options = "nosuid,nodev,relatime,size=10G";
};

# List swap partitions activated at boot time.
swapDevices =
[  { device = "/dev/disk/by-label/swap"; } ];

# List services that you want to enable:
services = {
graphite.web.enable = true; 
ntp.enable = false; 
#postgresql.enable = true;
mysql.enable = true;
mysql.extraOptions = ''bind-address=127.0.0.1'';
mysql.package = pkgs.mysql;
postgresql.package = pkgs.postgresql;
#redis.enable = true;

logind.extraConfig = ''HandleLidSwitch=ignore
HandleSuspendKey=suspend
		   '';

# Enable the OpenSSH daemon
openssh.enable = false;
openssh.permitRootLogin = "yes";

# Enable CUPS to print documents.
# printing.enable = true;

#sudo.enable = true;

rsnapshot = {
enable = true;
cronIntervals = { 
    "daily" = "0 18 * * *"; # every day at 18 o'clock 
    "weekly" = "0 19 * * 1"; # every monday at 19 o'clock 
};

# tab separated
extraConfig = ''
snapshot_root	/home/lojze/rsnapshot_root/

retain	daily	7
retain	weekly	4

verbose	5
loglevel	5
logfile	/var/log/rsnapshot_lojze_home.log

exclude	/home/lojze/newhacks/chroot_vmware_view_client_i386/proc/
exclude	/home/lojze/newhacks/chroot_vmware_view_client_i386/sys/
exclude	/home/lojze/newhacks/chroot_vmware_view_client_i386/dev/
exclude	/home/lojze/newhacks/chroot_vmware_view_client_i386/tmp/
exclude	/home/lojze/newhacks/chroot_vmware_view_client_i386/home/lojze/.pulse

exclude	/home/lojze/newhacks/chroot_zotero_i386/
exclude	/home/lojze/newhacks/zotero/

# $XDG_RUNTIME_DIR
exclude	/home/lojze/newhacks/chroot_vmware_view_client_i386/run/user/499

# pulseaudio
exclude	/home/lojze/newhacks/chroot_vmware_view_client_i386/run/udev
exclude	/home/lojze/newhacks/chroot_vmware_view_client_i386/run/dbus

exclude	/home/lojze/newhacks/torrents/
exclude	/home/lojze/newhacks/muska/
exclude	/home/lojze/newhacks/fotke/
exclude	/home/lojze/newhacks/not_in_bu/

exclude	/home/lojze/rsnapshot_hetzner 
exclude	/home/lojze/rsnapshot_root 
exclude	/home/lojze/rsnapshot_root_fotke 
exclude	/home/lojze/rsnapshot_root_muska 
exclude	/home/lojze/.rsnapshot_root 
exclude	/home/lojze/.rsnapshot_hetzner 

exclude	/home/lojze/.cache 
exclude	/home/lojze/Downloads 
exclude	/home/lojze/VirtualBox\ VMs

exclude	/home/lojze/mp

backup	/home/lojze	localhost/
backup	/etc/	localhost/
backup	/home/lojze/newhacks/zotero/home/lojze/	localhost/

cmd_preexec	/home/lojze/newhacks/check_mounted.sh
cmd_postexec	/run/current-system/sw/bin/bash -c "rsync -ahH --numeric-ids --delete --exclude=/home/lojze/newhacks/muska/sshfs /home/lojze/newhacks/muska/ /home/lojze/rsnapshot_root_muska/ && touch /home/lojze/rsnapshot_root_muska/; rsync -ahH --numeric-ids --delete /home/lojze/newhacks/fotke/ /home/lojze/rsnapshot_root_fotke/ && touch /home/lojze/rsnapshot_root_fotke/; sync" 
	      '';
};
# Enable the X11 windowing system
xserver = {
displayManager.desktopManagerHandlesLidAndPower = false;
enable = true;
layout = "si";
xkbOptions = "eurosign:e";

desktopManager.xfce.enable = true;
desktopManager.default = "xfce";
};
cron.systemCronJobs = [ 
"7 */5 * * *  lojze   bash /home/lojze/newhacks/nixos-configuration/bin/new_revision.sh >/dev/null 2>&1"
"7 */5 * * *  lojze   bash /home/lojze/newhacks/nixos-configuration/bin/new_stable_revision.sh >/dev/null 2>&1"
"@reboot root encfs --public --extpass=/home/lojze/newhacks/encfsprog.sh /home/lojze/.rsnapshot_root/ /home/lojze/rsnapshot_root"
"@reboot root bash -c \"echo 1 > /sys/power/pm_trace\""
];
};
users.extraUsers = {
lojze = {
createHome = true;
uid = 499;
extraGroups = [ "wheel" "networkmanager" "vboxusers" "postdrop" ];
group = "users";
home = "/home/lojze";
shell = "/run/current-system/sw/bin/bash";
};
};

hardware.pulseaudio.enable = true;
#hardware.pulseaudio.configFile = "/etc/default_custom.pa";
programs.bash.enableCompletion = true;  

services.postfix = {
    destination = [ "localhost" ];
    enable = true;
    extraConfig = '' 
        relayhost = [blatnik.org]:8123
    '';
};

environment = {
systemPackages = with pkgs; [ # start_of_packages

# == add here new packages ===
gnome3.eog
graphite2
mp3gain
torbrowser
beep
sox
patchelf
oraclejdk
processing
#blueman
#bluez
dbus
ntp
alsaUtils
xawtv
debootstrap
# processing plugins
xlibs.libXxf86vm
xlibs.libX11
xlibs.libXrender
binutils
avrdude
bzip2
mpg321
mpg123
wireshark
sysstat
gitAndTools.tig
gitg
telnet
jrePlugin
xsane
saneBackends
saneFrontends
inetutils
#############################
skype
#test
autossh
#connman
#connmanui
#mp3gain
stress
x11vnc
psmisc
opencv
powertop
openjdk
mp4v2


flashplayer
flac

exif
#e17.terminology
tmux
mercurial
xlibs.xev

saneFrontends
xsane
saneBackends
saneBackendsGit

chromedriver
# TODO wireshark
#texLiveFull # huge package 

fuse
rsnapshot

pidginotr # temporary solution: ln -s /run/current-system/sw/lib/pidgin ~/.purple/plugins 

iftop
msmtp
postfix
vnstat
#beep
kismet
parallel
#streamripper

#gnome_terminator
gnome.vte

gimp
bwm_ng
xclip
php
python33
python27Packages.pip
python27Packages.virtualenv 
python27Packages.django
python27Packages.MySQL_python

openvpn
gnome.gtk
pycairo
xsel
gnome.vte
unrar
kde4.okular

tcpdump 
calibre 
gitAndTools.gitSVN 
gnupg 
gparted 
grub2 
p7zip 
parted 
id3v2
samba

lshw

#music
ffmpeg
kde4.amarok

dbus_python
nmap

cups
wine

trickle
tightvnc 
syslinux 
pmutils 
lm_sensors 
kde4.k3b 
iptables 
hddtemp 
gtkvnc 
directvnc 
cdrkit

python27Packages.sqlite3

      acpitool
      acpi
      #linuxPackages_3_10.virtualbox
      #linuxPackages_3_10.virtualboxGuestAdditions
      #linuxPackages_latest.virtualbox
      #linuxPackages_latest.virtualboxGuestAdditions
      linuxPackages.virtualbox
      linuxPackages.virtualboxGuestAdditions
      #virtualbox
      #virtualboxGuestAdditions
      qemu
      kvm
      colordiff
      xscreensaver
      pulseaudio
      pavucontrol
      xfce.xfce4panel
      xfce.terminal
      vlc
imagemagick
      rdesktop
evince

      pidgin
      pidginotr

     encfs
     bind # nslookup, dig 
     xfce.terminal
     eclipses.eclipse_sdk_431
     tree
     subversion
     mplayer2
     smplayer

     kde4.ktorrent
     libreoffice
      gettext
unetbootin
libnotify
smartmontools

      python
      sshfsFuse
viewnior

      openssl
      xlibs.xhost

      superTux
      superTuxKart
      iotop
    gnupg 
     tunctl
     screen
     openconnect
     dhcp
     zip
     unzip
kde4.kate
transmission
       # gitlab
       mysql
       # gitlab end

#      alsaLib
#      alsaPlugins
#      alsaUtils
#      bc
#      colordiff
#      cpufrequtils
#      cryptsetup
#      ddrescue
      file
#      gnupg
#      gnupg1
#      keychain
#      links2
#      mailutils
#      ncftp
#      netcat
#      nmap
#      p7zip
#      parted
#      pinentry
      #GConf
      gnome.GConf
      htop
#      powertop
#      pwgen
#      screen
#      sdparm
#      stdmanpages
#      subversion
#      tcpdump
#      telnet
#      units
#      unrar
#      unzip
      wget
#      w3m
#      zsh
#      bash
#      weechat
#      nodejs
       virtmanager
#      stdenv
#      pythonPackages.virtualenv
#      pythonPackages.ipython
#
      gitFull
#      gitAndTools.tig
#      gitAndTools.gitAnnex
      lsof
#      mercurialFull
#      bazaar
#      bazaarTools
#
      mosh
#      #kde48.calligra
#
#      msmtp
#      notmuch
#      offlineimap
#      pythonPackages.alot
#      pythonPackages.afew
#
#      # x11Packages
#
##      qemu_kvm
#      xfontsel
#      xlibs.xev
#      xlibs.xinput
#      xlibs.xmessage
#      xlibs.xmodmap
#
#      # basic utils
#      i3lock
#      i3status
#      dmenu
#      scrot # screenshots
#      #geeqie # image viewer
##      vifm # file browser
##      rxvt_unicode # best terminal (need to enable perl)
##      xsel # Copy/Paste tool (used by urxvt)
##      pythonPackages.turses # twitter client
#
#      # development tools
##      lcov
#
#      # wireless gui
#      #wpa_supplicant_gui
      networkmanagerapplet
      gnome.gnome_keyring
#
#      # editor and utils
      vimHugeX # best editor
##      ctags # used in vim
#
#      # needed for vim's syntastic
##      phantomjs
##      pythonPackages.flake8
##      pythonPackages.docutils
##      htmlTidy
##      csslint
#      #xmllint
#      #zptlint
#
#      # browsers
      chromiumWrapper # browser
      firefoxWrapper # browser TODO couldn't be built
# TODO firefox13Wrapper 
#torbrowser
#tor
 
##      opera # browser
#
#      # apps
##      zathura # pdf viewer (instead of xpdf)
##      skype
##      vlc
##      mplayer2
##      dropbox
##      gftp
##      calibre
##      vidalia
##      gnucash
#
#      # graphic / design stuff
#      #blender
##      gimp_2_8
##      inkscape
##      audacity
#
#      # office stuff
##      libreoffice
#
#      # database utils
#      #mysqlWorkbench
#
#      # torrent
##      transmission_remote_gtk
#
#      # hacking
##      wireshark
##      aircrackng
#
#      # audio
##      ncmpcpp
##      pavucontrol
#
#      # games
##      spring
##      springLobby
##      teeworlds
##      xonotic

    ]; # end_of_packages
  };
}
