node('master'){
def mvnHome  
mvnHome= tool 'M3'
def app
app = "ulivara/time-tracker${BUILD_ID}"  

stage ('Fetch Repo')    {
       git 'https://github.com/Yuliva/time-tracker'
    
     }
     
stage ('Package')     {
    //Run Maven Packager
    sh(returnStdout: true, script: "'${mvnHome}/bin/mvn' package")
 
 }

stage('Docker Create and Build')    {
    
       
    writeFile(file: "Dockerfile", text: """
    FROM tomcat:8.0.20-jre8
    COPY ./web/target/*.war /usr/local/tomcat/webapps/
    """);
  sh (returnStdout: true, script: "docker build -t ${app} .")
    }

stage('Pass variable and run Ansible deployment')   {

    echo sh (returnStdout: true, script: "ansible-playbook site.yaml -i '127.0.0.1,' --extra-vars \"appname=${app}:latest\"")    
    }
}
