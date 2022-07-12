# Crear el cluster de Kubernetes
# Instalar los programas de kubernetes, que corren como pods(contenedores) dentro del propio cluster
# - coreDNS
# - Base de datos: etcd
# - Kube-scheduler: Determinar en que nodo se van instalando los pods
# - kube-api-server: Atiende peticiones del kubectl u otros clientes
# - kube-controller: Quien está mirando que los pods corren sin problemas
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# Tenemos que decirle en que subnet vamos a usar para los pods 192.168.0.0/16

# Tendremos que configurar el cliente de kubernetes: kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# En nuestro caso, que estamos montando una instalación de juguete,
# Vamos a desactivar un TAINT que tiene el nodo maestro
# Basicamente esto va a apermitir que este nodo (maestro) pueda ejecutar otros programas más allá de los propios de kubernetes
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

# Tenemos que crear una vlan propia del cluster. Meter unos programas que gestionen el tráfico de red en esa vlan
# Esa red vlna tendrá una configuración de red :: Mascara en la que opera: 192.168.0.0/16
kubectl create -f https://projectcalico.docs.tigera.io/manifests/tigera-operator.yaml

kubectl create -f https://projectcalico.docs.tigera.io/manifests/custom-resources.yaml

kubectl scale deployment.apps/tigera-operator -n tigera-operator --replicas 0                   
kubectl delete pod $(kubectl get pod -n tigera-operator  | sed 's/ .*//') -n tigera-operator