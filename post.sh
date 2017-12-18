#!/bin/bash

DIRECTORY='/usr/local/pgsql/data'



if [ $USER == "root" ];then
    
	cat /etc/passwd | grep postgres > /dev/null 2>&1
	if [ $? -ne 0 ];then
	   useradd postgres
           echo "New postgres User Created"
	fi

   yum -y install zlib*
   yum -y install readline*
   yum -y install gcc*
   yum -y install tcl-devel
   yum -y install make
   
   if [ ! -d "/usr/local/pgsql/data" ];then
      mkdir /usr/local/pgsql/data -p
      chown postgres.postgres /usr/local/pgsql/data
      echo "path ownership created"
         
   fi

wget -P /usr/local/pgsql $1
balla=$(ls /usr/local/pgsql | grep post)
echo "Untar $balla file.It takes some time"
cd /usr/local/pgsql
tar --checkpoint=.100  -xzf "$balla"
echo " "
patheka=$(find . -type d -iname "post*"| head -1 )
echo "$patheka"
cd "$patheka" && mv * ..
cd .. && ./configure
gmake install 
######################################################################
   if [ ! -d "/rezsystem/rezadmin" ];then
      mkdir /rezsystem/rezadmin  -p
      echo "path created"
      sed -i '2s/$/ export PATH=$PATH:\/rezsystem\/rezadmin/' /etc/bashrc
   fi
###################################################################### working on this

su postgres << 'EOT'
  echo `whoami`
  /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data

EOT

echo `whoami`

else

  echo "you must become root"
  exit 1 ;
fi
