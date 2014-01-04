source $stdenv/setup

echo "736,737c736,738
< install :: pure_install doc_install
< 	$(NOECHO) $(NOOP)
---
> install :: #pure_install doc_install
> 	true
> #	$(NOECHO) $(NOOP)" >fix.patch


tar xvfz $connector_64_bit
tar xvfz $src
unzip $snmp 

mkdir $(pwd)/snmp 
SNMP_INST_DIR=$(pwd)/snmp
MYSQL_CONNECTOR_DIR=$(pwd)/mysql-connector-c-6.1.3-linux-glibc2.5-x86_64
PATCH_FILE=$(pwd)/fix.patch

# build net-snmp
cd net-snmp*
#exit 1

./configure --prefix=$SNMP_INST_DIR --with-default-snmp-version=2 --with-defaults  
make 
#patch perl/Makefile $PATCH_FILE # TODO do proper fix 
make install
cd ..

# spine
#cd cacti-spine-0.8.8b 

#B# go to http://dev.mysql.com/downloads/ 
#3 http://dev.mysql.com/downloads/connector/ 
#ihttp://dev.mysql.com/downloads/connector/c/ 
#ihttp://dev.mysql.com/downloads/file.php?id=450628 

#mysql-connector-c-6.1.0-linux-glibc2.5-x86_64.tar.gz
#tar xvzf mysql-connector-c-6.1.0-linux-glibc2.5-i686.tar.gz 

#./configure  --prefix=$out  --with-mysql=/home/lojze/hacks/code/cacti_official/mysql-connector-c-6.1.0-linux-glibc2.5-i686sefe 
#./configure --prefix=$out  --with-mysql=/home/lojze/hacks/code/cacti_official/mysql-connector-c-6.1.0-linux-glibc2.5-x86_64/ -with-snmp=$out/snmp


#./configure --prefix=$out  --with-mysql=../mysql-connector*/ --with-snmp=$SNMP_INST_DIR

cd cacti-spine*
./configure --prefix=$out  --with-mysql=$MYSQL_CONNECTOR_DIR --with-snmp=$SNMP_INST_DIR
make
make install
 


##source $stdenv/setup
##
##PATH=$perl/bin:$PATH
##
##tar xvfz $src
##cp $src /tmp/helo
##cd hello-*
##./configure --prefix=$out
##make
##make install


