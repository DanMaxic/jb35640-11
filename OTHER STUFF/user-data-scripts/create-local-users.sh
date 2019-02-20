
sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config
systemctl restart sshd

SSH_USERNAME="meme"
SSH_PSSWORD="Letitbe123!"
groupadd remote_users
echo "remote_users    ALL=(ALL)    NOPASSWD:ALL" >> /etc/sudoers
echo "${SSH_USERNAME}    ALL=(ALL)    NOPASSWD:ALL" >> /etc/sudoers
useradd ${SSH_USERNAME} -G remote_users
echo "${SSH_PSSWORD}" | sudo passwd ${SSH_USERNAME} --stdin
