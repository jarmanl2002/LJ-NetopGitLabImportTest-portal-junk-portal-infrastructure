## Development environment setup  
<br>
<br>
<br>
#### Valid for commit `cd193c21cc033d919f38f9931d1a5f2303f2ee6f` in project Portal/portal-infrastructure
* you must have nodejs installed on the local machine, because it will be needed to build the frontend projects
* you must have the apropiate ssh key in place for accessing git and `.npmrc` file in the home folder of the user under which the installer will be run
* the installer will clone the required projects and it will setup permissions for the files for the user under which it is running
* create a folder which will contain the projects  
`mkdir netop`
* clone portal-infrastructure project  
`git clone git@git.netop.com:portal/portal-infrastructure.git`  
`cd portal-infrastructure`

* save & run `./install.sh <param1> <param2>`
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