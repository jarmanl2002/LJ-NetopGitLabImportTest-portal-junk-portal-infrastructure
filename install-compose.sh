#!/bin/bash
if [ $# -ne 1 ]; then
  echo "invalid number of arguments";
  echo "first parameter must be full path to projects folder";
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


CURRENT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

source "$CURRENT_DIRECTORY/docker-compose.env";

# docker compose tags
COMPOSE_CACHE="netop-cache";
COMPOSE_DB="netop-db";
COMPOSE_MQ="netop-mq";
COMPOSE_WEB="netop-web";

COMPOSE_PORTAL="netop-portal";
COMPOSE_NAS="netop-nas";
COMPOSE_PERMISSIONS="netop-permissions";

# variables for install setup
INSTALL_DIR="$1" # ex "/home/itavy/tmp/transfer/test2";
# DOCKER_IP="$2" # ex "172.17.0.1";


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
mkdir -p "$INSTALL_DIR"/database;

cp confs/portal/app.env "$INSTALL_DIR"/portal/config/
cp confs/portal/{apikeys.json,env-config.json,production.js} "$INSTALL_DIR"/portal/config/env/

cp confs/nas/app.env "$INSTALL_DIR"/nas/config/
cp confs/nas/{env-config.js,production.js} "$INSTALL_DIR"/nas/config/env/

cp confs/permission/app.env "$INSTALL_DIR"/permissions/config/



#production file for portal
SED_FILE="$INSTALL_DIR"/portal/config/env/production.js
sed -i$SED_COMPLETION "s/host: 'localhost',/host: '$COMPOSE_CACHE',/" "$SED_FILE"
sed -i$SED_COMPLETION "s/'localhost:6379'/'$COMPOSE_CACHE:6379'/" "$SED_FILE"

#app.env for portal
SED_FILE="$INSTALL_DIR"/portal/config/app.env
sed -i$SED_COMPLETION "s/<rabbitmqhost>:<rabbitmqport>\/<rabbitmqvhost>/$COMPOSE_MQ\/netop-local/" "$SED_FILE";
sed -i$SED_COMPLETION "s/<redishost>/$COMPOSE_CACHE/" "$SED_FILE";
sed -i$SED_COMPLETION "s/mysql:\/\/root:dev@<host>\/portal/mysql:\/\/root:dev@$COMPOSE_DB\/portal/" "$SED_FILE";

sed -i$SED_COMPLETION "s/<_nasip_>/d" "$SED_FILE";
sed -i$SED_COMPLETION "s/NAS_HOST/d" "$SED_FILE";
sed -i$SED_COMPLETION "s/^fi/d" "$SED_FILE";


#app.env for nas
SED_FILE="$INSTALL_DIR"/nas/config/app.env
sed -i$SED_COMPLETION "s/<rabbitmqhost>:<rabbitmqport>\/<rabbitmqvhost>/$COMPOSE_MQ\/netop-local/" "$SED_FILE";
sed -i$SED_COMPLETION "s/<redis_host>/$COMPOSE_CACHE/" "$SED_FILE";
sed -i$SED_COMPLETION "s/<db_host>/$COMPOSE_DB/" "$SED_FILE";

#app.env for permissions
SED_FILE="$INSTALL_DIR"/permissions/config/app.env
sed -i$SED_COMPLETION "s/<rabbitmqhost>:<rabbitmqport>\/<rabbitmqvhost>/$COMPOSE_MQ\/netop-local/" "$SED_FILE";
sed -i$SED_COMPLETION "s/<redis_host>/$COMPOSE_CACHE/" "$SED_FILE";

#docker compose setup
cd "$CURRENT_DIRECTORY";
if [ -f docker-compose.yml ]; then
  rm -rf docker-compose.yml;
fi
cp docker-compose.yml.netopDeveloper docker-compose.yml
SED_FILE="$CURRENT_DIRECTORY"/docker-compose.yml;

sed -i$SED_COMPLETION "s#netop_portal_install_dir_placeholder#$INSTALL_DIR#g" "$SED_FILE";

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

sed -i$SED_COMPLETION "s/<dockerip-portal>/$COMPOSE_PORTAL/g" build/portalapi.netop.com.conf;
sed -i$SED_COMPLETION "s/<dockerip-nas>/$COMPOSE_NAS/g" build/portalapi.netop.com.conf;
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

cd "$CURRENT_DIRECTORY";
#chown -R $NETOP_USER_NAME. $INSTALL_DIR/{portal,nas,portal,nas-frontend,portal-frontend,permissions};


"$COMPOSE_COMMAND" up -d "$COMPOSE_DB" || exit 1;
"$COMPOSE_COMMAND" up -d "$COMPOSE_CACHE" || exit 1;
"$COMPOSE_COMMAND" up -d "$COMPOSE_MQ" || exit 1;

"$COMPOSE_COMMAND" up -d "$COMPOSE_PORTAL" || exit 1;
"$COMPOSE_COMMAND" up -d "$COMPOSE_NAS" || exit 1;
"$COMPOSE_COMMAND" up -d "$COMPOSE_PERMISSIONS" || exit 1;

"$COMPOSE_COMMAND" up -d "$COMPOSE_WEB" || exit 1;

rm -rf "$CURRENT_DIRECTORY"/nginx/build "$CURRENT_DIRECTORY"/nginx/build.tar.gz

echo "install portal dependencies"
"$COMPOSE_COMMAND" exec netop-portal /usr/local/bin/su-exec $NETOP_USER_NAME /bin/sh -c "cd /netop-worker/files && /usr/local/bin/npm install && /usr/local/bin/npm run postinstall";
echo "finish install portal dependencies"

echo "install nas dependencies"
"$COMPOSE_COMMAND" exec netop-nas /usr/local/bin/su-exec $NETOP_USER_NAME /bin/sh -c "cd /netop-worker/files && /usr/local/bin/npm install && /usr/local/bin/npm run postinstall";
echo "finish nas dependencies"

echo "install permissions dependencies"
"$COMPOSE_COMMAND" exec netop-permissions /usr/local/bin/su-exec $NETOP_USER_NAME /bin/sh -c "cd /netop-worker/files && /usr/local/bin/npm install";
echo "finish permissions dependencies"

"$COMPOSE_COMMAND" restart netop-nas
"$COMPOSE_COMMAND" restart netop-portal
"$COMPOSE_COMMAND" restart netop-permissions

echo "You must add following line to /etc/hosts:"
echo "<ip docker-engine interface>  nas-local.netop.com portal-local.netop.com";
echo ""
echo ""
echo "if you need to run a command inside docker use the following command:"
echo "docker exec -it (<dockerid>|<docker-name>) /usr/local/bin/su-exec $NETOP_USER_NAME /bin/bash";
echo "or"
echo "$COMPOSE_COMMAND exec (<service-name>) /usr/local/bin/su-exec $NETOP_USER_NAME /bin/bash";
