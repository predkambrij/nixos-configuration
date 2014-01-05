source $stdenv/setup

tar xvfz $src

cd cacti-spine-0.8.8b 

export LDFLAGS="-L$openssl/lib"

./configure --prefix=$out   --with-mysql=$mysql_c --with-snmp=$net_snmp

make
make install

