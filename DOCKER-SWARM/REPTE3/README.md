# IMATGE PERSONALITZADA PER FER PRÀCTICA AMB ELS NODES

En aquesta imatge es faran els exercicis i exemples de com utilitzar el docker swarm i docker nodes, on també podrem visualitzar tot mitjançant el visualitzer. 

# DOCKER-COMPOSE.YML

Aquest fitxer ".yml" descriu la configuració d'un servei de Docker Swarm que desplega tres serveis ("web", "redis", "visualizer") i utilitza restriccions de desplegament per limitar alguns serveis només a nodes amb rols de "manager", a més de definir límits de recursos com CPU i memòria per al servei "web".

```bash
version: "3"
services:
  web:
    image: bryan501/comptador23:latest 
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure
      resources:
        limits:
          cpus: "0.1"
          memory: 50M
    ports:
      - "80:80"
    networks:
      - webnet
  redis:
    image: redis
    ports:
      - "6379:6379"
    deploy:
      placement:
        constraints: [node.role == manager]
    command: redis-server --appendonly yes
    networks:
      - webnet
  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - "8080:8080"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints: [node.role == manager]
    networks:
      - webnet
  portainer:
    image: portainer/portainer
    ports:
            - "9000:9000"
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
    deploy:
      placement:
        constraints: [node.role == manager]
    networks:
      - webnet
networks:
  webnet:
```

# DESENVOLUPAMENT

### --INICIALITZEM EL SWARM--

Farem la següent comanda per iniciar el swarm:

Manager
```bash
docker swarm init

Swarm initialized: current node (sq39mxq48eoq0unghr4bc8sl0) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-4op98rh58p870teala8cwetppvd34g8zriwgqwb4v4weo8lsv0-6flk57jpacrgktm9h1jgrf8nm 192.168.1.123:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```
Per inserir el node(s) farem la comanda que ens ha sortit perquè pugui entrar:
Manager: i13
Worker1: i14

Verifiquem que s'ha connectat la màquina i14:
```bash
docker node ls
ID                            HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS ENGINE VERSION
x4hscvwl2xix6w0v53vvh41l2    i13       Ready   Active        Leader          24.0.7   
9zwkdvtlbt3d1i5t2lpt2ugiq    i14       Ready   Active                        24.0.2
``` 
Despleguem:

Manager
```bash
docker stack deploy -c docker-compose.yml myapp
Creating network myapp_webnet
Creating service myapp_portainer
Creating service myapp_web
Creating service myapp_redis
Creating service myapp_visualizer
```
Comprovem els processos:

Manager
```bash
docker stack ps myapp

ID             NAME                 IMAGE                             NODE      DESIRED STATE   CURRENT STATE            ERROR     PORTS
ysn4hesu1qd8   myapp_portainer.1    portainer/portainer:latest        Debian    Running         Running 23 seconds ago             
dq3s0axde6a1   myapp_redis.1        redis:latest                      Debian    Running         Running 14 seconds ago             
yufmpszf92fg   myapp_visualizer.1   dockersamples/visualizer:stable   Debian    Running         Running 12 seconds ago             
zmit1iuy32g2   myapp_web.1          bryan501/comptador23:latest       Debian    Running         Running 14 seconds ago             
txj6m60sjjes   myapp_web.2          bryan501/comptador23:latest       Debian    Running         Running 14 seconds ago  
a2jg9fld3j9k   myapp_web.3          bryan501/comptador23:latest       Debian    Running         Running 12 seconds ago 
```
També podem comprovar-ho amb el "Worker":

Worker
```bash
docker ps

CONTAINER ID   IMAGE                       	COMMAND              	CREATED     	  STATUS      	PORTS         NAMES
9183dadb75c4   bryan501/comptador23:latest  "python app.py"      	4 minutes ago   Up 4 minutes	80/ tcp       myapp_web.2.ymx5h3wkugdkmybyo6lx6xjlj
```
Si anem a aquest enllaç, podem veure com tots dos visualitzen com augmenten el nombre de visites de la pàgina cada vegada que s'actualitza la pàgina:

Manager i Worker
```html
http://localhost
```
# --COMANDES DOCKER NODE--

Fem que s'ha actualitzat la configuracio d'un node en el clúster:

N'hi han 3 valor de disponibilitat:

    * pause: Pausa el node
    * drain: Posa el node en mode drenatge, això significa que no es programaràn nous contenidors en aquest node, pero els contenidors en execució continuaràn executats.
    * active: Farà que el node es possi con execució una vegada estigui pausat.  

Manager:
```bash
docker node update --availability pause i14
docker node update --availability drain i14
docker node update --availability active i14
```
Es poden posar etiquetes dintre dels nodes i verifiquem, tot això només es pot si ets el Manager:

Manager:
```bash
docker node update --label-add jugador=messi i14

docker node inspect i14

  placement:
    constraints: [node.labels.jugador == messi ]

  placement:
    constraints: [node.role == manager]
```
