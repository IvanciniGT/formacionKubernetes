# Desactiva la swap del OS
sudo swapoff -a
sudo sed -i 's/\/var/#\/var/' /etc/fstab    # Desactivación persistente

# Tenemos un problemita adicional... AMAZON, muy amable nos ha instalado docker, containerd en el host
sudo apt purge docker-ce containerd.io -y
sudo apt autoremove -y

# Tener un gestor de contenedores compatible con kubernetes: CRIO / Containerd
# Activar unos modulos del kernel
sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

#############################
# instalar crio
export OS=xUbuntu_18.04
export VERSION=1.22

echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" | sudo tee -a /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" | sudo tee -a /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list

curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$VERSION/$OS/Release.key | sudo apt-key add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key add -

sudo apt update
sudo apt install cri-o cri-o-runc -y

apt-cache policy cri-o

sudo systemctl daemon-reload
sudo systemctl enable crio --now

# Instalación de las herramientas básicas de kubernetes: APT
# kubeadm < Permite gestionar un cluster: Crearlo, borrarlo, añadir máquinas
# kubelet < Demonio que debe estar corriendo en todas las máquinas de un cluster de kubernetes
# kubectl < Cliente que usaremos para conectar con el cluster y hacerle peticiones

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install kubeadm kubelet kubectl -y