cd /;
sh /tools/wait-for-it.sh -t 0 messagebus:5672;
sh /tools/wait-for-it.sh -t 0 cache:6379;
cd /netop-worker/files;
echo "START INSTALL PERMISSIONS MODULES";
/usr/local/bin/npm install;
echo "DONE INSTALLING PERMISSIONS MODULES";
sh /netop-worker/startMonit.sh;
