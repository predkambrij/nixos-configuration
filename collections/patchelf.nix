{ stdenv, fetchgit, autoconf, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "patchelf-git";

  src = fetchgit {
    url = https://github.com/predkambrij/patchelf.git;
    rev = "02c4ffa5550a3e35f62ae0bfed4c08812e66bf24";
  };
  builder = ./builder_patchelf.sh;
  buildInputs = [ autoconf ];

  inherit autoconf;

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
