export TERM=xterm;
cd /root;
su root;
rabbitmq-server start -detached;
./test.sh;
./doQueues.sh;
tail -f /etc/hosts
