{stdenv, doxygen, fetchurl, cmake, perl, unzip, libtool, file, net_snmp, libcxxStdenv, glibc, mysql_c, cryptopp, libgcrypt}:

stdenv.mkDerivation rec {
  name = "spine-0.8.8b";

  src = fetchurl {
    url = "http://www.cacti.net/downloads/spine/cacti-spine-0.8.8b.tar.gz";
    sha256 = "fc5d512c1de46db2b48422856e8c6a5816d110083d0bbbf7f9d660f0829912a6";
    #url = mirror://gnu/hello/hello-2.1.1.tar.gz;
    #md5 = "70c9ccf9fac07f762c24f2df2290784d";
  };

  #buildInputs = [  unzip libtool file net_snmp libcxxStdenv glibc ];
  #buildInputs = [ cmake doxygen unzip libtool file net_snmp libcxxStdenv glibc ];
  #builder = ./builder.sh;
  #inherit perl;
  #inherit unzip;
  #inherit libtool;
  inherit file;

preConfigure = ''
               '';

  configureFlags = [ #"--with-mysql=\${out}/mysql-connector-c-6.1.3-linux-glibc2.5-x86_64/" ];
                     "--with-mysql=${mysql_c}"
                     "--with-snmp=${net_snmp}"
                    
                   ]; 
  meta = {
    description = "spine";
    homepage = "http://cacti.net/";
    license = "GPL2";
    maintainers = with stdenv.lib.maintainers; [predkambrij];
  };
}

