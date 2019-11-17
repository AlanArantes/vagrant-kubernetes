kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

curl -Ss https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml -OS
kubectl apply -f kube-flannel.yml

curl -Ss https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta4/aio/deploy/recommended.yaml -o kube-dashboard.yml
kubectl apply -f kube-dashboard.yml
