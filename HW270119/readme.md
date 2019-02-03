#JB36540-11 HW: 270219
### TAGS:
\#jenkins \#jenkinspipeline
# Tasks:
given following jenkins file definition, you need to perform the following tasks:
* Merge following stages of our Jenkins pipeline: 
  1. Dockerfile creation
  2. Docker build
* Create following stages:
  1. Create K8s depoyment (yaml with external service)
  3. "Ansible deployment"
* **a bonus**:
  1. under "Jenkins pipelines" directory, you will find some files starting with "Jenkinsfile*":
      1. what they does? describe in psudu code (may in hebrew)
      2. what the diffrences between the syntax?
      
  
**Important notes:** 
* Please use comments explaining your choice, comments are made with '//' chars on the beginning of the line.
* please note, you may find 3 types of syntaxes used, ask yourself, why? and when you will use them.  

**resources to use:**
1. [Jenkins pipeline book link](https://jenkins.io/doc/book/pipeline/)
2. [Jenkins pipeline syntax](https://jenkins.io/doc/book/pipeline/syntax/)
3. [jenkins declerative workflow syntax link](https://jenkins.io/doc/pipeline/steps/workflow-basic-steps)


```
node{
  
  def mvnHome
  stage('Preparation') {
      // Get some code from a GitHub repository
      git 'https://github.com/zivkashtan/course.git';
      // Get the Maven tool.
      mvnHome = tool 'M3'
   }
  
 stage('Package') {
      // Run the maven package
      echo sh (returnStdout: true, script: "'${mvnHome}/bin/mvn' package")
   }
  
  stage('Creating Dockerfile') {
       //Create the Dockerfile in the workdir
       echo sh (returnStdout: true, script: "echo 'FROM tomcat:8.0.20-jre8' > Dockerfile")
       echo sh (returnStdout: true, script: "echo 'COPY ./web/target/time-tracker-web-0.3.1.war /usr/local/tomcat/webapps/' >> Dockerfile")
   }
  
  stage('Docker build image') {
       echo sh (returnStdout: true, script: "docker build -t <YOUR_DOCKERHUB_USERNAME>/time-tracker .")
   }
 
 }

```