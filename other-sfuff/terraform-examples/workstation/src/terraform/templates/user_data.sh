#!/bin/bash

MACHINE_TIME_ZONE="${TERRAFORM_TEPLATE_MACHINE_TIME_ZONE}"
ECS_CLUSTER_NAME="${TERRAFORM_TEPLATE_ECS_CLUSTER_NAME}"
ECS_LOGGING_DRIVERS='${TERRAFORM_TEPLATE_ECS_LOGGING_DRIVERS}'
ECS_CLOUDWATCH_LOG_GROUP="${TERRAFORM_TEPLATE_ECS_CLOUDWATCH_LOG_GROUP}"
EFS_MOUNT_TARGT="${TERRAFORM_TEPLATE_DIR_TRGT}"
EFS_FILE_SYSTEM_ID="${TERRAFORM_TEPLATE_ECS_EFS_FILE_SYSTEM_ID}"
DATADOG_AGENT_API_KEY="${TERRAFORM_TEPLATE_DATADOG_AGENT_API_KEY}"
# END PARAMS

# internal script variables
current_aws_region=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone | sed s'/.$//')
current_aws_availability_zone=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone)

function installPreReq(){
    echo "±±±±±±±±±±±±±>installPreReq"
    sudo yum update -y && yum install -y nfs-utils nano awslogs jq aws-cli ecs-init docker amazon-efs-utils bind-utils
}

function configureDhcpOptions(){
  metadata="http://169.254.169.254/latest/meta-data"
  mac=$(curl -s $metadata/network/interfaces/macs/ | head -n1 | tr -d '/')
  cidr_block=$(curl -s $metadata/network/interfaces/macs/$mac/vpc-ipv4-cidr-block/)
  dhcp_server=$(echo $cidr_block | sed -e 's/.0\/[0-9][0-9]/.2/g')
  echo $'\n'"supersede domain-name-servers $dhcp_server;"$'\n' | sudo tee -a /etc/dhcp/dhclient.conf
  echo $'\n'"nameserver $dhcp_server"$'\n' | sudo tee -a /etc/resolv.conf

}
function setTimeZone(){
    echo "±±±±±±±±±±±±±>setTimeZone"
    sudo unlink /etc/localtime
    ln -fs /usr/share/zoneinfo/$${MACHINE_TIME_ZONE} /etc/localtime
}

function mountEFS(){
    echo "±±±±±±±±±±±±±>mountS3FS"
    mkdir -p $EFS_MOUNT_TARGT
	cp -p /etc/fstab /etc/fstab.back-$(date +%F)
	sudo echo "$EFS_FILE_SYSTEM_ID:/ $EFS_MOUNT_TARGT efs tls,_netdev" >>/etc/fstab

    mount -a
}

function addLuminateCertAndConfigSSHD(){
    echo "±±±±±±±±±±±±±>addLuminateCertAndConfigSSHD"
    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzpAvurF7ZfhyosQcaa32p4GUP9zQCcQERQFAEAFOm//AvFtZT7GLKkXveUDPX2GtRBVz/nYEg4PnbVqF0OpsmKDGNgxjSF+Qj6qBnRrl+bOnBhQKUbZh3uwIjobmDerW9tSS0ZMRnuYinM6ofFLbOVpkENqo/kXhQXbNwci+sNGVSC9psDRXXYRzrThdS7Jflt8ytn1/cviDudlm5dYc2kHiMqrUUaP3D5I2z97HbyJDqAcFgWqEBvSXrXchCL0o84/KNWVPUVcCns33mqUpjt+v0/HjTaUaVQ2EZi2c1ouoymn7bpRhfYp6p5ln2xsTPWHYLqtznRRfXGHPsNELN ubuntu@ip-172-31-16-121' > LuminateSSHAccess.pub
    sudo chown root:root LuminateSSHAccess.pub
    sudo chmod 600 LuminateSSHAccess.pub
    sudo mv LuminateSSHAccess.pub /etc/ssh/
    echo $'\nTrustedUserCAKeys /etc/ssh/LuminateSSHAccess.pub\n' | sudo tee -a /etc/ssh/sshd_config
}

function addTraianaSSHKey(){
  sudo useradd traiana

cat << EOF > traiana
traiana ALL = NOPASSWD: ALL

# User rules for traiana'
traiana ALL=(ALL) NOPASSWD:ALL
EOF

  sudo chown root:root traiana
  sudo mv traiana /etc/sudoers.d/

  sudo mkdir -p /home/traiana/.ssh/
  echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8bPBKLou8BZBAjrFy3lXRQyrvWf5BBKCCi64HFDou4MKLyyTU7BSGICSMYkKsTmI4UnKeoyyP9fzSQyZlKVYpk+6TCPB/mriUg/xSKEG6krkZR3NHDnS0DZ7sl470JB/RO5Ryti82FPqzY9UXZMrfhkCFuXFfesOnMRYwqkfFN1gUMINZ+it2tYwlrsq+uaq7CCQ2ItjBirxOwR9jE9dlbHvXBKC0tw1FHwTKLyzJztVaXe6S296ib5ZmuktcSmAbsMwTGnIZMOXXuo1bnfXKj5/+dhp99cHfFhuAa1nIZmLMNoDk+JJyobN2AljDBs3CtHN8Na5mQx5eZ18QTlGP yanird@packer' >traianaSSHAccess.pub
  sudo chmod 600 traianaSSHAccess.pub
  sudo chown traiana:traiana traianaSSHAccess.pub
  sudo mv traianaSSHAccess.pub /home/traiana/.ssh/
}


function configECS(){
    echo "±±±±±±±±±±±±±>configECS"
    sudo docker version
    mkdir -p /var/log/ecs /var/lib/ecs/data /etc/ecs
    service docker start

    touch /etc/ecs/ecs.config
    echo "ECS_DATADIR=/data" >> /etc/ecs/ecs.config
    echo "ECS_ENABLE_TASK_IAM_ROLE=true" >> /etc/ecs/ecs.config
    echo "ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true" >> /etc/ecs/ecs.config
    echo "ECS_LOGFILE=/log/ecs-agent.log" >> /etc/ecs/ecs.config
    echo "ECS_AVAILABLE_LOGGING_DRIVERS=$${ECS_LOGGING_DRIVERS}" >> /etc/ecs/ecs.config
    echo "ECS_LOGLEVEL=info" >> /etc/ecs/ecs.config
    echo "ECS_CLUSTER=$${ECS_CLUSTER_NAME}" >> /etc/ecs/ecs.config
    echo "ECS_UPDATES_ENABLED=true" >> /etc/ecs/ecs.config
    echo "ECS_UPDATE_DOWNLOAD_DIR=/cache" >> /etc/ecs/ecs.config

    start ecs

    until $(curl --output /dev/null --silent --head --fail http://localhost:51678/v1/metadata); do
      printf '.'
      sleep 10
    done
}

function installEcsAgentContainer(){
    service_name="ecs-agent-container"
    cat << EOF > /etc/init.d/$service_name
#!/bin/bash
# $${service_name} daemon
# chkconfig: 2345 80 60
# desc: $${service_name} daemon
# initd deamon script for $${service_name}
# dynamic init.d script version 1.0.0.0
. /etc/rc.d/init.d/functions
SERVICE_NAME=$${service_name}
PID_PATH_NAME=/tmp/$${service_name}.pid

start() {
    echo "Starting $${service_name} ..."
    /usr/bin/docker rm -f $${service_name}
    /usr/bin/docker run --name $${service_name} \
        --cidfile="$${PID_PATH_NAME}"
        --privileged \
        --restart=on-failure:10 \
        --volume=/var/run:/var/run \
        --volume=/var/log/ecs/:/log:Z \
        --volume=/var/lib/ecs/data:/data:Z \
        --volume=/etc/ecs:/etc/ecs \
        --net=host \
        --env-file=/etc/ecs/ecs.config \
        amazon/amazon-ecs-agent:latest
}
stop() {
    echo "service $${service_name} stoping ..."
    /usr/bin/docker stop $${service_name}
}

case "\$$1" in
    start)
        start
    ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
esac
EOF
    chmod 755 /etc/init.d/$service_name
    chkconfig --add $service_name
    chkconfig $service_name on
    service $service_name start
    echo "######> FINISHED $service_name SERVICE CONFIG"
}

function installDataDogAgentContainer(){
    service_name="datadog-agent-container"
    cat << EOF > /etc/init.d/$service_name
#!/bin/bash
# $${service_name} daemon
# chkconfig: 2345 80 60
# desc: $${service_name} daemon
# initd deamon script for $${service_name}
# dynamic init.d script version 1.0.0.0
. /etc/rc.d/init.d/functions
PID_PATH_NAME=/tmp/$${service_name}.pid

start() {
    echo "Starting $${service_name} ..."
    /usr/bin/docker rm -f $${service_name}
    /usr/bin/docker run -d \
        --name $${service_name} \
        --cidfile="$${PID_PATH_NAME}" \
        -v /var/run/docker.sock:/var/run/docker.sock:ro \
        -v /proc/:/host/proc/:ro \
        -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
        -e API_KEY=$${DATADOG_AGENT_API_KEY} \
        datadog/docker-dd-agent:latest
}
stop() {
    echo "service $${service_name} stoping ..."
    /usr/bin/docker stop $${service_name}
}

case "\$$1" in
    start)
        start
    ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
esac
EOF
    chmod 755 /etc/init.d/$service_name
    chkconfig --add $service_name
    chkconfig $service_name on
    service $service_name start
    echo "######> FINISHED $service_name SERVICE CONFIG"
}


function configAwsLogs(){
    echo "±±±±±±±±±±±±±>configAwsLogs"
    cat > /etc/awslogs/awslogs.conf <<- EOF
[general]
state_file = /var/lib/awslogs/agent-state
use_gzip_http_content_encoding = true

[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = $${ECS_CLOUDWATCH_LOG_GROUP}
log_stream_name = $${ECS_CLUSTER_NAME}/{container_instance_id}

[/var/log/messages]
file = /var/log/messages
log_group_name = $${ECS_CLOUDWATCH_LOG_GROUP}
log_stream_name = $${ECS_CLUSTER_NAME}/{container_instance_id}
datetime_format = %b %d %H:%M:%S

[/var/log/docker]
file = /var/log/docker
log_group_name = $${ECS_CLOUDWATCH_LOG_GROUP}
log_stream_name = $${ECS_CLUSTER_NAME}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%S.%f

[/var/log/ecs/ecs-init.log]
file = /var/log/ecs/ecs-init.log.*
log_group_name = $${ECS_CLOUDWATCH_LOG_GROUP}
log_stream_name = $${ECS_CLUSTER_NAME}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/ecs-agent.log]
file = /var/log/ecs/ecs-agent.log.*
log_group_name = $${ECS_CLOUDWATCH_LOG_GROUP}
log_stream_name = $${ECS_CLUSTER_NAME}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/audit.log]
file = /var/log/ecs/audit.log.*
log_group_name = $${ECS_CLOUDWATCH_LOG_GROUP}
log_stream_name = $${ECS_CLUSTER_NAME}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ
EOF
    sed -i -e "s/region = us-east-1/region = $current_aws_region/g" /etc/awslogs/awscli.conf

    # Set the ip address of the node
    container_instance_id=$(curl 169.254.169.254/latest/meta-data/local-ipv4)
    sed -i -e "s/$${container_instance_id}/$${container_instance_id}/g" /etc/awslogs/awslogs.conf

    cat > /etc/init/awslogjob.conf <<- EOF
    #upstart-job
    description "Configure and start CloudWatch Logs agent on Amazon ECS container instance"
    author "Amazon Web Services"
    start on started ecs
    script
        exec 2>>/var/log/ecs/cloudwatch-logs-start.log
        set -x

        until curl -s http://localhost:51678/v1/metadata
        do
            sleep 1
        done

        service awslogs start
        chkconfig awslogs on
    end script
EOF
}

function installOssecAgent(){
  sudo yum install  https://generic_reader:AKCp5Zk9TtVqJsoi71c3ipv2FK9tPCLWpC7PfaoCcZeXDF782V1dqvzvfGTW5DLueii7FAZYX@artifactory.traiana.com/artifactory/centos-local/wazuh-agent-2.1.1-1.el7.x86_64.rpm -y
  sudo /var/ossec/bin/agent-auth -m ossec-manager-internal-elb.traiana-services.services
}


function disableSeLinux(){
    echo "±±±±±±±±±±±±±>disableSeLinux"
    sudo setenforce Permissive 1>>$LOGFILE 2>&1
    sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
}

function configMachineLevel(){
    installPreReq
    configureDhcpOptions
    addLuminateCertAndConfigSSHD
    addTraianaSSHKey

    setTimeZone
    disableSeLinux
    mountEFS
    configECS
    configAwsLogs
    installEcsAgentContainer
    installDataDogAgentContainer
}

function reboot(){
    shutdown -r now
}


function main(){
    configMachineLevel
    echo "DONE NODE CUSTOMIZATION, REBOOTING..."
    reboot
}

main
