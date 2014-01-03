# This is mostly a work in progress and might not work with what is in
# nixpkgs trunk. If you have questions, feel free to contact me:
# Florian Friesdorf <flo@chaoflow.net> Alojzij Blatnik <lojze.blatnik@gmail.com>

{
#  st.conf = builtins.readFile ./.st.conf;
  packageOverrides = pkgs: with pkgs; 
  rec {
#    envStandard = pkgs.buildEnv {
#      name = "standard";
#      paths = with pkgs; [
#        # terminal
#        st
#        zsh
#        tmux
#        pythonPackages.powerline
#
#        # best editor ever
#        vimLatest
#        vimPlugins.YouCompleteMe
#
#        # sync
#        dropbox
#        dropbox-cli
#
#        # chat
#        weechat
#        bitlbee
#
#        pythonPackages.supervisor
#
#        # basic needed packges
#        curl
#        cacert
#        stdenv
#      ];
#      ignoreCollisions = true;
#    };
#
#   envAdmin = pkgs.buildEnv {
#      name = "admin";
#      paths = with pkgs; [
#        inetutils
#        nmap
#        openssl
#        openvpn
#
#        # For network boot
#        dhcp
#        tftp_hpa
#        unfs3
#
#        # For amazon configuration
#        ec2_api_tools
#      ];
#      ignoreCollisions = true;
#    };
   envGitlab = pkgs.buildEnv {
      name = "gitlab";
      paths = with pkgs; [
        ruby18
        stdenv
        git  
        rubyLibs.bundler 
        #python27
        #openssh  
          
          
      ];
      ignoreCollisions = true;
    };
   envProg2Env = pkgs.buildEnv {
      name = "prog2env";
      paths = with pkgs; [
        stdenv
        git  
        python27
        mongodb 
        eclipses.eclipse_sdk_422
        screen
        subversion
        subversionClient
        busybox
        vim
        nano
        systemd
        man
        python27Packages.pip
        python27Packages.virtualenv

        mysql
        libzip
        python27Packages.MySQL_python

      ];
      ignoreCollisions = true;
    };

   libnoise = callPackage ./libnoise.nix {};
   cacti = callPackage ./cacti.nix {};
   envCactiEnv = pkgs.buildEnv {
      name = "cactienv";
      paths = with pkgs; [
        stdenv
        nano
        vim
        wget
        libnoise
        cacti
      ];
      ignoreCollisions = true;
    };
   envDesktopEnv = pkgs.buildEnv {
        #myfirefoxWrapper = pkgs.wrapFirefox { browser = pkgs.firefoxPkgs.firefox; };
      name = "desktopenv";
      paths = with pkgs; [
        stdenv
#        (firefoxWrapper.override {
#        #  jre = true;
#            
#	}) 
        jrePlugin

        #firefoxWrapper
      ];
      ignoreCollisions = true;
#pkgs.firefox.jre = true;

    };

#    envX = pkgs.buildEnv {
#      name = "envX";
#      paths = with pkgs; [
#        # applications
#        firefoxWrapper
#        xpra # Much better as vnc
#        eclipses.eclipse_cpp_42
#        skype
#
#        # dependecies
#        hicolor_icon_theme
#        xkeyboard_config
#        xorg.xkbcomp
#        xorg.xorgserver
#        xorg.xf86videodummy
#        xorg.xf86inputvoid
#        xorg.xrdb
#        xfontsel
#        fontconfig
#        freetype
#        xclip
#        xsel
#
#        # fonts
#        xorg.fontbhttf
#        xorg.fontbhlucidatypewriter100dpi
#        xorg.fontbhlucidatypewriter75dpi
#        xorg.fontbh100dpi
#        xorg.fontmiscmisc
#        xorg.fontcursormisc
#
#        ttf_bitstream_vera
#        freefont_ttf
#        liberation_ttf
#        inconsolata
#      ];
#      ignoreCollisions = true;
#    };
#
#    envDev = pkgs.buildEnv {
#      name = "dev";
#      paths = with pkgs; [
#        # editor and utils
#        ctags
#        pkgconfig
#
#        # version control
#        gitAndTools.gitFull
#        mercurial
#        subversionClient
#
#        # needed for vim's syntastic
#        phantomjs
#        pythonPackages.flake8
#        pythonPackages.docutils
#        htmlTidy
#        csslint
#
#        # Compilers and interpreters
#        python27Full
#        mono
#        jdk
#        nodejs
#
#        # Databases
#        mongodb
#      ];
#      ignoreCollisions = true;
#    };
#
#    envNodejs = pkgs.buildEnv {
#      name = "nodejs";
#      paths = with pkgs; [
#        nodejs
#        stdenv
#      ];
#      ignoreCollisions = true;
#    };
#
#    envPy27 = pkgs.buildEnv {
#      name = "py27";
#      paths = with pkgs; [
#        python27Full
#        python27Packages.ipython
#        python27Packages.pudb
#        python27Packages.virtualenv
#        stdenv
#      ];
#      ignoreCollisions = true;
#    };
#
#    envPy27Pyramid = pkgs.buildEnv {
#      name = "py2Pyramid";
#      paths = with pkgs; [
#        envPy27
#
#        autoconf
#        cyrus_sasl
#        db4
#        libxml2
#        libxslt
#        openssl
#        pcre
#        zlib
#        pkgconfig
#        postgresql
#        pycrypto
#        python27Packages.sqlite3
#        python27Packages.readline
#        python27Packages.lxml
#      ];
#      ignoreCollisions = true;
#    };
#
#    envPy27stt = pkgs.buildEnv {
#      name = "py27stt";
#      paths = with pkgs; [
#        envPy27
#
#        swig
#        flac
#        python27Packages.pyaudio
#      ];
#      ignoreCollisions = true;
#    };
#
#
#    KernelEnv = pkgs.buildEnv {
#      name = "kernelenv";
#      paths = [
#        pkgs.defaultStdenv
#        pkgs.gitAndTools.gitFull
#        pkgs.ncurses
#      ];
#      ignoreCollisions = true;
#    };
  };
  pkgs.pulseaudio = {
    jackaudioSupport = true;
  };
#firefox.jre = true;
}
