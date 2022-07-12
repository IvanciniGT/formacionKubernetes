# Kubernetes

Orquestador/Gestor de gestores de contenedores, pensado para despliegue de aplicaciones en un entorno de producción:
- Escalabilidad         capacidad de ajustar la infraestructura/capacidad de cómputo a las necesidades de cada momento.

        App1 : Modelo muy normalito: Cualquier app departamental
            Dia 1:    100 usuarios
            Dia 100:  100 usuarios           Escalabilidad NINGUNA
            Dia 1000: 100 usuarios
            
        App2 : Modelo muy normalito: Un servicio que ofrezcoa clientes.. Más clientes, pues más curro.
            Dia 1:    100 usuarios
            Dia 100:  1000 usuarios          Escalado vertical: Más máquina!
            Dia 1000: 10000 usuarios
    
        App3 : Modelo muy normalito: Internet
            Dia n:    100 usuarios                  1 apache (en una maquina)           50 apaches (en 50 maquinas)
            Dia n+1:  1000000 usuarios       Escalado horizontal: Más instancias /copias de la aplicación (más máquinas donde ejecutarse) 
            Dia n+2:  10 usuarios               Cluster activo/activo < Balanceador de carga
            Dia n+3:  2000000 usuarios

- Alta disponibilidad   Intentar garantizar:
                            - La no pérdida de información (datos)
                            - Un tiempo mínimo de funcionamiento del sistema
                                    99% -> DE CADA 100 DIAS 1 OFF . 3,6 dias al año el sistema off
                                    99,9% -> 8 horas al año
                                    99,99% -> Minutos al año
                        REPLICACION / REDUNDANCIA > cluster

Tipos de cluster:
- Activo/Pasivo
- Activo/Activo

Cluster operado por kubernetes < nginx < mariadb
    Maquina 1               IP ethernet:9999->80 (nginx)
        Gestor de contenedores: crio/containerd
        nginx. ON - Puerto: 80(http), 443(https). De qué IP? De la del contenedor
    Maquina 2 CATACATAPLAS !!!!
        Gestor de contenedores: crio/containerd
        HDD Host: Datos del mariadb
        mariadb PLUS, CATAPLAS !!!!!
        mariadb2
    Maquina 3               IP ethernet:9999->80 (nginx)
        kubelet \
        Gestor de contenedores: crio/containerd
        nginx. ON - Puerto: 80(http), 443(https). De qué IP? De la del contenedor
    Maquina N
        kubelet \
        Gestor de contenedores: crio/containerd
        mariadb

Volumenes accesibles por RED:
- NFS
- Cabina de almacenamiento fibra optica
- iscsi
- Cloud
- Ceph < 800k€

Cada dato, lo querré al menos en otros 2 discos duros.
4 Tbs -> 3 x 4 Tbs

Almacenamiento es CARO DE COJONES !!!!!!

Balanceador de carga

MenchuPC -> IPmaquina1:9999
MenchuPC -> IPmaquina2:9999
MenchuPC -> IPmaquina3:9999
MenchuPC -> IPmaquina4:9999
Y si maquina1 se va de baretas????

Menchu PC -> Balanceador de carga -> Servicio de balanceo -> Proxy reverso -> Servicio de balanceo de carga -> nginx

Ingress???                                                  Regla de configuración para el proxy reverso (Proxy reverso: IngressController)
Service                             Balanceado de carga

# Contenedor

Entorno aislado dentro de un SO Linux donde ejecuatar procesoSSS.
Entorno aislado?
- Limitación de acceso a recursos hardware de la máquina host
- Su propia configuración de red -> su(s) propia(s) IP(s)
    - loopback: 127.0.0.1 - localhost
    - red virtual de gestión de contenedores -> IP
        Depende del gestor de contenedores concreto que usemos
- Su propio sistema de archivos (FileSystem)
- Sus propias variables de entorno

IMPORTANTE:

cuando trabajo con contenedores, solo hay UN UNICO E INIMITABLE SISTEMA OPERATIVO (el del host).
Esto no son máquinas virtuales. Los contenedores NO TIENEN NI PUEDEN TENER UN SO.

Los contenedores los creamos desde IMAGENES DE CONTENEDOR.

# Imagen de Contenedor

Un triste fichero comprimido (tar) que contiene:
- Una estructura de carpetas compatible con POSIX
- Además de una serie de programas ya instalados y configurados por alguien de antemano
Adicionalmente acompaña a esa imagen de contenedor:
- Configuraciónes preestablecidas para los contenedores que se creen desde esta imagen de contenedor.

De donde saco las imágenes de contenedor: En un registry de repositorios de imagenes de contenedor:
- docker hub
- quay.io           <           redhat


# Para ejecutar contenedores necesito

Un gestor de contenedores: 
    docker
    podman: POD Manager
    > containerd
    > crio
    nomad


Que interfaces de red tenemos en cualquier computadora:
- loopback: 127.0.0.1 (localhost)
- eth:      192.168.0.0/16
            172.0.0.0/8


COSAS HORRENDAS SOBRE CONTENEDORES: 
    x Basado en imágenes... plantillas que emulan un Sistema Operativo
    x No todas están basadas en sistemas Operativos....
    x Necesita un Sistema Operativo para correr aplicaciones
    
UNIX : POSIX + SUS
Especificación de como montar un SO

MacOS, Solaris, AIX, HPUX

386BSD -> freBSD, netBSD, MacOS
GNU/Linux




Imagen de Alpine: -> Fichero TAR
Descomprimo:
/
    etc/
    opt/
    var/
    home/
    root/
    bin/
        sh
        ls
        mkdir
        chmod
        chown
        touch
        cd
        cp
        mv
        rm
    media/
    mnt/



------------------------------------------------------------------------------ AmazonRed
 |                                                                  |
172.31.14.209:9999                                               17.31.14.220
 |              -> 172.17.0.2:80                                    |
IvanPC NAT                                                        MenchuPC
 |
172.17.0.1
 |
 |- 172.17.0.2 - nginx :80
 |
 | red virtual de docker
 
iptables > dar reglas a netfilter
netFilter es un software que existe dentro del kernel de Linux
Que se encarga de TODOS y cada uno de los paquetes de red que se mandan / reciben por el host

---
Kubernetes: Kubernetes es quien va a gestionar/operar el entorno de producción de mi empresa

# POD: Un conjunto de contenedores, que:

- Comparten configuración de red... y por ende pueden hablar entre si a través de la palabra: localhost         ME DA IGUAL
- Pueden compartir almacenamiento... y por tanto archivos/datos                                                 NO ME HACE FALTA
- Escalan juntos/a la par                                                                                       NI DE COÑA !!!!!!
- Se despliegan en el mismo host

Los pods pueden ejecutar 2 tipos de contenedores:
- Contenedores normales: Que dentro solo podrán ejecutar procesos de tipo demonio (app que corre en segundo plano de forma indefinida en el tiempo)
    si un contenedor normal de un POD se para. Kubernetes se vuelve loco (le salen las alarmas)
- InitContainers:        Que podrán ejecutar comandos o scripts (Que tiene un tiempo de ejecución finito: Se arrancan... hacen lo que tengan que hacer y acaban)
No será hasta que los N initContainers definidos en un pod hayan acabado que se ejecuten sus contenedores normales.


Yo quiero instalar Wordpress: CMS
    Apache
    MySQL

1ª Me interesa usar contenedores para la instalación/ejecución? SI, ni me lo planteo.
2º Cuantos? 
    Apache y MySQL juntos o separados?
        Separados? Para que quiero abstraer (airlar) uno de otro?
            Si se rompe uno no se rompe el otro... Me vale esto pa algo? Si se rompe el mysql.-.. voy jodido de todas formas
            
                Con un servidor de BBDD, quizás puedo atendera varios apaches... ESCALABILIDAD
        POR SEPARADO: ESCALABILIDAD
            Facilita el mantenimiento: 
                - Quiero actualizar la versión MySQL
                    Tengo un contenedor con MySQL v5.7 -> v5.7.1
3º Pero ahora me voy a kubernetes... porque quiero un entorno con HA/Escalabilidad, cosa que Docker no me da...
Y en kubernetes existe el concepto de POD...
Cuantos pod monto?
    OPCION A *****
        POD 1 - MySQL
        POD 2 - Apache -> log de accesos... Me interesa ese log? Siii, para que?
                                                                 Saber quien y cuando y como están entrando a mi web
                10 apaches... cada uno con sus fichero de log.
    OPCION B
        UNICO POD - MySQL + APACHE          Escala juntos


Balanceador de carga

Un software que recibe peticiones y las reparte entre una serie de servicios de backend:
HAProxy, Apache, nginx


Donde no me interesan ni de coña esos ficheros de log??? en el propio contenedor. Por qué?
- Si pierdo el contenedor, pierdo los logs -> Ponlos en un volumen
- Me gustaria poder consultar/analizar los logs desde un único sitio... no entrando en 17 computadoras 
- Cuando deja de crecer el fichero de log? NUNCA ... pues prepara hdd en el host donde esté el apache

Donde me interesan esos logs? En un sitio centralizado: ELASTICSEARCH

Maquina 1
    Contenedor Apache1
        access.log                      
    Contenedor filebeat
Maquina 2        
    Contenedor Apache1
        access.log                      >>>         ElasticSearch       <<< Kibana
    Contenedor filebeat
Maquina 3
    Contenedor Apache1
        access.log                      
    Contenedor filebeat

Por cada apache, tener su filebeat
    Cuando levante u nuevo apache, levanto un nuevo filebeat
    cuando apague un apache, apago su filebeat
Además, en el mismo host:
    Compartan el fichero de access.log (a ser posible con almancemaiento en RAM)
    
    
    

POD: Un conjunto de contenedores, que:
- Comparten configuración de red... y por ende pueden hablar entre si a través de la palabra: localhost         NO HABLAN POR RED
- Pueden compartir almacenamiento... y por tanto archivos/datos                                                 LO NECESITO !!!!!
- Escalan juntos/a la par                                                                                       ESO QUIERO !!!!!
- Se despliegan en el mismo host                                                                                TAMBIEN LO QUIERO, para compartir RAM

1 UNICO POD: Apache + filebeat
Otro pod con MariaDB


---


Cluster de kubernetes:
|
||- Red virtual del cluster de kubernetes: 20.0.0.0/8
||- KubeDNS:    basedatos.prod.es -> 20.10.0.2                       Que bueno es que Kubernetes gestione automaticamente 
||                                                                  estas entradas del DNS y si cambia la IP, me cambia esto en automático
||              wordpress.produccion.es -> 20.10.0.1
||              ingress.controller -> 20.10.0.3
||- 10.0.0.1 - Maquina 1:
||          :30080 -> ingress.controller:80
||               Pod2: MySQL: 3306         CATAPLAS!!!
||
||- 10.0.0.2 - Maquina 2
||          :30080 -> ingress.controller:80
||               Pod2: MySQL: 3306         20.0.0.4
||
||- 10.0.0.3 - Maquina 3
||          :30080 -> ingress.controller:80
||               Pod1: Apache: 80          20.0.0.1
||                     (URL BBDD: basedatos.prod.es:3307) 
||
||- 10.0.0.4 - Maquina 4
||          netfilter
||          :30080 -> ingress.controller:80
||            LB_BBDD 20.10.0.2:3307 
||                        20.0.0.3:3306
||                        20.0.0.4:3306
||            LB_Apache 20.10.0.1:8080
||                        20.0.0.1:80
||            LB_Ingress 20.10.0.3:80
||                        20.0.0.5:80
||               Pod2: MySQL: 3306         20.0.0.3
||               Pod3: IngressController(Nginx): 80         20.0.0.5
||                          Regla de enrutamiento (INGRESS): app.prod.es -> wordpress.produccion.es:8080
|
|- Servidor DNS
|           app1.prod.es -> 10.0.0.6
|
|- 10.0.0.6 - Balanceador de carga externo al cluster
|          :80 -> 10.0.0.1:30080
|          :80 -> 10.0.0.2:30080
|          :80 -> 10.0.0.3:30080
|          :80 -> 10.0.0.4:30080 ****
|
|- 10.1.0.2 - MenchuPC
|               Abre tu navegador y escribe: app1.prod.es
|
| Red de mi empresa

fqdn. Nombre de red
    DNS

Necesito montar un balanceador de carga     LB_BBDD 20.10.0.2:3307 
                                                        20.0.0.3:3306
                                                        20.0.0.4:3306
                                            LB_Apache 20.10.0.1:8080
                                                        20.0.0.1:80
                                            LB_Ingress 20.10.0.3:80
                                                        20.0.0.5:80
                                        
Como monto en Kubernetes un Balanceador de carga y una entrada en el DNS de kubernetes: SERVICE

# SERVICE EN KUBERNETES:

## ClusterIP
         Una entrada en el DNS de kubernetes    |
         + Una IP de balanceo de carga           |   Ambos con gestión automatizada por parte de kubernetes

## NodePort
    Es un servicio de tipo ClusterIP
    + abre un puerto (por encima del 30000) en cada host del cluster, apuntando al servicio 

## LoadBalancer
    Es un servicio de tipo NodePort
    + gestión/configuración automatica de un balanceador de carga externo!
    
    Por ello, el balanceador externo tiene que ser compatible con Kubernetes, 
    para que kubernetes sepa configurarlo y darle toda esa información
        Si hago una instalación on premise de kubernetes (en mis instalaciones) 
        el balanceador de carga externo que montamos, compatible con kubernetes se llama: MetalLB
        
        Si hago o uso un cluster creado y gestionado por un cloud (AWS, GPC, Azure), 
        ellos ya me "dan" (previo paso por caja) un balanceador externo compatible con kubernetes


Cuantos quiero de cada/tendré de cada en un cluster REAL? %
- ClusterIP         Servicios internos (BBDD, cache, mensajería)    Todos menos 1
- NodePort          Servicios expuestos al exterior                 Ninguno         
                        Si es igual al loadbalancer... 
                        y el último me gestión autom además el balanceador de carga externo
- LoadBalancer      Servicios expuestos al exterior                 1


Solo voy a tener un servicio PUBLICO ??¿¿?¿?¿?¿¿? IngressController = Proxy reverso
    Su misión es enrutar todas las peticiones externas al cluster
    

Esta es la configuración de cualquier cluster de produccción....

Menchu PC
    Navegador: app1.prod.es
    SO Menchu -> DNS Externo: 10.0.0.6
    Navegador: 10.0.0.6:80
        Balanceador externo: 
            Redirige la petición a un nodo del cluster: 10.0.0.3:30080
            Nodo del cluster:
                Redirige la petición a: ingress.controller:80
                    Lo primero se resuelve usando el KubeDNS -> 20.10.0.3
                    La petición se redirige a: 20.10.0.3:80
                        Es recibida por el balanceador del ingress, que 
                            La redirige a la IP de un POD del ingressController
                                En el ingress_Controller se busca una regla ingress para deteminar donde se debe redirigir la petición
                                    app.prod.es -> wordpress.produccion.es:
                                    Se busca en el KubeDNS wordpress.produccion.es: 20.10.0.1
                                        La petición la recibe el balanceador del apache
                                            Que la reenvia a uno de los PODs de apache: 20.0.0.1:80  
                                            
                                            

Imaginad que un supermercado: CARREFOUR es un cluster de Kubernetes
    Pescadería - Servicio: Entrada en el DNS + balanceo
                                VVVV           Numeritos que saco con el turno
                           CARTEL EN LO ALTO QUE DICE PESCADERIA AQUI !!!!!
        Puesto1 pescadería - Host, maquina  RECURSOS
            Pescadero 1 - Pod
                Pescado???      - Datos 
                Camara frigorifica - Volumen
        Pescadero 2 - Pod
        Pescadero 3 - Pod
        Pescadero aprendiz     - Pod
            Pescadero maestro  /
    Carnicería - Servicio
    Frutería   - Servicio
    Drogería   - Servicio
    Cajas      - Servicio
    Puerta de la calle!!!! IngressController?? CARTELES NA MAS ENTRAR: Ingress: Pscader��a pasillo 17



Contenedor? Empleado/Persona que hace un a trabajo:
Carnicero
Cajero
Frutero

Pregunta: Cuantos Pods vamos a crear NOSOTROS en un cluster de kubernetes? NINGUNO !

Porque yo estoy mejor tomando cervezas... crear pods es muy aburrido !!!
Kubernetes es quien crea los pods!

Entonces, que hacemos nosotros? Explicar a kubernetes:
- como queremos los pods: A través una plantilla de Pod: PodTemplate
- cuantos queremos 

Existen 3 objetos en Kubernetes que me permitan definir podTemplates:
- DEPLOYMENTS
    Plantilla de Pod + numero de replicas
    Quiero 17 pods con 1 contenedor de nginx, que pueda usar tanta memoria, que fuarde los datitos alli y que se arranque con esta configuración
- STATEFULSETS
    Plantilla de pod + plantilla de petición de volumen persistente + numero de replicas
- DaemonSet
    Plantilla de pod
        ¿cuantas replcias creará kubernetes desde esa plantilla? Tantas como nodos tenga el cluster.
        Nosotros habitualmente no creamos daemonsets...

---
Volumen persistente en kubernetes? pv - persistentvolume
Es una configuración de un emplazamiendo donde poder almacenar datos persistentemente                               VOLUMEN PERSISTENTE KUBERNETES
    Yo puedo tener un volumen alquilado en amazon, para guardar información: ID: vol-051adb5ddf872a12b          <<< Referencia a este emplazamiento
    Yo puedo tener una carpeta compartida en un NFS: minfs.empresa.es:///datos1                                 <<< Referencia a este emplazamiento
    Yo puedo tener una LUN de una cabina de almacenamiento: LUN: 1927462826                                     <<< Referencia a este emplazamiento
    
Cuando una app (proceso corriendo en un contenedor) quiere disponer de un sitio donde guardar datos, puede (Y DEBE)
hacer una petición de volumen persistente - pvc - persistent volume claim

en un pvc, que pensais que definimos?
Quiero montar un MariaDB ... y necesito un sitio para guardar datos... soy el tio que está montando el mariadb y que necesita guardar alli datitos..
Hago mi pvc (petición de volumen persistente)... que pongo allí dentro?
- Tengo yo puta idea de donde se van a guardar los datos? AWS, GCP, Azure????   NO
- Me interesa saberlo?                                                         Ni lo más minimo

Que me interesa a mi??? que pido?
- Tamaño: Dame 300 Gbs
- Velocidad: Rapidito !!!!            Lento !!!!
- Redundancia: Mucha, poca


De quien es problema el DONDE realmente se guarda el dato? Infraestructura (admin del cluster de kubernetes)

El administrador del cluster tiene que crear: 
1º Crear el volumen real en el backend adecuado (cabina, nfs, aws)
2º Registrarlo en Kubernetes (crear un pv)

Quien vincula el pv y el pvc? Kubernetes

PV y PVC a proori no llevan vinculación explicita... Es kubernetes quién los une.


Opción 1:
El desarrollador hace un pvc y entonces el admin del cluster crea el pv. 
Nos mola? No mucho... por no decir NADA DE NADA.
    Por qué? Para ya !!!! Mal asunto si tengo que esperar al admin
  NO VALE !!!!!!
  
Opción 2: 
El admin crea un pool de PVs... Un montón de pvs... En amazon y los registra en Kubernetes
Según los desarrolladores piden, kubernetes vincula a ese pvc, un pv compatible
  VALE Y DE HECHO SE HA USADO MUCHOS AÑOS. 
  Pero tienen un problemilla -> Desperdicio de recursos

Opción 3:
Montar un provisionador automatico de volumenes persistentes:
Programa que esciucha todas las pvcs quee están haciendo en kubernetes y generando pvs (y voluemenes físicos) para satisfacerlas
Esto lo montan los administradores.

PVs Precreados:                                     PVC
PV 1 _ AWS redundante 10Gbs                             
PV 2 _ AWS redundante 100Gbs.      <<<<<           PVC1 - 35 Gbs redundantes
PV 3 _ AWS no redundante 35Gbs


Voy a la tienda y necesito guardar 2Tbs de datos... Y le digo al de la tienda: Dame unn disco para guardar al menos 2 Tbs de datos.
No tengo de 2Tbs... Tengo de 4 Tbs... Me vale? Espera.. Me da medio disco... y le deja el otro media al otro que venga después?


PodTemplate -> Contenedor > guardar datos > PVC
    VVV
Kubernetes
    Pod1 <> PVC17      <kub>      PV33 <>  Volumen 17826734781

Que pasa en un momento si el Pod1 muere, y genero otro Pod2 en su lugar
    Pod2 <> PVC17      <kub>      PV33 <>  Volumen 17826734781
    
PV y PVC es separación de roles (responsabilidades)
- PVC: Desarrollador
- PV:  Administrador



---


Quiero montar un Wordpress CMS: Quiero una pagina WEB nueva en mi SITIO WEB
                                Los metadatos de esa página web donde se almacenan? BBDD (MySQL)
                                Y si subo una imagen17, para que vea en mi página web (Apache)

PodTemplate web <> PVC Apache           ----> DEPLOYMENT
    Pod C1: Apache <> PVC Apache
    Pod C2: Apache <> PVC Apache
    Pod C3: Apache <> PVC Apache
        requiere de un sitio donde tener datos persistentes? SI
    Y si el día de mañana quiero 2 apaches (escalo)
        Cada apache tendrá su propio volumen o comparten volumen?   Deberían compartirlo

PodTemplate db <> Plantilla PVC MySQL   ----> STATEFULSET
    Pod C1: MySQL  <> PVC1 MySQL
    Pod C2: MySQL  <> PVC2 MySQL
        requiere de un sitio donde tener datos persistentes? SI
    Y si el día de mañana la quiero escalar?
        Cada mysql tendrá su propio volumen o comparten volumen?    Cada uno su volumen? Cada POD NECESITA SU PROPIO PVC



Cliente del web     >  Navegador    >   Balanceador     >   Apache 1 > Imagen17 \ Volumen persistente compartido
Ramontxu                                                >   Apache 2            /
Pepinho             >  Navegador    

Base de datos MYSQL
    Standalone: 1 instancia levantada - volumen1
        Esto me permite tener HA.  En la práctica y en Kubernetes SI !
        Esto me da escalabilidad? NO 
    Modo Replicación:
        1 instancia maestra levantada
        1 replica                      << Esta atiende peticiones? Depende... si las atiende (que será en función de la BBDD)
                                                                    Serán de consulta, no de actualización
                                                                    No le puedo lanzar un insert 
                                                                    Solo un select
        Esto me da HA?             Si. Si la primaria se cae, la secundaria toma el papel de primaria.
        Esto me da escalabilidad?  Puede que un poquito
    Cluster:
        N instancias levantadas, todas leyendo y escribiendo.
        Cada una (de las 3 que tengo) tiene su propio almacenamiento o lo comparten? Cada una el suyo
        
        Instancia 1 Mysql
                            Dato1   Dato2
        Instancia 2 Mysql
                            Dato1           Dato3
        Instancia 3 Mysql
                                    Dato2   Dato3
                                    
        Todos los sistemas de almacenamiento el cluster trabajan así.
            BBDD: MariaDB, Oracle, MySQL, SQL Server, PostgreSQL
            Indexadores: ElastiSearch
            Sistemas de cache: REDIS
            Sistemas de mensajería: Kafka
            Estos sistemas van a requerir al menos 3 replicas para funcionar en cluster

Necesito un cluster activo/activo para tener HA?
                    activo/pasivo me da HA? SI 
    Tengo 2 instalaciones... Si la que opera falla, la retiro y activo la segunda (standby)

cómo montamos un cluster activo / pasivo en kubernetes? 
Cuantos pods necesito?  En kubernetes 1... Porqué? Por que se se cae ese, Kubernetes en autom hace una copia en otro sitio. 
                        No es necesario tenerla precreada
                        
----

Objetos de Kubernetes:

- Pods - conjuntos de contenedores
    - que tipo de conteendores se pueden lenvantar en los pods?
        que pueden ejecutar esos contenedores? DEMONIOS
    Opcionalmente, un pod puede llevar scripts que se ejecuten previamente a los demonios.... pero SIEMPRE LLEVAN DEMONIOS
- Jobs - Conjuntos de contenedores, pensados para ejecutar SCRIPTS o comandos
- Service 
    - ClusterIP     - Entrada DNS de kubernetes + IP de balanceo
    - NodePort      - Cluster IP + Puerto expuesto en todos los nodos que apunta IP de balanceo
    - LoadBalancer  - NodePort   + Configuración automatica de un balanceador externo
- Ingress           - Regla de configuración de un proxy reverso
- PodTemplates
    - Deployment    - Plantilla de pod + numero de replicas
    - StatefulSet   - Plantilla de pod + numero de replicas + plantilla de pvc  
    - Daemonset     - Plantilla de pod (en automatico se montan replicas en cada nodo del cluster)
- JobTemplate
    - CronJob       - Plantilla de Job + Cron 
- pvc   -   solicitud que hace un desarrollador de un volumen de almacenamiento
- configMaps / secrets 
    - Dar configuraciones de arranque a los pods (y por ende a los procesos que corren en ellos)
    - Inyectar ficheros en los pods (que puedan ser usados por los procesos que corren en ellos)
    * Nota: En el caso de los secrets, los valores se guardarán encriptados dentro de la BBDD de kubernetes (etcd)
- hpa   -   HorizontalPodAutoscaler - Explicarle a kubernetes cómo debe escalar los pods de un despliegue
                - Quiero tener entre 3 y 17 pods desde esta plantilla en función de CPU, Memoria... metricas
---
node
limitranges
resourcequotas
- pv    -   Referencia a un volumen de almacenamiento externo 


Todos los objetos los definiremoen en ficheros: YAML


Demonios es lo unico que quiero ejecutar en un entorno de producción?
Podemos querer ejecutar procesos batch... Scripts... por ejemplo:
- Backup de una BBDD ??? Hace falta? o ya tengo redundancia en los datos? MySQL
- ETL -> Datawarehouse

Esos procesos donde van a ejecutarse en mi entorno de producción? 
    En un contenedor? SI, por qué? POR QUE SI. TODO EN CONTENDORES !!!!!
    En un pod? NO, por qué?
        POD -> backup --> cuando acabe que piensa kubernetes? que hay que levantarlo de nuevo... Otro backup? Y otro? Y otro?
    En un JOB

Cuantos Jobs vamos nosotros a crear en Kubernetes? NINGUNO !!!!
Quien va a crear los Jobs? Kubernetes
Qué crearé yo en Kubernetes? 