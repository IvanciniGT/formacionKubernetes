# Gestión de recursos

Se definen a nivel de un contenedor, dentro de un Pod.

Valores garantizados (requests)
    Asegurar unos mínimos. 
    Usados por el Scheduller para determinar el nodo, donde desplegar un pod.
        El scheduller no tienen en cuenta el uso real de recursos al hacer una asignación de un pod. 
        Solo lo comprometido.
    Es importante buscar una buena relación entre ellos. Por qué?
        Desperdicio de recursos.... especialmente sangrante: Debido al escalado HORIZONTAL
            Request     Uso Guay        Uso Ruinoso
            4Gbs        3.6Gbs          3.6Gbs
            4Cpus       90%             10%
            
Valores máximos (limits)
    Notas:
        cpu     Nos da un poco igual. Si en un momento no me pueden dar tanto, pues voy más lento. Nada más ocurre.
        memory  Si en un momento me paso de uso de memoria y kubernetes la necesita, 
                Kubernetes me cruje !!!!! (Reinicio del pod)
                Recomendación: Limit(memory) = Request(Memory)

Y podemos poner lo que nos de la gana al hacer un despliegue...??? Digamos: Quiero 200Gbs de RAM
Kubernetes me lo tira. A kubernetes se le habrán configurado unas quotas para mi:
    - LimitRange    . Limita los pods y contenedores del namespace
                        Tus pods no pueden usar más de 2Gbs de RAM y 3 CPUS
    - ResourceQuota - Limita el namespace
                        El total de tus pods no puede usar más de 20Gbs de RAM y 40 CPUs

# Gestión de volumenes

Se definen a nivel de Pod, y se montan en los contenedores.

Para que sirven?
- Persistencia de datos
    Tipos de volumenes: HostPath (Se usa poco), nfs, iscsi, Cloud
    Se realiza a través de un PVC. Que me ofrece? Que consigo al usar un pvc?
        Aislarme del tipo de volumen, a mi que soy desarrollo.
    Los de infra definen un PV < TIPO DE VOLUMEN
    Quien liga ambos conceptos PV <> PVC? Kubernetes
    PVC?
        - Tamaño
        - Caracteristicas del almacenamiento: StorageClass
        - Tipo de acceso al volumen (Lectura/Escritura - En exclusividad o no)
- Inyectar ficheros de configuración
    configMap secret 
- Compartir infomación entre contenedores
    emptyDir ( medium: Memory )


---

nginx 

elasticsearch

---

Queremos un deployment con nginx        √
Pod x 1
    initContainers
        clone repo
    Contenedor NGINX                    √
    
Vamos a inyectar el ficheros de configuración de nginx a través de un volumen:
/usr/share/nginx/html ---> /app         √

Vamos a crear un volumen < app
    -> Contenedor nginx /app
    
    
    datos_aplicacion
    clonador
    

 Cómo sabe Kubernetes si un Pod está en marcha:
    Si los procesos 1 de sus contenedores están corriendo
    
Probes:
- startUpProbe
    Prueba de que el comando inicial está arrancando satisfactoriamente
    Si falla??? Se tumba el pod y se recrea
    Si va bien? Pasamos a las pruebas de liveness
- livessProbe
    Prueba de que el proceso está corriendo y funcionando sin problemas
    Si falla?   Se reinicia el pod
    Si va bien? A la readiness Probe
    Esta prueba tiene una determinada peridodicidad
- readinessProbe
    Pruebas de que el proceso está listo para ofrecer servicio
    Si falla?   Se va a la livenessProbe
                Se quita el pod del balanceador (servicio)
    Si todo va bien?    
                Se da de alta el pod en el balanceador (servicio)
    Esta prueba tiene una determinada peridodicidad.
        Intentos: 3 -> NotReady

Nginx
Kubernetes solo miraba si el proceso de nginx está funcionando. Es suficiente?

curl localhost:80 -> RESPUESTA 200 --- Contenga "Soy el fichero de la web"
SmokeTest

nginx
    Ready -> curl va bien
    Live  -> si el proceso está en marcha... y nginx responde con algo

mysql
    backup en frio ----> ready? 
        Detener el contestar peticiones. No está ready
        
    Esta live.. SI... haciendo su backup... ya acabará y volverá a estar listo para atender a los clientes
    
    
Elastic de juguete
Elastic es una herramienta distribuida
Que se puede separar en nodos distintos componentes (funcionalmente diferentes)
Un elastic se monta en cluster: 3 nodos... que pueden hacer de todo (maestros, datos)


Nginx replica 1 nodo1
      replica 2 nodo2
      Esto es un sistema distribuido?   NO ... Tengo un cluster con redundancia


Elastic

nodo1   -> nodo2, nodo3.       nodo2 <> nodo3      
nodo2   -> nodo3, nodo1
nodo3   -> nodo1, nodo2

3 Pods????? en kubernetes? Noooop

Cuantos templates de pods montamos? 1 -> 3 replicas

Como los comunicaciones entre si? 

Cada replica de la plantilla de pod, que será un po, tendrá su propia IP.
Pondré la IP? NO... porque no se ni cual es
Pondre un fqdn.... De donde lo saco? Balanceador / Service

¿Cuantos service necesito? 1 para cada pod. > statefulSet

elasticsearch -> es1
                 es2
                 es3.  ???? Uno de los pos contestará
                 
                 
statefulSet
    - Que cada replica pueda tener su propio volumen, basado en una pvc propia, que se generará autom, desde una plantilla
    - Que cada replica tenga su propio servicio que la identifique en red.
