## Development environment setup  
<br>
<br>
<br>
#### Valid for commit `cd193c21cc033d919f38f9931d1a5f2303f2ee6f` in project Portal/portal-infrastructure
* you must have installed docker support
* you must stop any services that are listening on the following ports:
    * 80, 443 (usually nginx or apache)
    * 3306 (usualy mysql)
    * 5671 5672 25672 4369 (usually rabbitmq)
    * 6379 (usually redis)
    * 8083 and 8084 (those two are required for portal and nas http servers)
* you must have nodejs installed on the local machine, because it will be needed to build the frontend projects
* you must have the apropiate ssh key in place for accessing git and `.npmrc` file in the home folder of the user under which the installer will be run
* the installer will clone the required projects and it will setup permissions for the files for the user under which it is running
* create a folder which will contain the projects  
`mkdir netop`
* clone portal-infrastructure project  
`git clone git@git.netop.com:portal/portal-infrastructure.git`  
`cd portal-infrastructure`

* run `./install.sh <param1> <param2>`
    * <param1> is full path to folder created earlier (mkdir netop)
    * <param2> is the ip of the docker engine interface (on linux it is usually `docker0` interface)
* wait a while
* when finished , start the containers in this order :
`docker start netop-portal`
`docker start netop-nas`
`docker start netop-permissions`
* edit your hosts file & add the following lines (replacing the IP with your docker-ip - <param2> for the install.sh) :  
`<docker interface ip>	portal-local.netop.com nas-local.netop.com`
* navigate to http://portal-local.netop.com
* login using:  
user:`admin@netop.com`  
pass:`123456`
* if you need to run a command inside a docker use following command:
`docker exec -it (<dockerid>|<docker-name>) /usr/local/bin/su-exec "$(id -un)"  /bin/bash`
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
## IMPORTANT NOTE:
when you make a change in any of the following projects: netop-portal, netop-nas or netop-permissions you must manually restart the coresponding container so that the changes take effect 