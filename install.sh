#!/bin/bash
if [ $# -ne 2 ]; then
  echo "invalid number of arguments";
  echo "first parameter must be full path to projects folder";
  echo "second parameter must me the ip of the docker interface (ex. docker0)";
  exit 2;
fi

#sed completion for osx
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    SED_COMPLETION="";
elif [[ "$OSTYPE" == "darwin"* ]]; then
    SED_COMPLETION=" \"\"";
else
  echo "Unsuported platform";
  exit 2;
fi

echo "Login to netop docker registry using domain credentials:"
docker login git.netop.com:4545 || exit 1;

echo "Trying to get latest image for developer";
docker pull git.netop.com:4545/portal/portal-docker-images:developer_F24_N0.12.7_PB3.0.2 || exit 1;

CURREND_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

# variables for install setup
INSTALL_DIR="$1" # ex "/home/itavy/tmp/transfer/test2";
DOCKER_IP="$2" # ex "172.17.0.1";


# user details for folders mappings
NETOP_USER_NAME=`id -un`;
NETOP_USER_ID=`id -u`;
NETOP_USER_GROUP_ID=`id -g $NETOP_USER_NAME`;
NETOP_USER_GROUP_NAME=`id -gn $NETOP_USER_NAME`;


if [ -f Dockerfile.localDeveloper ]; then
  rm -rf Dockerfile.localDeveloper;
fi

if [ "$NETOP_USER_ID" == "0" ]; then
  cp Dockerfile.root.localDeveloper Dockerfile.localDeveloper;
else
  cp Dockerfile.netopDeveloper Dockerfile.localDeveloper;
  sed -i$SED_COMPLETION "s/<user_name>/$NETOP_USER_NAME/g" Dockerfile.localDeveloper;
  sed -i$SED_COMPLETION "s/<group_id>/$NETOP_USER_GROUP_ID/g" Dockerfile.localDeveloper;
  sed -i$SED_COMPLETION "s/<group_name>/$NETOP_USER_GROUP_NAME/g" Dockerfile.localDeveloper;
  sed -i$SED_COMPLETION "s/<user_id>/$NETOP_USER_ID/g" Dockerfile.localDeveloper;
fi

docker build -t netop_local_develop -f Dockerfile.localDeveloper .

mkdir -p "$INSTALL_DIR"/{portal,nas,weblogs,permissions};
mkdir -p "$INSTALL_DIR"/portal/{logs,config/env};
mkdir -p "$INSTALL_DIR"/nas/{logs,config/env};
mkdir -p "$INSTALL_DIR"/permissions/{logs,config};

cp confs/portal/app.env "$INSTALL_DIR"/portal/config/
cp confs/portal/{apikeys.json,env-config.json,production.js} "$INSTALL_DIR"/portal/config/env/

cp confs/nas/app.env "$INSTALL_DIR"/nas/config/
cp confs/nas/{env-config.js,production.js} "$INSTALL_DIR"/nas/config/env/

cp confs/permission/app.env "$INSTALL_DIR"/permissions/config/


#production file for portal
SED_FILE="$INSTALL_DIR"/portal/config/env/production.js
sed -i$SED_COMPLETION "s/host: 'localhost',/host: '$DOCKER_IP',/" "$SED_FILE"
sed -i$SED_COMPLETION "s/'localhost:6379'/'$DOCKER_IP:6379'/" "$SED_FILE"

#app.env for portal
SED_FILE="$INSTALL_DIR"/portal/config/app.env
sed -i$SED_COMPLETION "s/<rabbitmqhost>:<rabbitmqport>\/<rabbitmqvhost>/$DOCKER_IP\/netop-local/" "$SED_FILE";
sed -i$SED_COMPLETION "s/<redishost>/$DOCKER_IP/" "$SED_FILE";
sed -i$SED_COMPLETION "s/mysql:\/\/root:dev@<host>\/portal/mysql:\/\/root:dev@$DOCKER_IP\/portal/" "$SED_FILE";
sed -i$SED_COMPLETION "s/<_nasip_>/$DOCKER_IP/" "$SED_FILE"; # nas-local.netop.com to hosts

#app.env for nas
SED_FILE="$INSTALL_DIR"/nas/config/app.env
sed -i$SED_COMPLETION "s/<rabbitmqhost>:<rabbitmqport>\/<rabbitmqvhost>/$DOCKER_IP\/netop-local/" "$SED_FILE";
sed -i$SED_COMPLETION "s/<redis_host>/$DOCKER_IP/" "$SED_FILE";
sed -i$SED_COMPLETION "s/<db_host>/$DOCKER_IP/" "$SED_FILE";

#app.env for permissions
SED_FILE="$INSTALL_DIR"/permissions/config/app.env
sed -i$SED_COMPLETION "s/<rabbitmqhost>:<rabbitmqport>\/<rabbitmqvhost>/$DOCKER_IP\/netop-local/" "$SED_FILE";
sed -i$SED_COMPLETION "s/<redis_host>/$DOCKER_IP/" "$SED_FILE";


#nginx requirements
cd nginx;
if [ -d build ]; then
  rm -rf build;
fi
mkdir build;
cp Dockerfile.nginx build/
cp nginx.conf build/
cp portalapi.netop.com.conf build/
cp -R cert build/

sed -i$SED_COMPLETION "s/<dockerip>/$DOCKER_IP/g" build/portalapi.netop.com.conf;
if [ -f build.tar.gz ]; then
  rm -rf build.tar.gz
fi
tar czvf build.tar.gz build

#git projects
git clone git@git.netop.com:portal/netop-portal-frontend.git "$INSTALL_DIR"/portal-frontend;
cd "$INSTALL_DIR"/portal-frontend;
git checkout develop;
npm install && npm run build;

git clone git@git.netop.com:portal/netop-nas-frontend.git "$INSTALL_DIR"/nas-frontend;
cd "$INSTALL_DIR"/nas-frontend;
git checkout develop;
npm install && npm run build;

git clone git@git.netop.com:portal/netop-portal-server.git "$INSTALL_DIR"/portal/project;
cd "$INSTALL_DIR"/portal/project;
git checkout develop;
git clone git@git.netop.com:portal/netop-nas.git "$INSTALL_DIR"/nas/project;
cd "$INSTALL_DIR"/nas/project;
git checkout develop;
git clone git@git.netop.com:portal/netop-permissions.git "$INSTALL_DIR"/permissions/project;
cd "$INSTALL_DIR"/permissions/project;
git checkout develop;

cd "$CURREND_DIRECTORY";
chown -R $NETOP_USER_NAME. $INSTALL_DIR;

# this can be converted to docker-compose when i will figure out how to inject definitions at build time
#MQ



# end docker compose

rm -rf "$CURREND_DIRECTORY"/nginx/build "$CURREND_DIRECTORY"/nginx/build.tar.gz

echo "You must add following line to /etc/hosts:"
echo "$DOCKER_IP  nas-local.netop.com portal-local.netop.com";
echo ""
echo ""
echo "if you need to run a command inside docker use the following command:"
echo "docker exec -it (<dockerid>|<docker-name>) /usr/local/bin/su-exec $NETOP_USER_NAME /bin/bash";
