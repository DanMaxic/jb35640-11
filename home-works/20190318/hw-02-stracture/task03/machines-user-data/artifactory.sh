#!/usr/bin/env bash


function installPreReq(){
    echo "±±±±±±±±±±±±±>installPreReq"
    yum update -y
    yum install -y yum-utils git jq aws-cli docker bind-utils nano java wget unzip bash-completion wget
}

function installMinikube() {
  curl -Lo minikube \
    https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
    && sudo install minikube /usr/local/bin/
  ln -s /usr/local/bin/minikube /usr/bin/minikube
}
function installKubectl(){
  kv=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
  curl -Lo kubectl \
    https://storage.googleapis.com/kubernetes-release/release/$kv/bin/linux/amd64/kubectl \
    && sudo install kubectl /usr/local/bin/

  ln -s /usr/local/bin/kubectl /usr/bin/kubectl
  echo "source <(kubectl completion bash)" >> ~/.bashrc
}

function installDocker(){
  yum install -y docker
  systemctl enable docker
  systemctl start docker

}

function startMinikube(){
  swapoff -a
  export MINIKUBE_WANTUPDATENOTIFICATION=false
  export MINIKUBE_WANTREPORTERRORPROMPT=false
  export MINIKUBE_HOME=$HOME
  export CHANGE_MINIKUBE_NONE_USER=true
  export KUBECONFIG=$HOME/.kube/config

  mkdir -p $HOME/.kube $HOME/.minikube
  touch $KUBECONFIG

  sudo -E minikube start --vm-driver=none

}

function addAditionsComponents(){
  kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended/kubernetes-dashboard.yaml

  cat <<EOF >> k8s-dashboard-admin-user.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
EOF
  kubectl apply -f ./k8s-admin-dashboard-user.yaml
  kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}') > /etc/K8S-TOKEN.txt


}

function main(){
  installPreReq
  installDocker
  installMinikube
  installKubectl
  startMinikube
  addAditionsComponents
}

main