#!/bin/bash

##PARAMS
JENKINS_REPO_URI="jenkins-2.150.2-1.1"
NEXUS_REPO_URI="https://sonatype-download.global.ssl.fastly.net/nexus/3/nexus-3.0.2-02-unix.tar.gz"
REMOTE_SSH_PORT="9090"
SSH_USERNAME="meme"
SSH_PSSWORD="Letitbe123!"
## END PARAMS

function installPreReq(){
    echo "±±±±±±±±±±±±±>installPreReq"


    wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
    sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
    yum install -y apache-maven
    yum update -y && yum install -y yum-utils git jq aws-cli docker bind-utils nano apache-maven java
}

function installKubectl(){
  cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
  yum install -y kubectl

}

function installDocker(){
  yum install -y docker
  systemctl enable docker
  systemctl start docker
}

function installJenkins(){
  echo "±±±±±±±±±±±±±>install jenkins"
  yum install -y https://prodjenkinsreleases.blob.core.windows.net/redhat-stable/${JENKINS_REPO_URI}.noarch.rpm java
  systemctl enable jenkins
  systemctl start jenkins

}

function installAnsible(){
  yum install ansible
}

function installMaven(){
  sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
  sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
  sudo yum install -y apache-maven
  mvn --version
}

function installNexusArtifactory(){
  mkdir /app && cd /app
  wget $NEXUS_REPO_URI
  tar -xvf nexus-*.tar.gz
  rm -f nexus-*.tar.gz
  mv nexus-* nexus
  adduser nexus
  chown -R nexus:nexus /app/nexus
  echo -e "\nrun_as_user=\"nexus\"" >> /app/nexus/bin/nexus.rc
  cat << EOF > /etc/ecs/ecs.config
-Xms1200M
-Xmx1200M
-XX:+UnlockDiagnosticVMOptions
-XX:+UnsyncloadClass
-Djava.net.preferIPv4Stack=truer
-Dkaraf.home=.
-Dkaraf.base=.
-Dkaraf.etc=etc
-Djava.util.logging.config.file=etc/java.util.logging.properties
-Dkaraf.data=/nexus/nexus-data
-Djava.io.tmpdir=data/tmp
-Dkaraf.startLocalConsole=false
EOF
  sudo ln -s /app/nexus/bin/nexus /etc/init.d/nexus
  chkconfig --add nexus
  chkconfig --levels 345 nexus on
  systemctl enable nexus
  systemctl start nexus
}

function installWetty(){
  yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  yum groupinstall "Development Tools" -y
  sudo yum install -y nodejs npm --enablerepo=epel
  npm install wetty -g
  groupadd wetty_users
  useradd wetty -G wetty_users
  cat << EOF > /etc/systemd/system/wetty.service
[Unit]
Description=wetty remote ssh web
After=network.target

[Service]
ExecStart=/usr/bin/node /usr/lib/node_modules/wetty/bin/wetty.js -p ${REMOTE_SSH_PORT}
#WorkingDirectory=/opt/nodeserver
Restart=always
 RestartSec=10
 # Output to syslog
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=nodejs-example
User=wetty
Group=wetty_users

[Install]
WantedBy=multi-user.target
EOF
  sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  systemctl restart sshd
  systemctl enable wetty.service
  systemctl start wetty.service
}

function configureLogins(){

    groupadd remote_users
    echo "remote_users    ALL=(ALL)    NOPASSWD:ALL" >> /etc/sudoers
    echo "${SSH_USERNAME}    ALL=(ALL)    NOPASSWD:ALL" >> /etc/sudoers
    useradd ${SSH_USERNAME} -G remote_users
    echo "${SSH_PSSWORD}" | sudo passwd ${SSH_USERNAME} --stdin

}


function main(){
  installPreReq
  installMaven
  installAnsible

  installDocker
  installJenkins
  installWetty
  installNexusArtifactory
  configureLogins
}
main
