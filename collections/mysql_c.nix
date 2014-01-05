{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "mysql-connector-c-6.1.3_x86_64";
  builder = ./builder_mysql_c.sh;

  src = fetchurl {
    url = "http://dev.mysql.com/get/Downloads/Connector-C/mysql-connector-c-6.1.3-linux-glibc2.5-x86_64.tar.gz";
    sha256 = "da2a1ce49d5425699a6027b6b7c1b5975252313316f96a84c7819c84dafea853";
    md5 = "3161d47305234772db6d7ae30288a9ef";
  };

}
