INSTALL_DIR="$(pwd)/workspace"
mkdir workspace;
echo $INSTALL_DIR;

#!/bin/bash
echo "Login to netop docker registry using domain credentials:"
docker login git.netop.com:4545 || exit 1;

# variables for install setup


tput setaf 2;
echo "STEP 1/6: setup env conf "
tput setaf 9;
#making the workspace dirs
mkdir -p "$INSTALL_DIR"/{portal,nas,weblogs,permissions};
mkdir -p "$INSTALL_DIR"/portal/{logs,config/env};
mkdir -p "$INSTALL_DIR"/nas/{logs,config/env};
mkdir -p "$INSTALL_DIR"/permissions/{logs,config};

#copy conf file to workspace
cp confs/portal/app.env "$INSTALL_DIR"/portal/config/
cp confs/portal/{apikeys.json,env-config.json,production.js} "$INSTALL_DIR"/portal/config/env/
cp confs/nas/app.env "$INSTALL_DIR"/nas/config/
cp confs/nas/{env-config.js,production.js} "$INSTALL_DIR"/nas/config/env/
cp confs/permission/app.env "$INSTALL_DIR"/permissions/config/

tput setaf 2;
echo "STEP 1/6: DONE"
tput setaf 9;

#clone git projects
tput setaf 2;
echo "STEP 2/6: Clone and build portal frontend"
tput setaf 9;
git clone git@git.netop.com:portal/netop-portal-frontend.git "$INSTALL_DIR"/portal-frontend;
cd "$INSTALL_DIR"/portal-frontend;
git checkout develop;
npm install && npm run build;
tput setaf 2;
echo "STEP 2/6: DONE"
tput setaf 9;


tput setaf 2;
echo "STEP 3/6: Clone and build nas frontend"
tput setaf 9;
git clone git@git.netop.com:portal/netop-nas-frontend.git "$INSTALL_DIR"/nas-frontend;
cd "$INSTALL_DIR"/nas-frontend;
git checkout develop;
npm install && npm run build;
tput setaf 2;
echo "STEP 3/6: DONE"
tput setaf 9;


tput setaf 2;
echo "STEP 4/6: Clone portal"
tput setaf 9;
git clone git@git.netop.com:portal/netop-portal-server.git "$INSTALL_DIR"/portal/project;
cd "$INSTALL_DIR"/portal/project;
git checkout develop;
tput setaf 2;
echo "STEP 4/6: DONE"
tput setaf 9;

tput setaf 2;
echo "STEP 5/6: Clone nas"
tput setaf 9;
git clone git@git.netop.com:portal/netop-nas.git "$INSTALL_DIR"/nas/project;
cd "$INSTALL_DIR"/nas/project;
git checkout develop;
tput setaf 2;
echo "STEP 5/6: DONE"
tput setaf 9;

tput setaf 2;
echo "STEP 6/6: Clone permissions"
tput setaf 9;
git clone git@git.netop.com:portal/netop-permissions.git "$INSTALL_DIR"/permissions/project;
cd "$INSTALL_DIR"/permissions/project;
git checkout develop;
tput setaf 2;
echo "STEP 6/6: DONE"
tput setaf 9;


tput setaf 2;
echo "DONE! Your environment has been cloned in the workspace folder."
echo "Please make sure that you edited the hosts file by adding the following line"
echo "<Your docker machine ip> or <127.0.0.1 on linux> nas-local.netop.com portal-local.netop.com";
echo "Now you can run docker-compose up"
echo "You can use docker compose to view logs, restart, rebuild containers and more"
echo "For a detailed documentation please visit https://docs.docker.com/compose/reference/overview/"
