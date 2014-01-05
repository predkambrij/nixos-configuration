source $stdenv/setup

mkdir -p $out 

tar xvfj $src

echo $boostHeaders 
ls -lh  $boostHeaders 

cd supertux*
mkdir build
cd build 
cmake  -DCMAKE_INSTALL_PREFIX:PATH=$out .. 
make
make install 
mkdir -p $out/bin
ln -s $out/games/supertux2 $out/bin/supertux2 


