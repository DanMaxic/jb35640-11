#**Task #2: CI 101 -manual CI**
##content table
* Task #2: CI 101 -manual CI
  * Task review
  * Task inro
  * How to solve the task
    * Step 1: preppier the CI basic script
    * Step 2: Basic ci operations in java environment
    * Step 3: refactoring the ci script, part I: adjust the ci script to other java projects
    * Step 4: write down the ci script, and test that
    * Step 5: refactoring the ci script, part II: adjust the ci script to other programing languages and tools
  * sub tasks
    * 2.1: - maven build
    * 2.2: - .NET build
    * 2.3: - NPM based build
    * 2.4: - GO build
    * 2.5: - you may skip that, makefile (this is a bonus)
    
  
##Task review
- Sub-task 2.1: **maven based build** 
  - desc: we will perform step by step a maven build (for java\scala applications)
  - please see task2-1.md
  - the output will be a bash script, **mvn-build.sh**
- Sub-task 2.2: **MSbuild based build**
  - desc: we will perform step by step a MSbuild build (for .NET applications)
  - please see task2-2.md
  - the output will be a bash script, **msbuild-build.bat**
- Sub-task 2.3: **NPM based build**
  - desc: we will perform step by step a node build (for node.js applications)
  - please see task2-5.md
  - the output will be a bash script, **npm-build.sh**
- Sub-task 2.4: **GO based build**
  - desc: we will perform step by step a node build (for node.js applications)
  - please see task2-4.md
  - the output will be a bash script, **golang-build.sh**
- Sub-task 2.5: **make based build**
  - desc: we will get familer with the make\makefile build framework
  - please see task2-5.md
  - the output will be a bash script, **Makefile**
##SUB TASKS:
### sub-task 2.1-2.4:
look on the following table, for each language (subtask), you need to produce a CI script end-to-end (from pulling until loading to nexus).

**BUT**, here is the catch, so **read carefully** the **whole** page!
* in each and every of the sub tasks, add the following variables:
  * **ARTIFACT_VERSION** variable will determine the version of the artifact
    * please pay attention to the following:
      * the variable will not only set the value of the artifact when publishing the artifact to the artifact repository,
      * **BUT** also the binary's version (remember that we perform a dive inside the pom.xml file?)
    * to help you:
      * determine the build framework config file that relevant to build framework used
      * consider adding to the CI script you have created new method **preBuildConfig**.

  | sub task      | programing language | github repo  | Score  |
  | ------------- |:------------- |:-----| -----:|
  | 2.1 | java\scala | https://github.com/zivkashtan/course.git | 9% |
  | 2.2 | .NET (C#)  | https://github.com/NeelBhatt/SampleCliApp | 9% |
  | 2.3 | node.JS| https://github.com/assertible/nodejs-example | 9% |
  | 2.4 | GoLang| https://github.com/CircleCI-Public/circleci-demo-go.git | 9% |

### sub-task 2.5:
 -- skip for now


##Task inro
On our last lesson we reviewed the basics of the CI proccess, let's perform a short recup:
* a simple CI cycle is the process of pulling a source code, and transform it into usefull artifact, and than upload it into an **Artifact Repository**.
* the steps are usually are:
  * pull the requested source code from a SCM system (such as git, SVN, TSF and others)
  * performing a **BUILD** process using the appropriate **Build Framework utility**
    * just remeber that we might perform here extra tasks rather than just compile. for several program languages we just might perform some bundling.
  * examine the outcome artifact, could be one or more of the following:
    * run test unit
    * scan the dependencies for outdated ones or security vulnerabilities
    * pull a code coverage tests
  * publish the outcome artifacts into an Artifact repository
  
On each and every sub task, we will walk throw the CI process of each specific language, and than you will have to adjust the CI script to suite the task given earlier.
##How to solve the task:
###Step 1: preppier the CI basic script:
since the CI process is built of basic 3 steps (Source code pull, the build ans the publish), we may imagine an pseudo script like following:
```bash
#!/bin/bash
#this is a simple CI script

function main(){
  sourceCodePull
  build
  artifactPublishing
}
main
```

Let's add the methods
```bash
#!/bin/bash
#this is a simple CI script

function sourceCodePull(){  
  #some code
  echo "here is your code"
}

function build(){  
  #some code
  echo "here is your code"
}

function artifactPublishing(){  
  #some code
  echo "here is your code"
}

function main(){
  sourceCodePull
  build
  artifactPublishing
}
main
```
After doing so, let's continue

###Step 2: Basic ci operations in java environment

As you may recall, we saw the following:
* To pull the source code we excecuted the following:
```bash
git clone https://github.com/zivkashtan/course.git
``` 
* To perform build, we executed the following: 
```bash
cd course/
sed -i "s/<java.version>.*<\/java.version>/<java.version>1.7<\/java.version>/" pom.xml
mvn package
``` 

* to push the artifact to the artifact repository, we executed the following: 
```bash
mvn deploy:deploy-file \
  -DgroupId=clinic.programming.time-tracker \
  -DartifactId=time-tracker-parent \
  -Dversion=0.3.1 \
  -Dpackaging=pom \
  -Dfile=output/timetracker.war \
  -Durl=https://localhost:8081/repository/maven-snapshots/
``` 

###Step 3: refactoring the ci script, part I: adjust the ci script to other java projects
we may notice that when we want to adjust the script to other java projects, we need to modify only the following:
* the only changes needed are:
  * on the **sourceCodePull** function: 
    * the **git source code uri**
  * on the **build** function: 
    * build action (here we used **package**)
  * on the **artifactPublishing** function:
    * all artifact's attributes, to load to artifact repository
    
so, we may solve that, we may use variables in our bash script
####variables declarations:
```bash
GIT_REPO_URI="https://github.com/zivkashtan/course.git"
MVN_ACTION="package"
ARTIFACT_GROUP_ID="clinic.programming.time-tracker"
ARTIFACT_ID="time-tracker-parent"
ARTIFACT_VERSION="0.3.1"
ARTIFACT_Dpackaging="pom"
ARTIFACT_file="output/timetracker.war"
NEXUS_REPO_URL="https://localhost:8081/repository/maven-snapshots"
```
####variable usage example:
here an example of the variable usage:
```bash
git clone ${GIT_REPO_URI}
```
```bash
mvn ${MVN_ACTION}
```
###Step 4: write down the ci script, and test that
you may test the CI script you wrote, against other java projects:

here are some git repos to review:
* [https://github.com/spring-projects/spring-boot/tree/master/spring-boot-samples](https://github.com/spring-projects/spring-boot.git)
  * git URI: https://github.com/spring-projects/spring-boot.git
  * the practice project are located at **spring-boot-samples** folder, each folder has it's own project
* [https://github.com/google/guava](https://github.com/google/guava.git)
  * git URI: https://github.com/google/guava.git
  * that project if stand by itself.
###Step 5: refactoring the ci script, part II: adjust the ci script to other programing languages and tools:
Now, after adjusting the ci script to other java based projects, and verified that it working properly, we want to make it more generic.

Generic ci build script, meaning that the CI script will not only serve java based projects, but also other programing languages, and other SCM systems.

Let's see the scopes in the script, that we might need to change in order to made the CI script [agnostic](https://whatis.techtarget.com/definition/agnostic), not only for the java projects, but also for other programing languages (and **build frameworks**) and **SCM** system:   
  * on the **sourceCodePull** function: 
    * the **SCM** utility name (remember, we used "_**git clone ${GIT_REPO_URI}**_" command earlier): 
      * for GIT , **git** utility will used
      * for TFS, **tf** utility will used
      * for SVN, **svn** utility will be used
      * let's call that variable "**SCM_TOOL**" 
    * the **SCM method** :
      * for GIT, "_**git clone** ${some uri}_" command will used, so the SCM method will be "**clone**"
      * for TFS, "_**tf get /force /noprompt** ${some uri}_" command will used, so the SCM method will be "**get**"
      * for SVN, "_**svn checkout** ${some uri}_" command will used, so the SCM method will be "**checkout**"
      * let's call that variable "**SCM_METHOD**" 
    * the **SCM REPO URI** :
      * we may notice that the **GIT_REPO_URI** variable's name that we defined in step #3, is not relevant any more, so let's refactor that to be "**SCM_REPO_URI**"
    * so the content of the method will be similar to this: "_**${SCM_TOOL} ${SCM_METHOD} ${SCM_REPO_URI}**_"
      * think, how we may execute the command? what are the options? check & try...
  * on the **build** function: 
    * the **BUILD TOOL** utility name (remember, we used "_**mvn package**_" command earlier): 
      * for JAVA\SCALA ,we will use  **mvn** utility
      * for .NET, **msbuild** or **dotnet** utility
      * for node.js, **npm** utility will be used
      * for go, **go**  utility will be used
      * let's call that variable "**BUILD_TOOL**" 
    * the **BUILD method** :
      * for JAVA\SCALA ,we will use  **mvn** command will used, so the SCM method will be "**clone**"
      * for .NET, we will use **dotnet build** command will used, so the SCM method will be "**build**"
      * for node.js,,we will use **npm package** command will used, so the SCM method will be "**package**"
      * for go, we will use  **go build**  command will used, so the SCM method will be "**build**"
      * let's call that variable "**PUBLISH_TOOL_METHOD**"
      * considering that sometimes we will need some extra args, let's call that variable "**BUILD_TOOL_ARGS**" 
  * on the **artifactPublishing** function:
    * the **PUBLISH TOOL** utility name (remember, we used "_**mvn deploy**_" command earlier): 
      * for JAVA\SCALA ,we will use  **mvn** utility
      * for .NET, **msbuild** or **dotnet** utility
      * for node.js, **npm** utility will be used
      * for go, **go**  utility will be used
      * let's call that variable "**PUBLISH_TOOL**" 
    * the **PUBLISH_ARGS** :
      * for JAVA\SCALA ,we will use  **mvn deploy** command will used, so the SCM method will be "**deploy**"
      * for .NET, we will use **dotnet nuget push** command will used, so the SCM method will be "**nuget push**"
      * for node.js,,we will use **npm publish** command will used, so the SCM method will be "**publish**"
      * let's call that variable "**PUBLISH_TOOL_METHOD**"
      * considering that sometimes we will need some extra args, let's call that variable "**PUBLISH_TOOL_ARGS**" 
    * the **ARTIFACT ATTRIBUTES** :
      * considering that sometimes we will need some extra args, let's call that variable "**ARTIFACT_ATTR**" 
    * the **ARTIFACT REPO URI** :
          * let's set the artifact's repo URI as "**ARTIFACT_REPO_URI**" 
    * **IMPORTANT TIP**:
      * you may load an **artifact** to the artifact repo using the "_**curl**_" utility.
      * here an example:
```bash
# LOAD ARTIFACT INTO NEXUS
curl -v \
  -F r=yourrepo \
  -F hasPom=false \
  -F e=jar \
  -F g=yourgroup \
  -F a=yourartifact \
  -F v=yourversion \
  -F c=yourclassifier \
  -F p=jar \
  -F file=@./your-jar-file-1.0.jar \
  -u admin:admin123 \
  http://192.168.99.100:32768/service/local/artifact/maven/content
```
      
so, we may solve that, we may use variables in our bash script
####variables declarations:
```bash
# PARAMS
### SCM CONFIGS
SCM_TOOL=""
SCM_METHOD=""
SCM_REPO_URI=""
### BUILD CONFIGS 
BUILD_TOOL=""
BUILD_TOOL_METHOD=""
BUILD_TOOL_ARGS=""
### PUBLISH CONFIGS
PUBLISH_TOOL=""
PUBLISH_TOOL_METHOD=""
PUBLISH_TOOL_ARGS=""
### ARTIFACT ATTRS
ARTIFACT_GROUP_ID="clinic.programming.time-tracker"
ARTIFACT_ID="time-tracker-parent"
ARTIFACT_VERSION="0.3.1"
ARTIFACT_Dpackaging="pom"
ARTIFACT_file="output/timetracker.war"
```

####variables declarations (java example):
```bash
# PARAMS
### ARTIFACT ATTRS
ARTIFACT_GROUP_ID="clinic.programming.time-tracker"
ARTIFACT_ID="time-tracker-parent"
ARTIFACT_VERSION="0.3.1"
ARTIFACT_PACKAGING="pom"
ARTIFACT_file="output/timetracker.war"
ARTIFACT_TYPE="jar"

ARTIFACT_REPO_SERVER="localhost:8081"
ARTIFACT_REPO_URI="http://${ARTIFACT_REPO_SERVER}/service/local/artifact/maven/content"
ARTIFACT_REPO_USERNAME="admin"
ARTIFACT_REPO_PASSWORD="admin123"

### SCM CONFIGS
SCM_TOOL="git"
SCM_METHOD="pull"
SCM_REPO_URI="https://github.com/zivkashtan/course.git"
### BUILD CONFIGS 
BUILD_TOOL="mvn"
BUILD_TOOL_METHOD="package"
BUILD_TOOL_ARGS=""
### PUBLISH CONFIGS
PUBLISH_TOOL="curl"
PUBLISH_TOOL_METHOD="-v"
PUBLISH_TOOL_ARGS="-F hasPom=false"


# OTHER VARIABLES
BUILD_OUTPUT_FILE="your-jar-file-1.0.jar"
##INTERNAL VARS
SCM_TOOL_COMMAND="${SCM_TOOL} ${SCM_REPO_URI} ${BUILD_TOOL_ARGS}"
BUILD_TOOL_COMMAND="${BUILD_TOOL} ${BUILD_TOOL_METHOD} "
PUBLISH_TOOL_COMMAND="${PUBLISH_TOOL} ${PUBLISH_TOOL_METHOD} -F r=${SCM_REPO_URI}  -F e=${ARTIFACT_TYPE} -F g=${ARTIFACT_GROUP_ID} -F a=${ARTIFACT_ID} -F v=${ARTIFACT_VERSION}  -F p=${ARTIFACT_TYPE} -F file=@./${BUILD_OUTPUT_FILE} -u ${ARTIFACT_REPO_USERNAME}:${ARTIFACT_REPO_PASSWORD} ${ARTIFACT_REPO_URI}"

```


###Step 6: write down the new ci script, and test that using the sub tasks tasks:
good luck
###Step 7: preppier the CI environment (build tools and other stuff)
####SCM client tools: 
#####GIT (and GitHub)
* git util
```bash
yum update -y && yum install -y git
```
* code example for cloning a code repo
```bash
GIT_REPO_URI="https://github.com/zivkashtan/course.git"
git clone ${GIT_REPO_URI}
```
#####TFS
* TFS (and visualstudio.com\AZURE devops):
* download the TFS everywhere 
  * direct link: [TEE-CLC-14.134.0.zip](https://github.com/Microsoft/team-explorer-everywhere/releases/download/14.134.0/TEE-CLC-14.134.0.zip)
  * git repo:  https://github.com/Microsoft/team-explorer-everywhere
  * extract the file
  * in linux grant execute permissions
  * execute the tool
* code example for cloning a code repo
```bash
TFS_COLLECTION=""
TFS_USER="user"
TFS_PASS="password"
tf workspace /new citest /noprompt /collection:${TFS_COLLECTION} /login:${TFS_USER},${TFS_PASS}
tf workfold "$/" . /map /workspace:citest /collection:${TFS_COLLECTION} /login:${TFS_USER},${TFS_PASS}
tf get \$/ /overwrite /recursive /force /noprompt /login:${TFS_USER},${TFS_PASS}
```
#####SVN
* Installing tool:
```bash
yum update -y && yum install subversion -y
```
* code example for cloning a code repo
```bash
SVN_REPO_URI="https://svn.eionet.europa.eu/repositories/airquality/"
svn checkout ${SVN_REPO_URI}
```

#### Build client tools: 
#####MAVEN
* Installation
```bash
sudo yum update -y && sudo yum install java -y
sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
mvn --version
```
* run build
```bash
mvn package
```
* run to publish to CI server
```bash

```
more info:
* **READ THAT**: https://mincong-h.github.io/2018/08/04/maven-deploy-artifacts-to-nexus/
* **READ THAT**: https://maven.apache.org/guides/mini/guide-3rd-party-jars-remote.html

#####.NET (dotnet)
* Installation
```bash
sudo rpm -Uvh https://packages.microsoft.com/config/rhel/7/packages-microsoft-prod.rpm
sudo yum update -y && sudo yum install dotnet-sdk-2.2 -y
```
* run build
```bash
dotnet build --configuration Release
dotnet pack --no-build --output nupkgs
```
* run publish to artifact server
```bash
dotnet nuget push **\\nupkgs\\*.nupkg -k yourApiKey -s http://myserver/artifactory/api/nuget/nuget-internal-stable/com/sampledotnet nuget push LinqExtensions.1.0.0.nupkg -k a0fdd1a1-af65-3ac9-ab28-c0b1bfadc82a -s http://localhost:9876/repository/nuget-hosted/
NEXUS_API_KEY=""
NEXUS_REPO_SERVER="localhost:8081"
NEXUS_REPO_URI="http://${NEXUS_REPO_SERVER}/repository/nuget-hosted/"
dotnet nuget push LinqExtensions.1.0.0.nupkg -k ${NEXUS_API_KEY} -s ${NEXUS_REPO_URI}
```
more info:
* **READ THAT**: https://arghya.xyz/articles/nexus-artifact-repository-for-dotnet/
* **READ THAT**: https://neelbhatt.com/2018/06/17/guide-to-create-and-run-net-core-application-using-cli-tools-net-core-cli-part-i/


#####NODE.JS (npm)
* Installation
```bash
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum groupinstall "Development Tools" -y
sudo yum install -y nodejs npm --enablerepo=epel
```
* run build
```bash
mvn package
```
* run publish to artifact server
```bash
# DONT FORGET TO ADD TO PACKAGE.json the publish config (publishConfig.registry)
npm publish
```
more info:
* **READ THAT**: https://blog.sonatype.com/using-nexus-3-as-your-repository-part-2-npm-packages


#####GoLang (go)
* Installation
```bash
wget https://dl.google.com/go/go1.11.5.linux-amd64.tar.gz
tar -C /usr/local -xzf go*.tar.gz
echo -e "\nexport PATH=$PATH:/usr/local/go/bin" >> /etc/profile
```
* run build
```bash
go build
```


