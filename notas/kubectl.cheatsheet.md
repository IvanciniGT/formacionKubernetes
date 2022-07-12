$ kubectl [verbo] [tipo_objeto] <args>

# Tipos de objeto:

node nodes
pod pods
deployment
service svc services
pv persistentvolume
ns namespaces

# Verbos

get - listado
describe - obtener un detalle de un objeto

# Args

-n --namespace Namespace donde queremos estar trabajando

$ kubectl apply -f FICHERO -n NAMESPACE     # Crea o modifica los objetos que haya definidos en el fichero suministrado

$ kubectl create -f FICHERO -n NAMESPACE    # Crea los objetos que haya definidos en el fichero suministrado

$ kubectl delete -f FICHERO -n NAMESPACE    # Borra los objetos que haya definidos en el fichero suministrado

