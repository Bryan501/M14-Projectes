# Pràctica sobre la utilització del "docker swarm" mitjançant l'arxiu "GET STARTED DOCKER SWARM"

## Pas1: Configuració

En aquesta pràctica farem servir 3 ordinadors per fer les probes de les comandes amb "docker swarm"

## Pas2: Crear una Swarm

Escollirem la màquina que volem ferla com principal, l'anomenem Manager. Amb el Manager farem les següents comandes:

Manager
```bash
docker swarm init --advertise-addr <LA-NOSTRA-IP>
docker info
docker node ls
docker swarm join-token worker
docker swarm join-token manager
```
Crear el swarm, es generen els tokens necessaris per afegir nodes com a workers i com a managers.

## Pas3: Afegirem nodes a la Swarm

Amb els altres 2 ordinadors restants, els que no són Manager, ficarem la següent comanda que ens a generat el Manager "docker swarm init...", ja que aixins podrem connectarnos a la seva Swarm:

Worker1 Worker2
```bash
docker swarm join --token SWMTKN-1-0rmourpqssmmmru7zr2jlcpkcrmlq9an0vhlxw3xi3ntrniovn6-2fl8psdifv59bprsef303h7z4 192.168.1.50:2377
```
Comprovem els nodes:

Manager
```bash
docker node ls
```

## Pas4: Servei Deploy

En el manager crearem replicas amb aquests continguts:

Manager
```bash
docker service create --replicas 1 --name helloworld alpine ping docker.com
```
## Pas5: Inspeccionem els serveis

Comprovem els serveis que hem fet abans:

Manager
```bash
docker service ls
docker service ps helloworld
docker service inspect --pretty helloworld
docker service inspect helloworld
```

## Pas6: Canvi d'escala

Escalarem les tasques. Escalar un servei pot ser útil per gestionar més càrrega, millorar la disponibilitat o equilibrar la càrrega entre diferents nodes en un clúster de Docker Swarm:

Manager
```bash
# docker service scale <SERVICE-ID>=<NUMBER-OF-TASKS>

docker service scale helloworld=5
docker service ps helloworld
```

En cada node podrem veure les tasques escalades:
```bash
docker ps
```

## Pas7: Eliminar els serveis

Manager
```bash
docker service rm helloworld
docker service ls
docker ps
```

## Pas8: Actualitzacions en curs

Crearem un servei anomenat "redis" amb tres rèpliques basades en la imatge "redis:3.0.6" i un retard d'actualització de 10 segons a Docker Swarm:

Manager
```bash
docker service create --replicas 3 --name redis --update-delay 10s redis:3.0.6
docker service ps redis
docker service inspect --pretty redis
docker ps
```

Ara es desplegarem un nou servei anomenat redis basat en la imatge redis 3.0.6. Cada 10 segons docker comprova si hi ha actualitzacions a fer en el desplegament. Observeu que si en el worker no hi havia la imatge redis descarregada els primers intents han fallat.

Manager
```bash
docker service update --image redis:3.0.7 redis
docker service inspect --pretty redis
docker service ps redis
docker ps
docker service rm redis
```

Si en fer una actualització queda en pause degut a algun problema en la actualització, es
pot reanudar amb l’ordre:

Manager
```bash
docker service update redis
```

## Pas9: Drain/pause del node

Drain/pause del node posarà el node en un estat on ja no es programaran noves tasques (contenidors) en aquest node específic:
Manager
```bash
docker node ls
docker node
docker service create --replicas 3 --name redis --update-delay 10s redis:3.0.6
docker service ps redis
docker node update --availability drain worker1
docker node inspect --pretty worker1
docker service ps redis
docker node ls
```
Confirmem el Drain amb el:
```bash
docker node inspect --pretty asus
```

Podem posar un node que estava active a estat drain, això fa que no accepti tasques i que se li eliminin les que executava passant-les a un altre node. Atenció, es tracta de tasques el swarm, el host pot executar tranquil·lament containers amb docker run i amb docker-compose.

Podem tornar a activar el node fent en el manager:
```bash
docker node update --availability active worker1
docker node inspect --pretty worker1
docker service ps redis
docker node ls
docker service rm redis
```

Pausar un node fa que no acceti moves task però continua executant les que tenia
assignades.

## Pas10: Utilitzeu la malla d'encaminament en mode swarm

Per utilitzar la xarxa d'entrada al Swarm, heu de tenir oberts els ports següents entre els nodes del Swarm abans d'habilitar el mode Swarm:

● Port 7946 TCP/UDP per a la descoberta de xarxes de contenidors.
● Port 4789 UDP per a la xarxa d'entrada de contenidors.

També heu d'obrir el port publicat entre els nodes la Swarm i qualsevol extern de recursos, com ara un equilibrador de càrrega extern, que requereixen accés al port.

Crear un servei que publica el port 8080:
```bash
docker service create --name my-web --publish published=8080,target=80 --replicas 2 nginx
```
Per publicar un port per un servei ja definit:
```bash
docker service update \
--publish-add published=<PUBLISHED-PORT>,target=<CONTAINER-PORT> \
<SERVICE>
```

En una xarxa ingress routing mesh es pot accedir a qualsevol dels nodes i accedir al servei amb independència de si el node extà o no executant la tasca en concret. podem accedir via:
```html
http://ip-manager:8080
http://ip-worker1:8080
http://ip-worker2:8080
```

--Es mostrarà el servidor nginx--

Podem fer drain d’un dels node i verificar que usant la seva adreça ip encara respon al
servei nginx:
```bash
docker node update --availability drain worker1
docker service rm my-web
```

## Publicació d'un port només per a tcp o només per a udp

Només TCP
```bash
docker service create --name dns-cache --publish published=53,target=53 dns-cache

docker service create --name dns-cache -p 53:53 dns-cache
```

Només TCP i UDP
```bash
docker service create --name dns-cache --publish published=53,target=53 --publish published=53,target=53,protocol=udp dns-cache

docker service create --name dns-cache -p 53:53 -p 53:53/udp dns-cache
```

Només UDP
```bash
docker service create --name dns-cache --publish published=53,target=53 protocol=udp dns-cache

docker service create --name dns-cache -p 53:53/udp dns-cache
```

## Evitar la malla d'encaminament

Per evitar la malla d'encaminament, heu d'utilitzar el servei de publicació llarga i establir el mode d'allotjament. Si ometeu la tecla de mode o la configureu com a entrada, es fa servir la malla d'encaminament.

```bash
docker service create --name dns-cache --publish published=53,target=53 protocol=udp,mode=host --mode global dns-cache
```

Usant mode=host no s’aplica per el port indicat el routing mesh sinó que s'accedeix directament al port del host/node al que s’accedeix (pot ser que el servei el port tingui un task que hi escolta o no).