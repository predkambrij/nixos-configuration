{ fetchurl, stdenv, SDL, SDL_image, SDL_mixer, curl, gettext, libogg, libvorbis, mesa, openal, cmake, boost, boostHeaders, physfs, glew }:

let

    version = "0.3.4";

in

stdenv.mkDerivation {
  name = "supertux-${version}";

  src = fetchurl {
    #url = "http://download.berlios.de/supertux/supertux-${version}.tar.bz2";
    url = "http://supertux.googlecode.com/files/supertux-0.3.4.tar.bz2";
    sha256 = "741d7aa83ec84e3f19e90459236457baa2b8b87f1c494251d315a44b3599e7b6";
  };

  buildInputs = [ SDL SDL_image SDL_mixer curl gettext libogg libvorbis mesa openal cmake  boost boostHeaders physfs glew ];

  inherit boostHeaders;

#  patches = [ ./g++4.patch ];

  builder = ./builder_supertux2.sh;

  meta = {
    description = "Classic 2D jump'n run sidescroller game";

    homepage = http://supertux.lethargik.org/index.html;

    license = "GPLv2";
  };
}

#SDL SDL_image SDL_mixer curl gettext libogg libvorbis mesa openal
#cmake
#
#SDL
#SDL2
#SDL2_gfx
#SDL2_image
#SDL2_mixer
#sdlmame
#SDL_gfx
#SDL_image
#SDL_mixer
#SDL_net
#SDL_sound
#SDL_ttf
#
#boost
#boostHeaders


