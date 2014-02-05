{stdenv, fetchurl, libtool, file, net_snmp, glibc, mysql_c, openssl}:

stdenv.mkDerivation rec {
  name = "stress-1.0.4";

  src = fetchurl {
    url = "http://people.seas.harvard.edu/~apw/stress/stress-1.0.4.tar.gz";
    sha256 = "f6642ae62ae0eb16368bce29181a15c7743129ea51c7184f45e161e21db3360b";
  };

  meta = {
    description = "stress is a deliberately simple workload generator for POSIX systems";
    homepage = "http://people.seas.harvard.edu/~apw/stress/";
    license = "GPL2";
    maintainers = stdenv.lib.maintainers.predkambrij;
  };
}

