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
yum install wget 
wget -P /usr/local/pgsql $1
balla=$(ls /usr/local/pgsql | grep post)
echo "Untar $balla file.It takes some time"
cd /usr/local/pgsql
tar --checkpoint=.100  -xzf "$balla"
echo " "
patheka=$(find . -type d -iname "postgresql*"| head -1 )
echo "$patheka"
cd "$patheka" && mv * ..
cd .. && ./configure
gmake install 

   if [ ! -d "/rezsystem/rezadmin" ];then
      mkdir /rezsystem/rezadmin  -p
      echo "path created"
   fi
      
#sed -i '2s/$/ export PATH=$PATH:\/rezsystem\/rezadmin/' /etc/bashrc
#bash
cd /rezsystem/rezadmin/ && touch pgstop pgstart
echo "pkill post*" > pgstop
chown postgres.postgres pgstop
chmod 700 pgstop

echo "nohup /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data & &>/dev/null" > pgstart
chown postgres.postgres pgstart
chmod 700 pgstart
#########################################have to input details to pgstop start


su postgres << 'EOT'
  echo `whoami`
  /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data &>/dev/null

EOT

echo `whoami`

sed -i '2s/$/ export PATH=$PATH:\/rezsystem\/rezadmin/' /etc/bashrc
bash

else

  echo "you must become root"
  exit 1 ;
fi
