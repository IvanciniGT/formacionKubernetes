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



----
Asignación de recursos a conteendores

300Mi = Lo que antes eran 300Mb
        = 1024x1024 bytes
    Kibibytes
    Mebibytes 
    Gibibytes
300Mb
    Megabytes
    
1 Kilobyte = 1024 bytes... PUES NO !
1 kilobyte = 1000 bytes
1 Kibibytes = 1024 bytes

cpu: 0.5
cpu: 500m
        milicores

Eso es el equivalente a usar media cpu durante 1 segundo
Eso es el equivalente a usar 25% de 2 cpus durante 1 segundo



Sabe un desarrollador los recursos que necesita su app?
Asi debería ser... Cómo lo calculo?
JMeter < Estimación basada en una simulación

Esto solo depende del uso real de la aplicación
Monitorización

Importante es entender sobre todo en un kubernetes
que esos datos en valor absoluto valen poco

Escalado horizontal automatico-> Cluster
Si la CPU Está al 30% escala
Si la memoria está al 50% escala!

Lo más importante de estos valores es la relación entre ellos

El objetivo será calibrar una unidad de despliegue
para atender una determinada cantidad de trabajo X la que sea.

Calibrado de un pod:
1º Fijo una carga de trabajo X, la que quiera (400 peticiones paralelamente)
2º Calculo la memoria y CPU para esa carga de trabajo



                    TOTAL                         NO COMPROMETIDOS                  USO
                CPU         Memoria             CPU         Memoria             CPU         MEMORIA
Maquina 1       4               8                0             1
-Pod nginx      2               5                                               2             6    El nginx empezará a ir más lento
-Filebeat       2               2                                               2             2

Maquina 2       4               6                2             1        
-Pod nginx      2               5                                               2             2


A kubernetes el uso real de recursos se la trea al fresco
Solo le interesa lo comprometido


-Pod nginx      2               5       REQUESTS
                4               7       LIMITS  

-Filebeat       2               2       REQUEST



MySQL > Infinita!

A las BBDD cuando las arranco las configuro cuanta RAM pueden usar... 
- Valor absoluto
- Valor relativo a la disponible en el host

Lo primero que quiere es subir la BBDD entera a RAM
Después lo indices
Despues los planes de ejecución
Después los resultados de las queries
Pa que está entonces el HDD???  Persistencia

Uso de la RAM por parte de un programa:
Datos de trabajo ... efimeros               <   De qué depende la cantidad de datos de trabajo? Carga de trabajo
Cache            ... efimeros? No tanto     <   De qué depende la cantidad de datos de cache?   Tiempo

Cuando se sacan las cosas de una cache?
-   Cuando está llena ***********
-   Cuando está obsoleta (tiempo)



Si al final voy escalando... que me interesa en request memory cpu. 
VALORES ALTOS O BAJOS?

300Mi
1000m       200 peticiones

600Mi
2000m       400 peticiones

Memoria :                   300Mi
 Datos de trabajo           100Mi
 Cache                      200Mi
 
Pod 1 \             De uso de memoria cuanto tengo: 600Mi
Pod 2 /             Que va a pasar con sus caches? Cómo son sus caches? 
                        Me temo que en cuanto pase un poquitin de tiempo, IGUALES
                    Al final... cuanto espacio de RAM tengo disponible para trabajo?    200Mi
                    Pero si tuviera solo un POD el doble de grande... la cache sería del mismo tamaño.
                        Cuanto espacio de trabajo tendría aqui?     400 Mi
                    
                        
Cliente(s)              > Balanceador > Tomcat1-webapp (Gestion de expedientes) Exp1         > MySQL
                                        Tomcat2-webapp (Gestion de expedientes) Exp1         > MySQL
cliente A- Exp1> tomcat2
 


Contenedor1
    Nginx
        -> access.log... se puede llenar? dale tiempo... y verás
        SOLUCIÓN
            Rotado de logs
            Cuantos quiero (archivos):
            Con 2 me vale!
            log1..... cuando se llena 50Kbs
            log2..... cuando se llena 50Kbs
    
Contenedor2
    Filebeat
        access.log > ElasticSearch
        
    Podría hacer que esto... vaya como un tiro????
    Cual es el cuello de botella... El HDD
    Usar la memoria como si fuera HDD.