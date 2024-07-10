# Imatge personalitzada de Python3 per fer un comptador de visites

Aquesta imatge de Docker està basada en Python i conté el procés de com fer un comptador de visites.

## Dockerfile

L'arxiu "Dockerfile" definirà els passos a seguir per a la construcció de l'imatge Docker.

## app.py

L'arxiu "Startup.sh" s'executarà mitjançant el "docker-compose.ymlkerfile" sense necessitat de fer totes les comandes des de adins del container. On es farà el següent:

-   Importar les biblioteques necessàries:

        time: Aquesta biblioteca proporciona funcionalitats relacionades amb el temps.

        redis: La biblioteca de Python per interactuar amb la base de dades Redis.

        Flask: El marc web utilitzat per crear l'aplicació web.
        
- Configurar l'aplicació de Flask:

        app = Flask(__name__): Es crea una instància de l'aplicació Flask.
        
- Establir la connexió amb Redis:

        cache = redis.Redis(host='redis', port=6379): Crea un objecte cache que es connecta al servidor 
        
        Redis fent servir l'amfitrió 'redis' i el port 6379.
    
- Definir una funció get_hit_count():

        Aquesta funció s'encarrega d'incrementar el comptador de visites a la pàgina.
        
        Realitza un intent d'incrementar el valor emmagatzemat a la clau 'hits' a Redis. Si hi ha un error de connexió, es reintenta fins a 5 vegades amb intervals de 0,5 segons.
        
        Retorna el valor actual del comptador 'hits'.

- Crear una ruta a l'aplicació Flask:

        @app.route('/'): Defineix la ruta principal de l'aplicació.

        La funció associada a aquesta ruta, hello(), obté el comptador de visites utilitzant la funció get_hit_count().
    
        La pàgina torna un missatge que inclou el comptador de visites a la pàgina.

## requeriments.txt

L'arxiu "requeriments.txt" s'utilitzarà per instal·lar directament les estructures que utilitzarem a la imatge.

## docker-compose.yml

L'arxiu "docker-compose.yml" defineix dos serveis: 
    Un per a l'aplicació web (fent ús del Flask) i un altre per a la base de dades Redis. 
    
    La secció "web" construirà un contenidor usant el Dockerfile al directori actual, exposarà el port 5000, muntarà el codi al contenidor, i establirà la variable d'entorn FLASK_ENV a "development". 
    
    Mentrestant, el servei "redis" utilitzarà la imatge predefinida "redis:alpine".

## Desenvolupament

Executem el nostre fitxer amb el docker-compose:
```bash
docker compose up -d
```

Verifiquem si el comptador de visites anar:
```bash
http://localhost:5000
```
Recarreguem la pàgina i veiem que els números se sumen, ja que comptarà com +1 visita.
També podem canviar el text en el app.py

Per últim comprovarem que passa si fem un -it:
```bash
docker exec -it repte9-redis-1 redis-cli
```
Veure les el nombre de visites:
```bash
> GET hits
```
Establir un nombre de visites:
```bash
> SET hits 3
```
Establir un usuari per a tu:
```bash
> SET name pere
```
Verificar el meu usuari:
```bash
> GET name
```
Sortir:
```bash
> EXIT/QUIT
```
Farem aquesta comanda si volem fer stop als containers, abans fets amb el compose:
```bash
docker compose down
```


