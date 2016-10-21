## Development environment setup  
<br>
<br>
<br>
#### Valid for commit `d0201d24229e07de36d26b5739afa4c51eebec26` in project Portal/portal-infrastructure
*  create a folder to hold the project  
`mkdir netop`
* clone portal-infrastructure project  
`git clone git@git.netop.com:portal/portal-infrastructure.git`  
`cd portal-infrastructure`
* edit install.sh and replace `INSTALL_DIR="/Users/raduluncasu/_Projects/netop";` with your own path
  * if you are on Mac you will also need to add an empty extension param to all `sed -i` commands, like this  
    `sed -i "s/host: 'localhost',/host: '$DOCKER_IP',/" "$SED_FILE"` =>  
    `sed -i "" "s/host: 'localhost',/host: '$DOCKER_IP',/" "$SED_FILE"`
* save & run `./install.sh`
* wait a while
* when finished , start the containers in this order :  
`docker start netop-permissions`  
`docker start netop-nas`  
`docker start netop-portal`  
* edit your hosts file & add the following lines (replacing the IP with your docker-ip) :  
`192.168.99.100	portal-local.netop.com nas-local.netop.com`
* navigate to http://portal-local.netop.com
* login using:  
user:`admin@netop.com`  
pass:`123456`