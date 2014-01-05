source $stdenv/setup

set -e

tar xvfz $src
cd mysql-connector-c*

mkdir -p $out/

cp -r ./* $out/

