# Edit this configuration file to define what should be installed on
# the system.  Help is available in the configuration.nix(5) man page
# or the NixOS manual available on virtual console 8 (Alt+F8).

{ config, pkgs, ... }:

{
  require =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.initrd.kernelModules =
    [ # Specify all kernel modules that are necessary for mounting the root
      #filesystem."/".device = "/dev/disk/by-label/nixos";
      # "xfs" "ata_piix"
    ];
    
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "nixos-eee"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables Wireless.
  networking.networkmanager.enable = true;  # Enables Wireless.

  #networking.interfaces.wlp2s0 = { ipAddress = "192.168.2.33"; prefixLength = 24; };
  #networking.interfaces.enp1s0 = { ipAddress = "192.168.1.247"; prefixLength = 24; };
  #networking.defaultGateway = "192.168.1.1";
  #networking.nameservers = [ "8.8.8.8" ];
  #networking.enableIPv6 = false;

  
  #networking.wicd.enable = true;


  # Add filesystem entries for each partition that you want to see
  # mounted at boot time.  This should include at least the root
  # filesystem.

  fileSystems."/".device = "/dev/disk/by-label/nixos";

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
    
  # Enable the OpenSSH daemon
    openssh.enable = true;
    openssh.permitRootLogin = "yes";

  # Enable CUPS to print documents.
  # printing.enable = true;

    #sudo.enable = true;

    # Enable the X11 windowing system
    xserver = {
      enable = true;
      layout = "si";
      xkbOptions = "eurosign:e";

      # Enable the KDE Desktop Environment.
      displayManager.slim.enable = false;
      displayManager.lightdm.enable = true;
      desktopManager.xfce.enable = true;
      desktopManager.default = "xfce";
    };
  };
  users.extraUsers = {
    lojze = {
        createHome = true;
        extraGroups = [ "wheel" "networkmanager" ];
        group = "users";
        home = "/home/lojze";
        shell = "/run/current-system/sw/bin/bash";
       };
  };


environment = {
    enableBashCompletion = true;
    interactiveShellInit = ''
#        export PATH=$HOME/bin:$HOME/node_modules/bin:$PATH:$HOME/bin/launch
#        export EDITOR="vim"
#        export EMAIL=rok@garbas.si
#        export FULLNAME="Rok Garbas"
#        export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache
#        export NODE_PATH=$HOME/.node_modules
    '';
    systemPackages = with pkgs; [
#      acpitool
#      alsaLib
#      alsaPlugins
#      alsaUtils
#      bc
#      colordiff
#      cpufrequtils
#      cryptsetup
#      ddrescue
#      file
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
#      htop
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
#      wget
#      w3m
#      zsh
#      bash
#      weechat
#      nodejs
#
#      stdenv
#      pythonPackages.virtualenv
#      pythonPackages.ipython
#
      gitFull
#      gitAndTools.tig
#      gitAndTools.gitAnnex
#      lsof
#      mercurialFull
#      bazaar
#      bazaarTools
#
#      mosh
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
#      vimHugeX # best editor
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
##      chromiumWrapper # browser
##      firefoxWrapper # best browser
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

}
