yum -y upgrade
yum -y install bind-utils net-tools epel-release jq ntp

# Configure OS
systemctl stop chronyd
systemctl disable chronyd
systemctl start ntpd
systemctl enable ntpd

systemctl disable NetworkManager.service
systemctl stop NetworkManager.service

systemctl disable firewalld
systemctl stop firewalld

# Kubernetes Installation on master
yum install -y docker
systemctl enable docker && systemctl start docker
    
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

setenforce 0

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system

swapoff /swapfile
sed -i 's/\/swapfile/#\/swapfile/' /etc/fstab

yum -y upgrade
yum -y install kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet
   
kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

curl -Ss https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml -OS
kubectl apply -f kube-flannel.yml

curl -Ss https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml -o kube-dashboard.yml
kubectl apply -f kube-dashboard.yml

kubectl get services -n kube-system | grep dashboard

ip a

echo Done!
