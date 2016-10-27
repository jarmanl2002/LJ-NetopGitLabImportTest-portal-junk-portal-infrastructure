cd /;
sh /tools/wait-for-it.sh -t 0 netop-permissions:3003;
cd /netop-worker/files;
echo "START INSTALL NAS MODULES";
/usr/local/bin/npm install;
npm run postinstall;
echo "DONE INSTALLING NAS MODULES";
sh /netop-worker/startMonit.sh;
