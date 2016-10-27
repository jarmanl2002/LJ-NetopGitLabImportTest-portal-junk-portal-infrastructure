cd /;
sh /tools/wait-for-it.sh -t 0 netop-nas:8084;
cd /netop-worker/files;
echo "START INSTALL PORTAL MODULES";
/usr/local/bin/npm install;
npm run postinstall;
echo "DONE PORTAL PERMISSIONS MODULES - NETOP-PORTAL IS READY";
sh /netop-worker/startMonit.sh;
