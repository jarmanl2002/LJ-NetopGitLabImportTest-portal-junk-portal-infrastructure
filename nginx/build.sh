#!/bin/bash
IPDOCKERMASTER="172.17.0.1";
PATHTOPORTALAPIFILES="";
PATHTOPORTALAPICONFIG="";
PATHTOPORTALAPILOGS="";

PATHTONASFILES="";
PATHTONASCONFIG="";
PATHTONASLOGS="";

PATHTOPERMISSIONSFILES="";
PATHTOPERMISSIONSCONFIG="";
PATHTOPERMISSIONSLOGS="";

PATHTOWEBLOGS="";
PATHTOPORTALCDNFILES="";
PATHTONASFILES="";


readInfo () {
  echo $1;
  read tmp_read;
  if [ "$tmp_read" ]; then
    eval "$2=\"$tmp_read\"";
  fi
}

readInfoRequired () {
  infoReq="";
  while [[ -z "$infoReq" ]]
  do
    echo $1;
    read infoReq;
  done
  eval "$2=\"$infoReq\"";
}

readInfo "Enter the ip of the docker interface (default: 172.17.0.1)" IPDOCKERMASTER;

if [ -d build ]; then
  rm -rf build;
fi

mkdir build;
cp Dockerfile.nginx build/
cp nginx.conf build/
cp portalapi.netop.com.conf build/
cp -R cert build/

sed -i "s/$IPDOCKERMASTER/$1/g" build/portalapi.netop.com.conf;
if [ -f build.tar.gz ]; then
  rm -rf build.tar.gz
fi
tar czvf build.tar.gz build

docker build -t portal-local-nginx -f Dockerfile.nginx .

rm -rf build build.tar.gz


readInfoRequired "Enter full path to portalAPI project files" PATHTOPORTALAPIFILES;
readInfoRequired "Enter full path to portalAPI config folder" PATHTOPORTALAPICONFIG;
readInfoRequired "Enter full path to portalAPI logs folder" PATHTOPORTALAPILOGS;

readInfoRequired "Enter full path to nas project files" PATHTONASFILES;
readInfoRequired "Enter full path to nas config folder" PATHTONASCONFIG;
readInfoRequired "Enter full path to nas logs folder" PATHTONASLOGS;

readInfoRequired "Enter full path to permissions project files" PATHTOPERMISSIONSFILES;
readInfoRequired "Enter full path to permissions config folder" PATHTOPERMISSIONSCONFIG;
readInfoRequired "Enter full path to permissions logs folder" PATHTOPERMISSIONSLOGS;

readInfoRequired "Enter full path to portal statics (cdn) project files" PATHTOPORTALCDNFILES;
readInfoRequired "Enter full path to nas statics project files" PATHTONASFILES;

readInfoRequired "Enter full path to web logs folder" PATHTOWEBLOGS;

if [ -f docker-compose.yml ]; then
  rm -rf docker-compose.yml;
fi
cp docker-compose.yml.orig docker-compose.yml;

sed -i "s/fullpathportalcdn/$PATHTOPORTALCDNFILES/" docker-compose.yml
sed -i "s/fullpathnasstatics/$PATHTONASFILES/" docker-compose.yml
sed -i "s/fullpathweblogs/$PATHTOWEBLOGS/" docker-compose.yml
sed -i "s/fullpathtoportalproject/$PATHTOPORTALAPIFILES/" docker-compose.yml
sed -i "s/fullpathtoportalconfig/$PATHTOPORTALAPICONFIG/" docker-compose.yml
sed -i "s/fullpathtoportallogs/$PATHTOPORTALAPILOGS/" docker-compose.yml
sed -i "s/fullpathtopermissionsproject/$PATHTOPERMISSIONSFILES/" docker-compose.yml
sed -i "s/fullpathtopermissionsconfig/$PATHTOPERMISSIONSCONFIG/" docker-compose.yml
sed -i "s/fullpathtopermissionslogs/$PATHTOPERMISSIONSLOGS/" docker-compose.yml
sed -i "s/fullpathtonasproject/$PATHTONASFILES/" docker-compose.yml
sed -i "s/fullpathtonasconfig/$PATHTONASCONFIG/" docker-compose.yml
sed -i "s/fullpathtonaslogs/$PATHTONASLOGS/" docker-compose.yml

# todo sed to other config files

echo "you need to copy config files:";
echo "app-portal.env to $PATHTOPORTALAPICONFIG/app.env";
echo "app-nas.env to $PATHTONASCONFIG/app.env";
echo "app-permissions.env to $PATHTOPERMISSIONSCONFIG/app.env";

echo "";
echo "";      
echo "";      
echo "";      
echo "then you need to run 'docker-compose up' from this folder";
