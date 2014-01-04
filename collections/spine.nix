{stdenv, doxygen, fetchurl, cmake, perl, unzip, libtool, file}:

stdenv.mkDerivation rec {
  name = "spine-0.8.8b";

  src = fetchurl {
    url = "http://www.cacti.net/downloads/spine/cacti-spine-0.8.8b.tar.gz";
    sha256 = "fc5d512c1de46db2b48422856e8c6a5816d110083d0bbbf7f9d660f0829912a6";
    #url = mirror://gnu/hello/hello-2.1.1.tar.gz;
    #md5 = "70c9ccf9fac07f762c24f2df2290784d";
  };
  connector_64_bit = fetchurl {
    url = "http://dev.mysql.com/get/Downloads/Connector-C/mysql-connector-c-6.1.3-linux-glibc2.5-x86_64.tar.gz";
    sha256 = "da2a1ce49d5425699a6027b6b7c1b5975252313316f96a84c7819c84dafea853";
    md5 = "3161d47305234772db6d7ae30288a9ef";
  };
  snmp = fetchurl {
    url = "http://sourceforge.net/projects/net-snmp/files/net-snmp/5.7.2/net-snmp-5.7.2.zip";
    sha256 = "01243b9bbafb0dbb9596749902cd0d6f5541bff2a3979e3050711da289a55b79";
  };

  buildInputs = [ cmake doxygen unzip libtool file];
  builder = ./builder.sh;
  inherit perl;
  inherit unzip;
  inherit libtool;
  inherit file;

  meta = {
    description = "spine";
    homepage = "http://cacti.net/";
    license = "GPL2";
    maintainers = with stdenv.lib.maintainers; [predkambrij];
  };
}

