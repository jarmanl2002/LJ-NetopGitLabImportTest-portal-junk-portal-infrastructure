#!/bin/bash
echo "Login to netop registry using domain credentials:"
docker login git.netop.com:4545

CURREND_DIRECTORY=`pwd`;
INSTALL_DIR="/home/itavy/tmp/transfer/projects";
DOCKER_IP="172.17.0.1";

mkdir -p "$INSTALL_DIR"/{portal,nas,weblogs,permissions};
mkdir -p "$INSTALL_DIR"/portal/{logs,config/env};
mkdir -p "$INSTALL_DIR"/nas/{logs,config/env};
mkdir -p "$INSTALL_DIR"/permissions/{logs,config};

cp confs/portal/app.env "$INSTALL_DIR"/portal/config/
cp confs/portal/{apikeys.json,env-config.json,production.js} "$INSTALL_DIR"/portal/config/env/

cp confs/nas/app.env "$INSTALL_DIR"/nas/config/
cp confs/nas/{env-config.js,production.js} "$INSTALL_DIR"/nas/config/env/

cp confs/permission/app.env "$INSTALL_DIR"/permissions/config/


SED_FILE="$INSTALL_DIR"/portal/config/env/production.js

sed -i "s/host: 'localhost',/host: '$DOCKER_IP',/" "$SED_FILE"
sed -i "s/'localhost:6379'/'$DOCKER_IP:6379'/" "$SED_FILE"

SED_FILE="$INSTALL_DIR"/portal/config/app.env
sed -i "s/<rabbitmqhost>:<rabbitmqport>\/<rabbitmqvhost>/$DOCKER_IP\/netop-local/" "$SED_FILE";
sed -i "s/<redishost>/$DOCKER_IP/" "$SED_FILE";
sed -i "s/mysql:\/\/root:dev@<host>\/portal/mysql:\/\/root:dev@$DOCKER_IP\/portal/" "$SED_FILE";

SED_FILE="$INSTALL_DIR"/nas/config/app.env
sed -i "s/<rabbitmqhost>:<rabbitmqport>\/<rabbitmqvhost>/$DOCKER_IP\/netop-local/" "$SED_FILE";
sed -i "s/<redis_host>/$DOCKER_IP/" "$SED_FILE";
sed -i "s/<db_host>/$DOCKER_IP/" "$SED_FILE";

SED_FILE="$INSTALL_DIR"/permissions/config/app.env
sed -i "s/<rabbitmqhost>:<rabbitmqport>\/<rabbitmqvhost>/$DOCKER_IP\/netop-local/" "$SED_FILE";
sed -i "s/<redis_host>/$DOCKER_IP/" "$SED_FILE";

git clone git@git.netop.com:portal/netop-portal-frontend.git "$INSTALL_DIR"/portal-frontend;
cd "$INSTALL_DIR"/portal-frontend;
npm install && npm run build;

git clone git@git.netop.com:portal/netop-nas-frontend.git "$INSTALL_DIR"/nas-frontend;
cd "$INSTALL_DIR"/nas-frontend;
npm install && npm run build;

git clone git@git.netop.com:portal/netop-portal-server.git "$INSTALL_DIR"/portal/project;
git clone git@git.netop.com:portal/netop-nas.git "$INSTALL_DIR"/nas/project;
git clone git@git.netop.com:portal/netop-permissions.git "$INSTALL_DIR"/permissions/project;
cd "$CURREND_DIRECTORY";


#MQ
cd rabbitmq
docker build -t netop-rabbitmq -f Dockerfile.rabbitmq . \
&& docker run -d --name netop-MQ -p 5671:5671 -p 5672:5672 -p 25672:25672 -p 4369:4369 -d netop-rabbitmq \
&& docker exec -t netop-MQ /bin/sh -c "cd /root && ./test.sh && ./doQueues.sh"

cd ../

#MYSQL
cd mysql
docker build -t netop-mysql -f Dockerfile.mysql .
docker run --name netop-db -e MYSQL_ROOT_PASSWORD=dev -p 3306:3306 -d netop-mysql
cd ../

#REDIS
docker run --name netop-cache -p 6379:6379 -d redis:latest

#NGINX
cd nginx;
if [ -d build ]; then
  rm -rf build;
fi
mkdir build;
cp Dockerfile.nginx build/
cp nginx.conf build/
cp portalapi.netop.com.conf build/
cp -R cert build/

sed -i "s/<dockerip>/$DOCKER_IP/g" build/portalapi.netop.com.conf;
if [ -f build.tar.gz ]; then
  rm -rf build.tar.gz
fi
tar czvf build.tar.gz build

docker build -t netop-nginx -f Dockerfile.nginx .

rm -rf build build.tar.gz


docker run \
--name netop-web \
-p 80:80 -p 443:443 \
-v "$INSTALL_DIR"/portal-frontend/public/dist:/usr/share/nginx/html/portal \
-v "$INSTALL_DIR"/nas-frontend/public/dist:/usr/share/nginx/html/nas \
-v "$INSTALL_DIR"/weblogs:/var/log/nginx/netop \
-d netop-nginx 



docker run \
-d \
--name netop-portal \
-p 8084:80 \
-v "$INSTALL_DIR"/portal/project:/netop-worker/files \
-v "$INSTALL_DIR"/portal/config:/netop-worker/config \
-v "$INSTALL_DIR"/portal/logs:/netop-worker/logs \
git.netop.com:4545/portal/portal-docker-images:developer_F24_N0.12.7_PB3.0.2

echo "install portal dependencies"
docker exec -t netop-portal /bin/sh -c "cd /netop-worker/files && npm install"
echo "finish install portal dependencies"
docker stop netop-portal

docker run \
-d \
--name netop-nas \
-p 8083:80 \
-v "$INSTALL_DIR"/nas/project:/netop-worker/files \
-v "$INSTALL_DIR"/nas/config:/netop-worker/config \
-v "$INSTALL_DIR"/nas/logs:/netop-worker/logs \
git.netop.com:4545/portal/portal-docker-images:developer_F24_N0.12.7_PB3.0.2



echo "install nas dependencies"
docker exec -t netop-nas /bin/sh -c "cd /netop-worker/files && npm install"
echo "finish nas dependencies"

docker stop netop-nas

docker run \
-d \
--name netop-permissions \
-v "$INSTALL_DIR"/permissions/project:/netop-worker/files \
-v "$INSTALL_DIR"/permissions/config:/netop-worker/config \
-v "$INSTALL_DIR"/permissions/logs:/netop-worker/logs \
git.netop.com:4545/portal/portal-docker-images:developer_F24_N0.12.7_PB3.0.2
echo "install permissions dependencies"
docker exec -t netop-permissions /bin/sh -c "cd /netop-worker/files && npm install"
echo "finish permissions dependencies"

docker stop netop-permissions
