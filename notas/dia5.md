Cluster de Kubernetes
    
    Maquina 1
    
    Maquina 2
    
    Maquina 3*****
        es
    
    Maquina n*****
        es
    ^^^
Balanceador externo (METALLB)
 ^^^^
Cliente

Afinidades

----

Los nodos al igual que los pods, o que los deployments, o que los service, pueden tener etiquetas (labels).
Etiquetas básicas:
                    beta.kubernetes.io/arch                                     =amd64
                    beta.kubernetes.io/os                                       =linux
                    kubernetes.io/arch                                          =amd64
                    kubernetes.io/hostname                                      =ip-172-31-14-209
                    kubernetes.io/os                                            =linux
                    node-role.kubernetes.io/control-plane=
                    node.kubernetes.io/exclude-from-external-load-balancers=

$ kubectl label node NOMBRE   etiqueta=valor

Las etiquetas son una forma sencilla de comenzar a elegir en que nodos despliega una app.

3 tipos de afinidad:
    Afinidades con nodos
    Afinidades con Pods
    Antiafinidades con Pods

Tengo 10 maquinas: Maquina1-Maquina10
Quiero montar ES en el cluster (Voy a dejar 5 maquinas para poder instalar ES)
Maquina1-Maquina5 <<<<< Aqui dentro es donde aplicaré los cambios en el kernel.
Y a esas máquinas las pondré una etiqueta: elasticsearch

De forma que cuando defina la plantilla de Pod de ElasticSearch, dire:
    Que los pods que se generen desde esa plantilla solo puedan ir a un nodo con la etiqueta elasticsearch.
    Luego haré las replcias que quiera.... A lo mejor 3. Y las 3 se ponen en el mismo host

---

Yo quiero que unos pods se puedan instalar solo en un tipo de máquinas          Limitación al pod, acerca de donde instalarse               AFINIDADES
De momento he conseguido que ES solo se instale en las maquinas de la 1 a la 5.
---

Yo quiero que un unos nodos se puedan instalar solo ciertas apps:               Limitación al nodo, acerca de que debe dejar instalarse     TAINS/TOLERATIONS
    Quiero dejar unos nodos dedicados a una app (o varias)
    
    
    
    
Eso significa que las máquinas 1-5 han quedado para elasticsearch?


Maquina 1 [elasticsearch] (ES)
    POD A (4)
Maquina 2 [elasticsearch] (ES)
    POD A (2)
Maquina 3 [elasticsearch] (ES)
    POD A (3)
Maquina 4 [elasticsearch] (ES)
    POD A (1)
Maquina 5 [elasticsearch] (ES)
Maquina 6
Maquina 7   
Maquina 8
    MariaDB
Maquina 9
Maquina 10


POD A * 4 replicas
    Afinidad con nodos [elasticsearch] (+ES)
    Antiafinidad con otros pods de elasticsearch:
        El scheduler intentará o evitará poner este pod donde ya haya otro pod de elasticsearch

POD B
    MariaDB... Sin afinidades -> A cualquiera de las 6-10

En los nodos, del 1 al 5, pondría un TAINT (tinte)
Una regla que le indica al nodo que rechace todos los pods que no toleren ese TINTE

$ kubectl taint node NOMBRE   tinte=valor:NoSchedule    Ese tinte evita que pods se asignen a la maquina
                                          NoExecute     Ese tinte evacua pods que estén ya en la maquina corriendo
                                                        pero que no admitan el tinte

kubectl taint node $(hostname) elasticsearch=true:NoSchedule        # Los que no toleren ese tinte, no podrán asignarse al nodo
kubectl taint node $(hostname) elasticsearch=true:NoSchedule-       # Quito el tinte



Cluster
                                        PODX
                                AFINIDAD con app:NOTIN(nginx)                                   ANTIAFINIDAD con app:IN(nginx)
Nodo1                                       x                                                               √
                                                                                            No genero mal rollo con el nodo.. no tiene un nginx
Nodo2
    POD NGINX - app:nginx                   x                                                               x
                                No me puedo instalar porque no hay pod                      Genero mal yuyu con el nodo... ya tiene un nginx
                                con etiqueta distinto de nginx
Nodo3                                       
    POD MYSQL - app:mysql                   √                                                               √
                                Si porque hay un pod con etiqueta distinto de nginx         No genero malas vibras con el nodo
Nodo4                                       
    POD NGINX - app:nginx                                                                                   x
    POD MYSQL - app:mysql ***               √                                                       
                                Si porque hay un pod con etiqueta distinto de nginx         Genero mal rollito con el nodo (ya tiene un nginx)


---

Quiero desplegar un POD
                                            Antiafinidad: Con nginx, con topologia a nivel de cliente
Cluster
    Cliente A
        Nodo 1A  - cliente:A                        √
        Nodo 2A                                     √
    Cliente B
        Nodo 1B  - cliente:B                        x
            pod nginx
        Nodo 2B                                     x
    Cliente C
        Nodo 1C  - cliente:C                        √
            pod mysql
        Nodo 2C                                     √
    Cliente D
        Nodo 1D  - cliente:D                        x
            pod nginx
            pod mysql
        Nodo 2D                                     x

Zonas geográficas

---

hpa - HorizontalPodAutoscaler 1..10 replcias en base a cpu y memoria

wget https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml


Kubernetes
    Exportador de metricas para el cluster < Prometheus  < Almacen de metricas  <<< Exportadores de metricas <<< nginx 
        ^^^^^^
        HPA
        
--
Que hicimos el dia 1 despues de instalar kubernetes? 


SELinux -> Redhat, Fedora, CentOS
Security Enhanced for Linux
    Desactivado. Esto no se hace...
    Permisivo. Cada operación que se hace en el SO se registra en el journal
        En el propio journal genera las incidencias (cosas que ocurren en el uso normal de la maquina)
            que incumplen una politica de seguridad que haya sido creada... A priori NINGUNA
            No solo genera las incidencias... Sino me genera un codigo bash para dar de alta las reglas 
                que aprueben esas politicas (esas cosas que están cocurriendo)
    Forzado <<<<


AppArmor -> Ubuntu

REST -> http(s)
                            ESPIA
    Servidor de apps 1   -----------  Servidor de apps 2 (TOMCAT, WEBLOGIC)
        App1             -----------    App2
                                                Clave privada
                                                Clave public -> certificado
                                                                    V
                                                                CA de confianza
                                                                
https: Nos ayuda a ~~evitar~~ frustrar 2 tipos de ataques:
- Man in the middle             ENCRIPTADO
                                        - Simetricos    Usan la misma clave para cifrar y descifrar
                                        - Asimetricos.  Usan 1 clave para cifrar y otra para descifrar
- Suplantación de identidad     CERTIFICADO
 
3-5 minutos

Cluster de Kubernetes:
    Service Mess: Follón Lio de servicios que te cagas
            VVVV
    Service Mesh


Istio -> Inyectar dentro de cada pod un proxy (envoy), que filtra TODAS LAS COMUNICACIONES 
entrantes y salientes al pod

    POD1                                        POD2
    Tomcat 1                                    weblogic2
      v^  localhost                               ^v    localhost
    Envoy   <------------------------------->   Envoy
    
    
    Generar claves y certificados para todos ellos... y mantenerlos
    
    Seguridad:  Comunicaciones securizadas:TLS
                Politicas de red son autogeneradas (bajo supervisión)
    
    Observabilidad
    
    
            ---->   SERVICE    ----->                POD
                                            encuesta de satisfacción v1
                                            
                                                     POD                    1% -> 10% -> 50% -> 100%
                                            encuesta de satisfacción v2
                                            
                                            
CRD

Custom resource definitions


Cliente --->    Service             
                Envoy (si tiene gestión de colas) -> POD 
                    empezar a encolar peticiones        y cuando el pod conteste, las manda
                    perdida de servicio 0%
                    tiempo de retraso en la entrega


Openshift


kubernetes es una especificación    Native cloud foundation
    k8s
    k3s
    minikube < k8s en pequeñito... para un ordenador
    minishift < okd en pequeñito
    okd         > Openshift Container Platform (Redhat)
                        HorizontalMachineAutoscaler -> En auto se contratan bajo demanda (terraform) -> Cloud
                        MachineSets                     ~= Deployment
                        Machine                         > Maquina física
                        Nodo???                         > Ejecución de kubernetes en una maquina física
                        
contenedor es una especificación    Open container initiative


---
helm ayuda a controlar los despliegues que tengo en un cluster de Kubernetes
Y también a generar los archivos de despliegue de una apliación


Chart de Helm
Plantilla (un conjunto de ficheros en carpetas organizados)
                            VVVVV
                        los objetos que vamos a crear en kubernetes asociados a un despliegue
                        
                        
Helm se basa en repositorios
En los repos encontramos charts

Lo primero es dar de alta un repo
Podemos descargar un chart de ese repo. No es obligatorio, pero es la mejor forma 
de conseguir el fichero de parametros:
values.yaml ******* TENDRE QUE RELLENAR COSAS ACERCA DE LA APP QUE DESPLIEGO
            ******* TENDRE QUE RELLENAR COSAS DE CONFIGURACIÓN DE KUBERNETES
Esto lleva rato -> 5/6 horas hasta tener algo decente
cuando se del tema... y ya he currado con muchos charts... 1-2 horas

Una vez nos hagamos con el fichero, habrá que configurarlo
Y despues desplegarlo en el cluster


---

Pods que interactuan con Kubernetes:
dashboard -> crear o borrar un pod -> kubect delete 
provisionador nfs: watch pvc -> create pv

Openshift impone limitaciones gordas y grandes y rigidas a la seguridad.
En Openshift las imagenes de contenedor no pueden usar el usurio root. Esta prohibido por defecto.
La mayor parte de las imagenes de docker hub (slvo las de bitnami y alguna más)
usan el usuario root (y eso es una muy mala practiva)
Otra cosa a la que obliga openshift es a que todo pod tenga su propio service account