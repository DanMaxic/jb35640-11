#!/bin/bash

function install_tomcat(){
  yum install -y tomcat-*
  systemctl enable tomcat
  systemctl start tomcat
}

function main(){
  install_tomcat
}

main