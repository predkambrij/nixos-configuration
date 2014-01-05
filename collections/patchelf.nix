{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  name = "patchelf-git";

  src = fetchgit {
    url = https://github.com/predkambrij/patchelf.git;
    #sha256 = "bbc46169f6b6803410e0072cf57e631481e3d5f1dde234f4eacbccb6562c5f4f";
  };

  meta = {
    homepage = http://nixos.org/patchelf.html;
    license = "GPL";
    description = "A small utility to modify the dynamic linker and RPATH of ELF executables";
  };
}
