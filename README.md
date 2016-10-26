## Development environment setup  
<br>
<br>
<br>
#### Dependencies
* docker
* docker compose
* node.js - used for build of the frontend apps
### Usage
`mkdir netop`
* clone portal-infrastructure project  
`git clone git@git.netop.com:portal/portal-infrastructure.git`  
`cd portal-infrastructure`
`git checkout compose2`
<br><br>

* run `./install.sh` - this will clone all the portal services and setup the convif with the dev environment variables
* wait a while
<br>
<br>
* when finished , run the docker-compose command :
`docker-compose up`
* You can use docker compose to view logs, restart, rebuild containers and more
* For a detailed documentation please visit https://docs.docker.com/compose/reference/overview/
<br><br>


* edit your hosts file & add the following lines (replacing the IP with your docker-ip - <param2> for the install.sh) :  
`<docker interface ip on mac> or <127.0.0.1 on linux>	portal-local.netop.com nas-local.netop.com`
* navigate to http://portal-local.netop.com
* login using:  
user:`admin@netop.com`  
pass:`123456`
* if you need to run a command inside a docker use following command:
`docker exec -it (<dockerid>|<docker-name>) bash`
* for each project it will create 3 distinct folders:
    * config
        * it will contain a special file app.env in which are defined env variables needed for the process to run
        * the format for defining a new variable is : `export <variable_name>="<variable_value>"`
        * a special variable in this file is "NODEJS_FILETOSTART" which by default it has the following value: "server.js"
            * if there is another file from which the process must start you will override here the value of this variable with the relative path of the file to the project root
    * logs
        * it will contain 2 files: error.log and output.log
        * each will contain messages from stderr or stdoud from the running process
    * project
        * it will contain all the project files and dependent modules
        * all the changes regarding the behaviour of the process are made here, ex:
            * change a file
            * switch another branch
<br />
<br />
