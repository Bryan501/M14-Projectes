# IMATGE PERSONALITZADA PER FER PRÀCTICA DEL DEPLOY

En aquesta imatge es faran els exercicis i exemples de com fer deploy de containers usant el docker stack i el service. 

# DOCKER-COMPOSE.YML

Aquest fitxer ".yml" descriu la configuració d'un servei de Docker Swarm que desplega tres serveis ("web", "redis", "visualizer") i utilitza restriccions de desplegament per limitar alguns serveis només a nodes amb rols de "manager", a més de definir límits de recursos com CPU i memòria per al servei "web".

```bash
version: "3"
services:
  web:
    image: bryan501/comptador23:latest 
    deploy:
      replicas: 2
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

Swarm initialized: current node (osdrq1omxy6lcpaq7fbv1o57k) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-0awk95arpumywhla2zswicxuc1apk9024t7o8d8hbaq5l3m8hd-1c9t2i0zbvmi6fjahy76l3fww 192.168.1.123:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
``` 
### --DESPLEGAMENT DE LES APLICACIONS--

Per desplegar aquesta aplicació amb Docker Stack, pots fer servir la següent comanda:

Manager
```bash
docker stack deploy -c docker-compose.yml myapp

Creating network myapp_webnet
Creating service myapp_portainer
Creating service myapp_web
Creating service myapp_redis
Creating service myapp_visualizer
```
Observem:
```bash
docker stack ps myapp

ID             NAME                 IMAGE                             NODE      DESIRED STATE   CURRENT STATE            ERROR     PORTS
ysn4hesu1qd8   myapp_portainer.1    portainer/portainer:latest        Debian    Running         Running 23 seconds ago             
dq3s0axde6a1   myapp_redis.1        redis:latest                      Debian    Running         Running 14 seconds ago             
yufmpszf92fg   myapp_visualizer.1   dockersamples/visualizer:stable   Debian    Running         Running 12 seconds ago             
zmit1iuy32g2   myapp_web.1          bryan501/comptador23:latest       Debian    Running         Running 14 seconds ago             
txj6m60sjjes   myapp_web.2          bryan501/comptador23:latest       Debian    Running         Running 14 seconds ago             
```
### --VISUALITZAR ELS SERVEIS--

Amb aquesta comanda veurem els diferents serveis que tenim actius:

Manager
```bash
docker stack services myapp 

ID             NAME               MODE         REPLICAS   IMAGE                             PORTS
83vhjzo271e3   myapp_portainer    replicated   1/1        portainer/portainer:latest        *:9000->9000/tcp
kcati3tw95en   myapp_redis        replicated   1/1        redis:latest                      *:6379->6379/tcp
pr3264oagfex   myapp_visualizer   replicated   1/1        dockersamples/visualizer:stable   *:8080->8080/tcp
p4pn5koc0f3l   myapp_web          replicated   2/2        bryan501/comptador23:latest       *:80->80/tcp
```
### --MODIFICACIONS--

Ja que tenim posada el deploy en el ".yml" podem fer modificacions al nombre de rèpliques que volem encara que estiguin enceses:

Manager
```bash
docker stack services myapp

ID             NAME               MODE         REPLICAS   IMAGE                             PORTS
qolajy0mih8g   myapp_portainer    replicated   1/1        portainer/portainer:latest        *:9000->9000/tcp
xkckfzv7jmgk   myapp_redis        replicated   1/1        redis:latest                      *:6379->6379/tcp
xw7yfoqtghz1   myapp_visualizer   replicated   1/1        dockersamples/visualizer:stable   *:8080->8080/tcp
tg9ydbibcdw4   myapp_web          replicated   2/2        bryan501/comptador23:latest       *:80->80/tcp
```
Farem la modificació en el .yml on la rèplica del myapp_web seran 3 (També podem tornar-ho a 2):

Manager
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
```
Llavorans farem la mateix ordre una altre vegada:

Manager
```bash
docker stack deploy -c docker-compose.yml myapp

Updating service myapp_visualizer (id: xw7yfoqtghz13aod50hjh8oie)
Updating service myapp_portainer (id: qolajy0mih8gxy0p9zmmdl46w)
Updating service myapp_web (id: tg9ydbibcdw47lhq1qt0jcdpe)
Updating service myapp_redis (id: xkckfzv7jmgkzsunr0ffe0giq)
```
Verifiquem la modificació:
```bash
docker stack services myapp

ID             NAME               MODE         REPLICAS   IMAGE                             PORTS
qolajy0mih8g   myapp_portainer    replicated   1/1        portainer/portainer:latest        *:9000->9000/tcp
xkckfzv7jmgk   myapp_redis        replicated   1/1        redis:latest                      *:6379->6379/tcp
xw7yfoqtghz1   myapp_visualizer   replicated   1/1        dockersamples/visualizer:stable   *:8080->8080/tcp
tg9ydbibcdw4   myapp_web          replicated   3/3        bryan501/comptador23:latest       *:80->80/tcp
```
### --ESCALAR ELS SERVEIS--

També podem escarlar els serveis perquè, ens permet millorar la disponibilitat, la tolerància a fallades i la capacitat de gestió de càrrega del servei, ja que es distribueix la càrrega entre múltiples instàncies que poden respondre a les sol·licituds dels usuaris, millorant la capacitat de resposta del sistema i reduint la sobrecàrrega en cas de picos d'ús:

```bash
docker service scale myapp_web=4

myapp_web scaled to 4
overall progress: 4 out of 4 tasks 
1/4: running   
2/4: running   
3/4: running   
4/4: running   
verify: Service converged 
```
Verifiquem:
```bash
docker ps
CONTAINER ID   IMAGE                             COMMAND                  CREATED          STATUS          PORTS                          NAMES
133d0dcbb37a   bryan501/comptador23:latest       "flask run"              31 seconds ago   Up 29 seconds   5000/tcp                       myapp_web.4.n5axarcpp5evmn8ejq3bwggz2
7bd8071253ed   bryan501/comptador23:latest       "flask run"              31 seconds ago   Up 29 seconds   5000/tcp                       myapp_web.3.v42jkntfja6988wpt5ql30gvy
c09d8c9eee4f   portainer/portainer:latest        "/portainer"             9 minutes ago    Up 9 minutes    8000/tcp, 9000/tcp, 9443/tcp   myapp_portainer.1.xtpgpdz8pkrb6v4zeswsf6ld4
2b594caefa70   dockersamples/visualizer:stable   "npm start"              9 minutes ago    Up 9 minutes    8080/tcp                       myapp_visualizer.1.umca5r3lgnz2x4ilrsny36wgg
f47427f6babe   redis:latest                      "docker-entrypoint.s…"   9 minutes ago    Up 9 minutes    6379/tcp                       myapp_redis.1.lf2nrth27ynfcrk66u9rk0m9a
4db453bdbe75   bryan501/comptador23:latest       "flask run"              9 minutes ago    Up 9 minutes    5000/tcp                       myapp_web.1.vuydap5patwt5c10wolsqvuso
cd110f4492ac   bryan501/comptador23:latest       "flask run"              9 minutes ago    Up 9 minutes    5000/tcp                       myapp_web.2.u848natj9f7hyvwa76z7jqqkc
4c7364f95024   617dd3c6b750                      "docker-entrypoint.s…"   4 weeks ago      Up 43 minutes   5432/tcp                       mi-postgres
60372c9878fe   b5cec1739340                      "entrypoint.sh php -…"   4 weeks ago      Up 43 minutes   0.0.0.0:8080->8080/tcp         mi-adminer
```
### --ESBORRAR ELS SERVEIS--

Una vegada volem esborrar els servies farem el següent:

Manager:
```bash
docker stack rm myapp

Removing service myapp_portainer
Removing service myapp_redis
Removing service myapp_visualizer
Removing service myapp_web
Removing network myapp_webnet
```
I parem els contenidors:
```bash
docker stop $(docker ps -aq)
```
Podem veure tot el que passa també mitjançant el "visualizer" o el "portainer":
```bash
http://localhost:5000
http://localhost:9000
```
Deixem el clúster Swarm:
```bash
docker swarm leave -f
```



