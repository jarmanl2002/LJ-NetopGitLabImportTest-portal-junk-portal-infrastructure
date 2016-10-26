## Development environment setup  
<br>
<br>
<br>
#### Dependencies
* docker
* docker compose
* node.js - used for build of the frontend apps
<br><br>
* Usage
<br>
`mkdir netop`
`git clone git@git.netop.com:portal/portal-infrastructure.git`  
`cd portal-infrastructure`
`git checkout compose2`
`./install.sh` - this will clone all the portal services and setup the convif with the dev environment variables
`docker-compose up` - will install launch the containers and install the npm modules for all workers

<br>
<br>
* You can use docker compose to view logs, restart, rebuild containers and more
* For a detailed documentation please visit https://docs.docker.com/compose/reference/overview/
<br><br>

* edit your hosts file & add the following lines (replacing the IP with your docker-ip - <param2> for the install.sh) :  
`<docker interface ip on mac> or <127.0.0.1 on linux>	portal-local.netop.com nas-local.netop.com`
* navigate to http://portal-local.netop.com
* login using:  
user:`admin@netop.com`  
pass:`123456`
