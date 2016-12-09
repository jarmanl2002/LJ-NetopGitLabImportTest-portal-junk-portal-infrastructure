#!/bin/bash
# docker compose tags
COMPOSE_CACHE="netop-cache";
COMPOSE_DB="netop-db";
COMPOSE_MQ="netop-mq";
COMPOSE_WEB="netop-web";

COMPOSE_PORTAL="netop-portal";
COMPOSE_NAS="netop-nas";
COMPOSE_PERMISSIONS="netop-permissions";

if [ $# -lt 1 ]; then
  echo "invalid number of arguments";
  echo "first parameter must be full path to projects folder";
  echo "second is optional and can be the name of the service you want to rebuild:"
  echo "$COMPOSE_CACHE";
  echo "$COMPOSE_DB";
  echo "$COMPOSE_MQ";
  echo "$COMPOSE_WEB";
  echo "$COMPOSE_PORTAL";
  echo "$COMPOSE_NAS";
  echo "$COMPOSE_PERMISSIONS";
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

CURRENT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

source "$CURRENT_DIRECTORY/docker-compose.env";

# variables for install setup
INSTALL_DIR="$1" # ex "/home/itavy/tmp/transfer/test2";
BUILD_OPTION="all";
if [ $# -gt 1 ]; then
    BUILD_OPTION=$2;
fi


# user details for folders mappings
NETOP_USER_NAME=`id -un`;
NETOP_USER_ID=`id -u`;
NETOP_USER_GROUP_ID=`id -g $NETOP_USER_NAME`;
NETOP_USER_GROUP_NAME=`id -gn $NETOP_USER_NAME`;

doLocalImageForDevelopment () {
    echo "Login to netop docker registry using domain credentials:"
    docker login git.netop.com:4545 || exit 1;

    echo "Trying to get latest image for developer";
    docker pull git.netop.com:4545/portal/portal-docker-images:developer_F24_N6.9.1_PB3.0.2 || exit 1;

    echo "Trying to get latest image for nas developer";
    docker pull git.netop.com:4545/portal/portal-docker-images:developer_F24_N0.12.7_PB3.0.2 || exit 1;

    cd "$CURRENT_DIRECTORY";
    if [ -f Dockerfile.localDeveloper ]; then
      rm -rf Dockerfile.localDeveloper;
    fi

    if [ "$NETOP_USER_ID" == "0" ]; then
      cp Dockerfile.root.localDeveloper Dockerfile.localDeveloper;
      cp Dockerfile.root.nasdeveloper Dockerfile.nas.localDeveloper;
    else
      echo "Local developer image"
      cp Dockerfile.netopDeveloper Dockerfile.localDeveloper;
      sed -i$SED_COMPLETION "s/<user_name>/$NETOP_USER_NAME/g" Dockerfile.localDeveloper;
      sed -i$SED_COMPLETION "s/<group_id>/$NETOP_USER_GROUP_ID/g" Dockerfile.localDeveloper;
      sed -i$SED_COMPLETION "s/<group_name>/$NETOP_USER_GROUP_NAME/g" Dockerfile.localDeveloper;
      sed -i$SED_COMPLETION "s/<user_id>/$NETOP_USER_ID/g" Dockerfile.localDeveloper;

      echo "Old nas Local developer image"
      cp Dockerfile.nasdeveloper Dockerfile.nas.localDeveloper;
      sed -i$SED_COMPLETION "s/<user_name>/$NETOP_USER_NAME/g" Dockerfile.nas.localDeveloper;
      sed -i$SED_COMPLETION "s/<group_id>/$NETOP_USER_GROUP_ID/g" Dockerfile.nas.localDeveloper;
      sed -i$SED_COMPLETION "s/<group_name>/$NETOP_USER_GROUP_NAME/g" Dockerfile.nas.localDeveloper;
      sed -i$SED_COMPLETION "s/<user_id>/$NETOP_USER_ID/g" Dockerfile.nas.localDeveloper;
    fi

    docker build -t netop_local_develop -f Dockerfile.localDeveloper .
    docker build -t netop_nas_local_develop -f Dockerfile.nas.localDeveloper .
    cd "$CURRENT_DIRECTORY";
}

doDockerComposeFile () {
    cd "$CURRENT_DIRECTORY";
    if [ -f docker-compose.yml ]; then
      rm -rf docker-compose.yml;
    fi
    cp docker-compose.yml.netopDeveloper docker-compose.yml
    SED_FILE="$CURRENT_DIRECTORY"/docker-compose.yml;

    sed -i$SED_COMPLETION "s#netop_portal_install_dir_placeholder#$INSTALL_DIR#g" "$SED_FILE";
    cd "$CURRENT_DIRECTORY";
}

doPortalWorker ()
{
    echo "Building Netop Portal worker environment";
    cd "$CURRENT_DIRECTORY";
    if [ ! -d "$INSTALL_DIR"/portal/config ]; then
        mkdir -p "$INSTALL_DIR"/portal/config/env;
        # cp confs/portal/app.env "$INSTALL_DIR"/portal/config/
        cp confs/portal/app.yml "$INSTALL_DIR"/portal/config/
        cp confs/portal/{apikeys.json,env-config.json,production.js} "$INSTALL_DIR"/portal/config/env/

        #production file for portal
        SED_FILE="$INSTALL_DIR"/portal/config/env/production.js
        sed -i$SED_COMPLETION "s/host: 'localhost',/host: '$COMPOSE_CACHE',/" "$SED_FILE"
        sed -i$SED_COMPLETION "s/'localhost:6379'/'$COMPOSE_CACHE:6379'/" "$SED_FILE"

        #app.env for portal
        #SED_FILE="$INSTALL_DIR"/portal/config/app.env
        SED_FILE="$INSTALL_DIR"/portal/config/app.yml
        sed -i$SED_COMPLETION "s/<rabbitmqhost>:<rabbitmqport>\/<rabbitmqvhost>/$COMPOSE_MQ\/netop-local/" "$SED_FILE";
        sed -i$SED_COMPLETION "s/<redishost>/$COMPOSE_CACHE/" "$SED_FILE";
        sed -i$SED_COMPLETION "s/mysql:\/\/root:dev@<host>\/portal/mysql:\/\/root:dev@$COMPOSE_DB\/portal/" "$SED_FILE";

        #sed -i$SED_COMPLETION "/<_nasip_>/d" "$SED_FILE";
        #sed -i$SED_COMPLETION "/NAS_HOST/d" "$SED_FILE";
        #sed -i$SED_COMPLETION "/^fi/d" "$SED_FILE";
    fi

    if [ ! -d "$INSTALL_DIR"/portal/logs ]; then
        mkdir -p "$INSTALL_DIR"/portal/logs;
    fi

    if [ ! -d "$INSTALL_DIR"/portal/project ]; then
        git clone git@git.netop.com:portal/netop-portal-server.git "$INSTALL_DIR"/portal/project;
        cd "$INSTALL_DIR"/portal/project;
        git checkout develop;
    fi
    cd "$CURRENT_DIRECTORY";

    "$COMPOSE_COMMAND" up -d "$COMPOSE_PORTAL" || exit 1;

    echo "install portal dependencies"
    "$COMPOSE_COMMAND" exec "$COMPOSE_PORTAL" /usr/local/bin/su-exec $NETOP_USER_NAME /bin/sh -c "cd /netop-worker/files && /usr/local/bin/npm install && /usr/local/bin/npm run postinstall";
    echo "finish install portal dependencies";

    # restart needed only at first install when there are no dependencies installed
    "$COMPOSE_COMMAND" restart "$COMPOSE_PORTAL"
    cd "$CURRENT_DIRECTORY";
}

doNasWorker ()
{
    echo "Build Netop NAS worker environment";
    cd "$CURRENT_DIRECTORY";
    if [ ! -d "$INSTALL_DIR"/nas/logs ]; then
        mkdir -p "$INSTALL_DIR"/nas/logs;
    fi

    if [ ! -d "$INSTALL_DIR"/nas/config ]; then
        mkdir -p "$INSTALL_DIR"/nas/config;
        #cp confs/nas/app.env "$INSTALL_DIR"/nas/config/;
        cp confs/nas/app.yml "$INSTALL_DIR"/nas/config/;
        cp confs/nas/{env-config.js,production.js} "$INSTALL_DIR"/nas/config/env/;

        #SED_FILE="$INSTALL_DIR"/nas/config/app.env
        SED_FILE="$INSTALL_DIR"/nas/config/app.yml
        sed -i$SED_COMPLETION "s/<rabbitmqhost>:<rabbitmqport>\/<rabbitmqvhost>/$COMPOSE_MQ\/netop-local/" "$SED_FILE";
        sed -i$SED_COMPLETION "s/<redis_host>/$COMPOSE_CACHE/" "$SED_FILE";
        sed -i$SED_COMPLETION "s/<db_host>/$COMPOSE_DB/" "$SED_FILE";
    fi

    if [ ! -d "$INSTALL_DIR"/nas/project ]; then
        git clone git@git.netop.com:portal/netop-nas.git "$INSTALL_DIR"/nas/project;
        cd "$INSTALL_DIR"/nas/project;
        git checkout develop;
    fi
    cd "$CURRENT_DIRECTORY";
    "$COMPOSE_COMMAND" up -d "$COMPOSE_NAS" || exit 1;

    echo "install nas dependencies"
    "$COMPOSE_COMMAND" exec "$COMPOSE_NAS" /usr/local/bin/su-exec $NETOP_USER_NAME /bin/sh -c "cd /netop-worker/files && /usr/local/bin/npm install && /usr/local/bin/npm run postinstall";
    echo "finish nas dependencies"

    # restart needed only at first install when there are no dependencies installed
    "$COMPOSE_COMMAND" restart "$COMPOSE_NAS"
    cd "$CURRENT_DIRECTORY";
}

doPermissionsWorker ()
{
    echo "Build Permissions worker environment"
    cd "$CURRENT_DIRECTORY";
    if [ ! -d "$INSTALL_DIR"/permissions/logs ]; then
        mkdir -p "$INSTALL_DIR"/permissions/logs;
    fi

    if [ ! -d "$INSTALL_DIR"/permissions/config ]; then
        mkdir -p "$INSTALL_DIR"/permissions/config;
        #cp confs/permission/app.env "$INSTALL_DIR"/permissions/config/
        cp confs/permission/app.yml "$INSTALL_DIR"/permissions/config/

        #app.env for permissions
        #SED_FILE="$INSTALL_DIR"/permissions/config/app.env
        SED_FILE="$INSTALL_DIR"/permissions/config/app.yml
        sed -i$SED_COMPLETION "s/<rabbitmqhost>:<rabbitmqport>\/<rabbitmqvhost>/$COMPOSE_MQ\/netop-local/" "$SED_FILE";
        sed -i$SED_COMPLETION "s/<redis_host>/$COMPOSE_CACHE/" "$SED_FILE";
    fi

    if [ ! -d "$INSTALL_DIR"/permissions/project ]; then
        git clone git@git.netop.com:portal/netop-permissions.git "$INSTALL_DIR"/permissions/project;
        cd "$INSTALL_DIR"/permissions/project;
        git checkout develop;
    fi

    cd "$CURRENT_DIRECTORY";
    "$COMPOSE_COMMAND" up -d "$COMPOSE_PERMISSIONS" || exit 1;
    echo "install permissions dependencies"
    "$COMPOSE_COMMAND" exec "$COMPOSE_PERMISSIONS" /usr/local/bin/su-exec $NETOP_USER_NAME /bin/sh -c "cd /netop-worker/files && /usr/local/bin/npm install";
    echo "finish permissions dependencies"

    # restart needed only at first install when there are no dependencies installed
    "$COMPOSE_COMMAND" restart "$COMPOSE_PERMISSIONS"
    cd "$CURRENT_DIRECTORY";
}

doNetopDatabase ()
{
    echo "Build Netop Databse Service";
    cd "$CURRENT_DIRECTORY";
    if [ ! -d "$INSTALL_DIR"/database ]; then
        mkdir -p "$INSTALL_DIR"/database;
    fi
    "$COMPOSE_COMMAND" up -d "$COMPOSE_DB" || exit 1;
    cd "$CURRENT_DIRECTORY";
}

doNetopCache ()
{
    echo "Build Netop Cache Service";
    cd "$CURRENT_DIRECTORY";
    "$COMPOSE_COMMAND" up -d "$COMPOSE_CACHE" || exit 1;
}

doNetopMq ()
{
    echo "Build Netop MQ Service";
    cd "$CURRENT_DIRECTORY";
    "$COMPOSE_COMMAND" up -d "$COMPOSE_MQ" || exit 1;
}


doNetopWeb ()
{
    echo "Build Netop WebFrontService";
    cd "$CURRENT_DIRECTORY";
    if [ ! -d "$INSTALL_DIR"/nas-frontend ]; then
        git clone git@git.netop.com:portal/netop-nas-frontend.git "$INSTALL_DIR"/nas-frontend;
        cd "$INSTALL_DIR"/nas-frontend;
        git checkout develop;
        npm install && npm run build;
    fi
    if [ ! -d "$INSTALL_DIR"/portal-frontend ]; then
        git clone git@git.netop.com:portal/netop-portal-frontend.git "$INSTALL_DIR"/portal-frontend;
        cd "$INSTALL_DIR"/portal-frontend;
        git checkout develop;
        npm install && npm run build;
    fi

    if [ ! -d "$INSTALL_DIR"/weblogs ]; then
        mkdir "$INSTALL_DIR"/weblogs;
    fi
    cd "$CURRENT_DIRECTORY"/nginx;
    if [ -d build ]; then
      rm -rf build;
    fi
    mkdir build;
    cp nginx.conf build/
    cp portalapi.netop.com.conf build/
    cp -R cert build/

    sed -i$SED_COMPLETION "s/<dockerip-portal>/$COMPOSE_PORTAL/g" build/portalapi.netop.com.conf;
    sed -i$SED_COMPLETION "s/<dockerip-nas>/$COMPOSE_NAS/g" build/portalapi.netop.com.conf;
    if [ -f build.tar.gz ]; then
      rm -rf build.tar.gz
    fi
    tar czvf build.tar.gz build

    cd "$CURRENT_DIRECTORY";

    "$COMPOSE_COMMAND" up -d "$COMPOSE_WEB" || exit 1;
    rm -rf "$CURRENT_DIRECTORY"/nginx/build "$CURRENT_DIRECTORY"/nginx/build.tar.gz
    cd "$CURRENT_DIRECTORY";
}

doShowSuccessFinal ()
{
    echo "You must add following line to /etc/hosts:"
    echo "<ip docker-engine interface>  nas-local.netop.com portal-local.netop.com";
    echo ""
    echo ""
    echo "if you need to run a command inside docker use the following command:"
    echo "docker exec -it (<dockerid>|<docker-name>) /usr/local/bin/su-exec $NETOP_USER_NAME /bin/bash";
    echo "or"
    echo "$COMPOSE_COMMAND exec (<service-name>) /usr/local/bin/su-exec $NETOP_USER_NAME /bin/bash";
}

doPreBuild ()
{
    doLocalImageForDevelopment
    doDockerComposeFile
}
case "$BUILD_OPTION" in
    $COMPOSE_CACHE)
        doPreBuild
        doNetopCache
        ;;
    $COMPOSE_DB)
        doPreBuild
        doNetopDatabase
        ;;
    $COMPOSE_MQ)
        doPreBuild
        doNetopMq
        ;;
    $COMPOSE_WEB)
        doPreBuild
        doNetopWeb
        ;;
    $COMPOSE_PORTAL)
        doPreBuild
        doPortalWorker
        ;;
    $COMPOSE_NAS)
        doPreBuild
        doNasWorker
        ;;
    $COMPOSE_PERMISSIONS)
        doPreBuild
        doPermissionsWorker
        ;;
    all)
        doPreBuild
        doNetopCache
        doNetopDatabase
        doNetopMq
        doNasWorker
        doPortalWorker
        doPermissionsWorker
        doNetopWeb
        doShowSuccessFinal
        ;;
    *)
        echo "Unknown option to build";
        exit 1;
esac
