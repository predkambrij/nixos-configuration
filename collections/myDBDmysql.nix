#{stdenv, doxygen, fetchgit, cmake}:
#
#stdenv.mkDerivation rec {
#  name = "libnoise-1.0.0";
#
#  # i also change bits in the library and therefore i like to have it local
#  # in case i change anything this needs to be done to reflect the change
#  # 1. make the change 
#  # 2. use 'git add file_which_has_changed'
#  # 3. use 'git commit'
#  # 4. use 'git log' to find the most recent rev
#  # 5. paste the copied rev in the rev field below
#  # 6. reinstall the libnoise 
#  src = fetchgit {
#    url = /home/joachim/Desktop/projects/libnoise;
#    rev = "8b5b89b7241a112dfe0b387f7589ea9a2df00b02";
#    sha256 = "";
#  };
#
#  buildInputs = [ cmake doxygen ];
#
#  meta = {
#    description = "libnoise";
#    homepage = "http://www.github.com/qknight/libnoise";
#    license = "LGPL2";
#    maintainers = with stdenv.lib.maintainers; [qknight];
#  };
#}

{fetchurl, buildPerlPackage, DBI, mysql}:
#{fetchurl, buildPerlPackage, mysql}:

buildPerlPackage {
  name = "my-DBD-mysql-4.013";

  src = fetchurl {
    #url = mirror://cpan/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.013.tar.gz;
    url = "http://pkgs.fedoraproject.org/repo/pkgs/perl-DBD-MySQL/DBD-mysql-4.023.tar.gz/6ee956cf33ddce6441b36b6c1c983528/DBD-mysql-4.023.tar.gz";
    sha256 = "aaa7e9dfd21d9b1a06d485a16bf43a566bedbd812ff231e92c9dcbab4c049148";
  };

  buildInputs = [mysql] ;
  propagatedBuildInputs = [DBI];
  doCheck="";

#  makeMakerFlags = "MYSQL_HOME=${mysql}";
}

