Cluster kubernetes
 |          DNS: servicio-ingress->       192.168.100.100
 |.      
 |-10.0.0.1- Maquina 1
 |           netfilter: 
 |                                      0.0.0.0:30080 -> servicio-ingress:8080
 |                                      192.168.100.100:8080 -> 192.168.0.2:80 | 192.168.0.3:80
 |           -192.168.0.2:80- Pod ingressController
 |
 |-10.0.0.2- Maquina 2
 |           netfilter: 
 |                                      0.0.0.0:30080 -> servicio-ingress:8080
 |                                      192.168.100.100:8080 -> 192.168.0.2:80 | 192.168.0.3:80
 |           -192.168.0.3:80- Pod ingressController
 |
 |-10.0.0.3- Maquina 3
 |           netfilter: 
 |                                      0.0.0.0:30080 -> servicio-ingress:8080
 |                                      192.168.100.100:8080 -> 192.168.0.2:80 | 192.168.0.3:80
 |
 |-10.0.2.200-Balanceador de carga compatible con kubernetes (cualquier cloud trae el suyo y on premises puedo usar MetalLB)
 |               http://10.0.0.1:30080
 |               http://10.0.0.2:30080
 |               http://10.0.0.3:30080
 |
 |- DNS de mi empresa: miapp1: 10.0.2.200
 |
 |-10.0.1.100- LucasPC
                http://miapp1


Hemos creado un servicio de tipo de ClusterIP
NodePort: 30080



----


He conseguido que a partir de este momento.... Kubernetes....
se asegure que siempre voy a tener un mariadb corriendo en el cluster
y... 
que me monte un balanceador de carga para acceder al mariadb
y...
que se coma su configuración y actualizaciones
y... que este monitorizando el mariadb... por si se cae
pa que ponga otro... porque hemos dichero que SIEMPRE tienen que estar 
funcionando el mariadb dentro del cluster

MIENTRAS YO ESTO TOMANDO CERVEZAS !!!!


Script de instalación 
    MariaDB
    Balanceador
    Entrada en DNS
+ Instrucciones para el mantenimiento de eso

Lenguaje DECLARATIVO        Ansible

Bash: ps1: Imperativo

Kubernetes, instala mariadb, 1 copia !!!!                                                     < Imperativo
    Si no existe ya mariadb... se instala
    Y si existe ???? ERROR !!!!!
Kubernetes, tiene que haber 1 copia de mariadb en el cluster en funcionamiento siempre !!!!   < Declarativo
