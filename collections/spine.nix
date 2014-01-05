{stdenv, fetchurl, libtool, file, net_snmp, glibc, mysql_c, openssl}:

stdenv.mkDerivation rec {
  name = "spine-0.8.8b";

  src = fetchurl {
    url = "http://www.cacti.net/downloads/spine/cacti-spine-0.8.8b.tar.gz";
    sha256 = "fc5d512c1de46db2b48422856e8c6a5816d110083d0bbbf7f9d660f0829912a6";
  };

  buildInputs = [ libtool file net_snmp glibc mysql_c net_snmp ];
  builder = ./builder.sh;

  inherit mysql_c;
  inherit net_snmp;
  inherit openssl;

  meta = {
    description = "Spine - cacti poller written in native C";
    homepage = "http://cacti.net/spine_info.php";
    license = "GPL2";
    maintainers = stdenv.lib.maintainers.predkambrij;
  };
}

