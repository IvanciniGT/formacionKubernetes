#!/bin/bash
sudo apt install nfs-kernel-server -y
sudo mkdir -p /data/nfs
sudo chown nobody:nogroup /data/nfs/
sudo chmod 777 /data/nfs/
echo "/data/nfs 172.0.0.0/8(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports > /dev/null
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
sudo ufw allow from 0.0.0.0/0 to any port nfs
showmount -e 

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

helm repo add nfs-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
helm pull nfs-provisioner/nfs-subdir-external-provisioner --untar

