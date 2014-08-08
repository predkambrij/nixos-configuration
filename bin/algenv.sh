
# installing
# nix-env -p $NIX_USER_PROFILE_DIR/semenv -i semenv

# updating
# nix-env -p $nixprofile -u --always '*'
# or NIX_USER_PROFILE_DIR=/nix/var/nix/profiles/per-user/lojze;env_name=semenv;nixprofile=$NIX_USER_PROFILE_DIR/$env_name;nix-env -p $nixprofile -u --always '*'

# see tutorial here (thanks flo for sharing) https://github.com/chaoflow/nixos-configurations  

env_name=semenv
NIX_USER_PROFILE_DIR=/nix/var/nix/profiles/per-user/lojze

nixprofile=$NIX_USER_PROFILE_DIR/$env_name

export PATH="$HOME/bin:$nixprofile/bin"
export LD_LIBRARY_PATH="$nixprofile/lib"
export NIX_LDFLAGS="-L $nixprofile/lib"
export NIX_CFLAGS_COMPILE="-I $nixprofile/include"
export PKG_CONFIG_PATH="$nixprofile/lib/pkgconfig"
export PYTHONPATH="$nixprofile/lib/python2.7/site-packages"
export PS1=$(echo "$PS1"| sed "s/\\\u@\\\h:\\\w/"\($env_name\)"\\\u@\\\h:\\\w/")

"$@"
