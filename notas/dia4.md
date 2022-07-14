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