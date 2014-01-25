# Edit this configuration file to define what should be installed on
# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

{
  nixpkgs.config = {
    packageOverrides = pkgs: {
        #nixos.pkgs.gnome.vte = pkgs.callPackage /home/lojze/nixos/nixpkgs/pkgs/desktops/gnome-2/desktop/vte/default.nix {};
        #pkgs.gnome.vte = pkgs.callPackage /home/lojze/nixos/nixpkgs/pkgs/desktops/gnome-2/desktop/vte/default.nix {};
        #nixos.pkgs.xfce.terminal = pkgs.callPackage /home/lojze/nixdev/nixdev/nixpkgs/pkgs/desktops/xfce/applications/terminal.nix {};
#    inherit (pkgs) buildPerlPackage;

      
myDBDmysql = pkgs.callPackage /home/lojze/.nixpkgs/myDBDmysql.nix {



#    inherit (pkgs) fetchurl buildPerlPackage DBI;
#    inherit (pkgs) mysql;

                                       inherit (pkgs) fetchurl;
                                       inherit (pkgs) buildPerlPackage;
                                       #inherit (pkgs) DBI;
                                       #inherit DBI;

    DBI = pkgs.buildPerlPackage {
      name = "DBI-1.625";
      src = pkgs.fetchurl {
        url = mirror://cpan/authors/id/T/TI/TIMB/DBI-1.625.tar.gz;
        sha256 = "1rl1bnirf1hshc0z04vk41qplx2ixzciabvwy50a1sld7vs46q4w";
      };
      meta = {
        homepage = http://dbi.perl.org/;
        description = "Database independent interface for Perl";
        license = "perl5";
      };
    };


                                       inherit (pkgs) mysql;
                                       };


#my_rsnapshot = pkgs.rsnapshot.override{ configFile="/etc/rsnap.cnf";  };
      }; # overrides


  }; # config 

powerManagement.enable = true;

systemd.services."my-pre-suspend" =
    { description = "Pre-Suspend Actions";
        wantedBy = [ "suspend.target" ];
        before = [ "systemd-suspend.service" ];
        script = ''
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
    { description = "Post-Suspend Actions";
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


#  nixpkgs.config = {
#    packageOverrides = pkgs: with pkgs; {
#        gnome.vte = pkgs.callPackage /home/lojze/nixos/nixpkgs/pkgs/desktops/gnome-2/desktop/vte/default.nix {};
#        #pkgs.gnome.vte = pkgs.callPackage /home/lojze/nixos/nixpkgs/pkgs/desktops/gnome-2/desktop/vte/default.nix {};
#        xfce.terminal = pkgs.callPackage /home/lojze/nixdev/nixdev/nixpkgs/pkgs/desktops/xfce/applications/terminal.nix {};
#      
#      };
#  };


#  require = [ 
# ];
  require =
    [ # Include the results of the hardware scan.
<nixos/modules/programs/virtualbox.nix>
      ./hardware-configuration.nix
    ];

  boot.kernelModules = [ "tun" "fuse" ];

  boot.initrd.kernelModules =
    [ # Specify all kernel modules that are necessary for mounting the root
      #filesystem."/".device = "/dev/disk/by-label/nixos";
      # "xfs" "ata_piix"
    ];
  boot.kernelPackages = pkgs.linuxPackages_3_10 // {
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
  networking.extraHosts = "54.230.44.9 cache.nixos.org\n54.217.220.47 nixos.org";



  #networking.wireless.enable = true;  # Enables Wireless.
  #networking.networkmanager.enable = true;  # Enables Wireless.
  networking.networkmanager.enable = false;  # Enables Wireless.
  networking.connman.enable = true;  # Enables Wireless.

  #networking.interfaces.wlp2s0 = { ipAddress = "192.168.2.33"; prefixLength = 24; };
  #networking.interfaces.enp1s0 = { ipAddress = "192.168.1.247"; prefixLength = 24; };
  #networking.defaultGateway = "192.168.1.1";
  #networking.nameservers = [ "8.8.8.8" ];
  #networking.enableIPv6 = false;


  
  #networking.wicd.enable = true;


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
  # fileSystems."/data" =     # where you want to mount the device
  #   { device = "/dev/sdb";  # the device
  #     fsType = "ext3";      # the type of the partition
  #     options = "data=journal";
  #   };

  # List swap partitions activated at boot time.
  swapDevices =
    [  { device = "/dev/disk/by-label/swap"; }
    ];

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "lat9w-16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };




  # List services that you want to enable:
  services = {
  
    #postgresql.enable = true;
    mysql.enable = true;
    postgresql.package = pkgs.postgresql;
    redis.enable = true;

    logind.extraConfig = "HandleLidSwitch=ignore";
 
  # Enable the OpenSSH daemon
    openssh.enable = true;
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

exclude	/home/lojze/newhacks/torrents/

backup	/home/lojze/.bash_history	localhost/
backup	/home/lojze/.bashrc	localhost/
backup	/home/lojze/.gitconfig	localhost/
backup	/home/lojze/.gnupg	localhost/
backup	/home/lojze/.pki	localhost/
backup	/home/lojze/.nixpkgs	localhost/

backup	/home/lojze/.ssh	localhost/

backup	/etc/	localhost/
backup	/home/lojze/newhacks/	localhost/

cmd_preexec	/home/lojze/newhacks/check_mounted.sh
cmd_postexec	/run/current-system/sw/bin/sync
                      '';
    };
    # Enable the X11 windowing system
    xserver = {
      displayManager.desktopManagerHandlesLidAndPower = false;
      enable = true;
      layout = "si";
      xkbOptions = "eurosign:e";

      # Enable the KDE Desktop Environment.
      displayManager.slim.enable = false;
      displayManager.lightdm.enable = true;
      desktopManager.xfce.enable = true;
      desktopManager.default = "xfce";
  };
  postfix = {
    destination = [ "localhost"  ];
    enable = true;
    extraConfig = ''
                  #relayhost = [smtp.gmail.com]:587
                  #smtp_connection_cache_destinations = smtp.gmail.com
                  relay_destination_concurrency_limit = 1
                  default_destination_concurrency_limit = 5
                  smtp_sasl_auth_enable=yes
                  smtp_sasl_password_maps = hash:/var/postfix/sasl_passwd
                  smtp_use_tls = yes
                  smtp_sasl_security_options = noanonymous
                  smtp_sasl_tls_security_options = noanonymous
                  smtp_tls_note_starttls_offer = yes
                  tls_random_source = dev:/dev/urandom
                  smtp_tls_scert_verifydepth = 5
                  smtp_tls_enforce_peername = no
                  smtpd_tls_req_ccert =no
                  smtpd_tls_ask_ccert = yes
                  soft_bounce = yes
                  inet_interfaces = 127.0.0.1
                  smtpd_tls_key_file = /var/postfix/postfix_cert/ssl-cert.key
                  smtpd_tls_cert_file = /var/postfix/postfix_cert/ssl-cert.crt # pem
                  smtpd_tls_CAfile = /var/postfix/postfix_cert/cacert.pem


    '';
    ##hostname = "eve.chaoflow.net";
    ##origin = "eve.chaoflow.net";
    ##postmasterAlias = "root";
    ##rootAlias = "cfl";
  };
  cron.systemCronJobs = [ 
    "7 */5 * * *  lojze   bash /home/lojze/newhacks/nixos-configuration/bin/new_revision.sh >/dev/null 2>&1"
    "@reboot root encfs --public --extpass=/home/lojze/newhacks/encfsprog.sh /home/lojze/.rsnapshot_root/ /home/lojze/rsnapshot_root"
    #"* * * * *  lojze   bash /home/lojze/newhacks/nixos-configuration/bin/new_revision.sh >>/tmp/cron_out 2>&1"
  ];
  };
  users.extraUsers = {
    lojze = {
        createHome = true;
        extraGroups = [ "wheel" "networkmanager" "vboxusers" "postdrop" ];
        group = "users";
        home = "/home/lojze";
        shell = "/run/current-system/sw/bin/bash";
       };
  };

#  system.activationScripts.somefix = {
#    deps = [ ];
#    text = "ln -fs /tmp/Machine2.pm /nix/store/ixrbh53cvc5q2ys2zr72p19xr1x2v94l-nixos-test-driver/lib/perl5/site_perl/Machine.pm";
#  };
  hardware.pulseaudio.enable = true;
programs.bash.enableCompletion = true;  


environment = {
    #enableBashCompletion = true;
    interactiveShellInit = ''
#        export PATH=$HOME/bin:$HOME/node_modules/bin:$PATH:$HOME/bin/launch
#        export EDITOR="vim"
#        export EMAIL=rok@garbas.si
#        export FULLNAME="Rok Garbas"
#        export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache
#        export NODE_PATH=$HOME/.node_modules


#export NIX_DEV_ROOT=/home/lojze/nixdev/nixdev
#. /home/lojze/nixdev/nixdev/nixrc

    '';
    systemPackages = with pkgs; [
connman
connmanui
mp3gain
fuse
#my_rsnapshot
rsnapshot

pidginotr # temporary solution: ln -s /run/current-system/sw/lib/pidgin ~/.purple/plugins 

autoconf
cmake 
autoreconfHook
iftop
mailutils
msmtp
patchelf
#php53
php
postfix
vnstat

parallel

      gnome_terminator
      gnome.vte
#ralink_fw
gimp
bwm_ng
xclip
pygtk
pyGtkGlade
#python33Packages.pygtk
#python33Packages.pyGtkGlade
python33
pygobject
python27Packages.pip
python27Packages.virtualenv 
gnome.gtk
pycairo
xsel
gnome.vte
unrar
kde4.okular

# xfce win tracking .. user installed 
tcpdump 
wine 
ardour
calibre 
xfce.garcon 
gitAndTools.gitSVN 
gnupg 
gparted 
grub2 
xlibs.libX11 
xfce.libxfce4util 
p7zip 
parted 
perlPackages.AlienWxWidgets 
#teamviewer8 
xfce.xfce4_dev_tools 
xpdf 


###

samba

python27Packages.psycopg2


perlPackages.DBI
#perlPackages.DBDmysql

#here
myDBDmysql

perlPackages.ClassISA

teeworlds


lshw

#music
ffmpeg
kde4.amarok

dbus_python
python27Packages.mutagen
gst_python

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

python27Packages.reportlab
python27Packages.sqlite3
      mysql55

      acpitool
      acpi
      linuxPackages_3_10.virtualbox
      linuxPackages_3_10.virtualboxGuestAdditions
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
#busybox
evince
#gnome.nautilus


      xlibs.libxcb
      pidgin
      pidginotr
      libpng
      gstreamer

      xorg_sys_opengl
      gcc
      intltool
      gettext
      perlPackages.XMLParser
      glib
      pkgconfig
     encfs
     bind # nslookup, dig 
xfce.terminal
     eclipses.eclipse_sdk_422
tree
subversion

kde4.ktorrent
libreoffice
#      stdenv
#      fetchurl 
      pkgconfig 
      gtk 
      gtkspell 
      aspell
      gstreamer 
      gst_plugins_base 
##startupnotification
      gettext
      perl 
      perlXMLParser 
      libxml2 
      nss 
      nspr 
      farsight2
unetbootin
libnotify
dunst
SDL
trigger
glxinfo
smartmontools

#  libXScrnSaver
      ncurses 
      avahi 
      dbus 
      dbus_glib 
dbus_libs  
      intltool 
      libidn
#      lib 
      python
      gnome.gtk
      gnome.pango
      gnome.cairo
      gdb
      gdk_pixbuf
      atk
      freetype
      x11
      xlibs.libX11
      xlibs.xproto
      xlibs.kbproto
#rt2870fw
 #rtl8192cfw
      sshfsFuse
viewnior

      openssl
      gmime
      pyopenssl

      gnumake

      xlibs.xhost

      superTux
      superTuxKart
      munin
      iotop
    gnupg 
     tunctl
     screen
     openconnect
     dhcp
     zip
     unzip
kde4.kopete
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
      #firefoxWrapper # browser TODO couldn't be built
firefox13Wrapper 
 
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

    ];
  };
#nixpkgs.config.firefox = {
#          #jrePlugin = true;
#          #jre = true;
#          jrsfeePlugin = true;
#          enableGoogleTalkPlugin = true;
#
#      };

}
