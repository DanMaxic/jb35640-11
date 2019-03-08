#!/bin/bash

function enable_ssh() {
  sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
  sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
  service sshd restart
}


function main() {
  yum -y install net-tools
  enable_ssh
}

main