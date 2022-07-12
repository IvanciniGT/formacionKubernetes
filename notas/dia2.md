# Pod

Conjunto de contenedores, que:
- Comparten red, y dirección IP
- Pueden compartir almacenamiento
- Escalan juntos
- Se despliegan en el mismo host

Cuantos creamos en Kubernetes nosotros? NINGUNO 

Lo que nosotros hacemos es crear Plantillas de pod.

Que ejecutan dentro los pods? Contenedores.... que deben contener DEMONIOS... 
Si no? Kubernetes corriendo trata de reiniciarlos pensando que ha habido un problema

Opcionalmente, los pods pueden ejecutar initContainers, que dentro pueden ejecutar scripts o comandos.

# Pod templates

## Deployment

Plantilla de pod + numero de replicas

Todos los pods que se geenran desde un Deployment son identicos e intercambiables entre si.

## Statefulset

Plantilla de pod + numero de replicas + Plantilla PVC

Cada pod tiene su propia personalidad (por tener sus propios datos, almacenados en su propio volumen, sacado de su propia pvc)
Y no son intercambiables.

## DaemonSet

Plantilla de pod. Kubernetes genera una replica por cada nodo del cluster

# Jobs

Conjunto de contenedores, que:
- Comparten red, y dirección IP
- Pueden compartir almacenamiento
- Se despliegan en el mismo host

Cuantos creamos en Kubernetes nosotros? NINGUNO 

Lo que nosotros hacemos es crear Plantillas de jobs.

Que ejecutan dentro los jobs? Contenedores.... que deben contener SCRIPTS o COMANDOS... 

# JobTemplates

## CronJob

Plantilla de Job + cron

# Service

## ClusterIP

Entrada en el DNS de kubernetes que apunta a una IP de balanceo de carga.
Hay algo que no tengo aquí. GESTION DE COLAS !

## NodePort

Cluster IP + Puerto que se abre en todos los host del cluster y que redirige a la IP de balanceo.

No se usa en clusters de producción. Solo pruebas.

## LoadBalancer

NodePort + Gestión automatizada de un balanceador de carga EXTERNO (metallb)

Tendremos solo 1 en un cluster de producción: IngressController!!!! PROXY REVERSO

## Ingress

Regla de configuración de un proxy-reverso
    Nombre  |
    Puerto  |   >>>>> Backend
    Ruta    |
    

cliente ----> NGINX (proxy reverso)   --- IPBalanceo --->    apache 1 (wordpress) OFF (mantenimiento, actualización del Sistema)
                                                     --->    apache 2 (wordpress) OFF
                                                COLA DE ENVIO
                                                M3>M2>M1
                                                - Evitar sobrecarga del destinatario (apache)
                                                - Imaginad que Apache en un momento está OFF

Las apps que montamos hoy en día siguen en su mayor parte lo que llamamos una arquitectura Orientada a Servicios o Microservicios
YA NO HACEMOS APPs monoliticas... las hemos desterrado a Mordor!!!

Antes una app era una cosa enorme que hacia un güevon de cosas dentro. App linea oberta!!! > Servidor de apps gigante (Weblogic)
Estos nos da muchos dolores de cabeza.
1º Dentro una app hay muchas funcionalidades diferentes... y no todas se usan con la misma intensidad...
    Me gustaría tener control de la escalabilidad a nivel de cada funcionalidad
2º Mantenimientos / Actualizaciones.... Muy espaciadas en el tiempo.. poco ágiles

Hoy en día un sistema lo entiendo como la suma de las funcionalidades ofrecida por un conjunto grande de programas independientes

# PersistentVolume - Administrador (Provisionador dinámico de volumenes)

Una referencia a un volumen de almacenamiento externo

# PersistentVolumeClaim - Desarrollo

Solicitud de un almacenamiento:
- Espacio requerido
- Velocidad
- Redundancia