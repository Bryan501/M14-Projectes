![](utils/images/portada.svg)

# INDEX

- **[Introducció](#Introducció)**

    - **[Què és una API en REST?](#API en REST?)**

    - **[Com es vincula REST amb HTTP](#vincula REST amb HTTP)**


    - **[AJAX](#AJAX)**

    - **[IQuery](#IQuery)**

    - **[JSON](#JSON)**

- **[Codi](#Codi)**

# INTRODUCCIó<a name="Introducció"></a>

## 1. Què és una API en REST?<a name="API en REST"></a>

<ins>Interaccions d'una API en REST</ins><br /><br />
L'any 2000 gràcies a la tesi de Roy Thomas Fielding, s'imposa una nova arquitectura per aprofitar el protocol HTTP en l'ambit de desenvolupament d'aplicacions distribuïdes a través de la xarxa. <br />
Aquesta arquitectura s'anomena REST o RESTful la qual va substituir a arquitectures com SOAP o XML-RCP.<br /><br />

Un servidor web REST ha de satisfer sis restriccions:

- **Rendiment**. 
- **Escalabilitat**.
- **Simplicitat**.
- **Modificabilitat**.
- **Portabilitat**.
- **Fiabilitat**.<br />

<ins>Conceptes claus</ins><br />

Per poder entendre millor que és, amb quins elements està construït i com funciona una API en REST, necessitem tenir en compte alguns conceptes claus:
- **Client-Server**.La comunicació entre client i servidor no requereix que el servidor hagi de guardar informació del client entre peticions consecutives.

- **Uniform Interface**.És una part fonamental del servei Rest. El que fa és definir la interfície entre el client i el servidor. <br />
Té quatre principis:
    - **Identificació dels recursos**<br />
Els recursos individuals són identificats en les peticions mitjançant els URI o URL.

    - **Manipulació dels recursos**<br />
Un client mentre tingui permisos i mitjançant la representació d'un recurs, té informació per modificar i esborrar el recurs del servidor.

    - **Missatges autodescriptius**<br />
Cada missatge intercanviat entre el client i el servidor conté la informació necessària per processar-lo.

    - **HATEOAS** (Hypermedia As The Engine Of Application State)<br />
El client interactua amb el servidor per complet mitjançant hipermèdia proporcionada dinàmicament per aquest segon.

- **Stateless**.La comunicació entre client i servidor no requereix que el servidor hagi de guardar informació del client entre peticions consecutives. 

- **Cacheable**.Les respostes del servidor poden ser guardades en una memòria cache, de manera implícita, explícita o negociada.<br />
Amb això aconseguim minimitzar-les interaccions entre client i servidor, fent que el client pugui accedir al recurs guardat en cache i millorant l'escalabilitat i rendiment del sistema.

- **Layered system**.El client no necessàriament rep connexió directa amb el servidor final, ja que poden existir sistemes de programació o maquinària entre ells.<br /> 
Per exemple, hi pot haver un servidor intermedi que guardi en cache les respostes del servidor. <br />
Aquests sistemes i maquinària situats entre el client i el servidor final poden ajudar a millorar les polítiques de seguretat del sistema.

- **Conde on Demand**.El servidor, de manera temporal, pot decidir ampliar la funcionalitat del client, transferint-li un codi i executant aquesta lògica.

## 2. Com es vincula REST amb HTTP<a name="vincula REST amb HTTP"></a>
- Hi han dos metodes per poder fer peticions a un servidor:
    - Metode per HTTP
        - GET
            - Per demanar dades d'un recurs específic. Per exemple: URI, ENDPOINT(API REST)
            - No pots modificar les dades del servidor.
            - Es poden interceptar per l'URL.
        - POST
            - Recull dades d'un servidor i alhora deixa en la mateixa petició crear o actualitzar un recurs del servidor.
            - Les dades queden definides en la petició AJAX.
            - No es poden interceptar per l'URL, per tant, és més segur que GET.
        - PUT
            - Envia dades a un servidor per tal de crear o actualitzar un recurs.
            - Permet repetir una mateixa petició POST a diferents parts del nostre codi.

        - DELETE
            - Esborra un recurs determinat.
        <br />
    
    - Metode amb AJax<br /> 

        - XMLHttpRequest
            - És l'element més important d'AJAX fet en JavaScript el qual actualitza una pàgina web sense haver de recarregar la pàgina sencera. Quan envia dades al servidor, ho fa en segon pla (background).<br /> 
            Una vegada la pàgina s'ha carregat:
                - Fa una petició i rebuda de dades en un servidor.  

        - Funcionament entre client-Server
            1. Un usuari o usuària realitza una recerca a Google.
            2. El client (Google) envia una petició "HTTP request" a la web.
            3. El servidor web rep la petició.
            4. El servidor executa l'aplicació que processa la petició. 
            5. El servidor retorna una resposta "HTTP responese" (output) al client.
            6. El client rep la resposta.


<br/><br />

## 3. AJAX<a name="AJAX"></a>

AJAX o també dit **Asynchronous JavaScript And XML** és una tecnologia web que permet l'actualització parcial de contingut en una pàgina sense necessitat de recarregar-la per complet.<br />
Utilitza JavaScript per enviar i rebre dades asíncrones amb el servidor, el que millora la velocitat i l'experiència de l'usuari.<br />
Les dades asíncrones es refereixen a la manera com la informació es transfereix entre un client i un servidor sense haver d'esperar una resposta immediata, és a dir, que passin de manera independent i sense bloquejar altres accions de l'usuari a la interfície web.

Les aplicacions web dinàmiques l'utilitzen per fer les peticions i processar les respostes provinents del servidor REST en segon pla mentre els usuaris segueixen interactuant amb aquestes aplicacions.<br/>

Fa transport de dades tant a XML com via JSON. D'aquesta manera es poden fer aplicacions webs interactives que treballin amb multitud de recursos provinents d'API's externs i treballar amb la resposta d'una manera molt lleugera.<br />

Permet:
- Llegir dades d’un servidor web (una vegada la pàgina s’ha carregat)
- Actualitzar una pàgina web sense haver de recarregar la pàgina
- Enviar dades a un servidor web.<br /><br />

<ins>**Respostes de l'API**</ins><br />

Cada cop que com a client fem una nova petició, el servidor retorna una resposta que bé en conjunt amb unes propietats que donen informació sobre l'estat d'aquesta resposta.<br />
De les propietats que hi ha, les principals són dues: **readyState i status/statusText**.<br />

En el cas de la propietat readyState, els seus valors donen informació sobre l'estat de la crida, és a dir, en quin estat del procés es troba la crida.<br />
Els valors principals que pot prendre readyState són:
- 0 -> petició no inicialitzada
- 1 -> Connexió de servidor establerta
- 2 -> Petició rebuda
- 3 -> Petició en procés
- 4 -> Petició finalitzada i resposta llesta<br />

La propietat status conté els missatges HTTP de l'objecte XMLHttpRequest, el qual depenent de com hagi anat el procés de resposta de l'API cap a la petició d'AJAX, si ha estat un èxit o un fracs, mostrarà a les propietats status i readyState uns valors o uns altres.<br />

Si la resposta arriba exitosament, a la propietat status pot pendre dos valors: **200 i 201**.<br />
En el cas que la propietat pren el valor 200, vol dir que no hi ha hagut cap problema amb la resposta.<br />
Si pren el valor 201, vol dir que s'ha fet una petició amb el mètode POST, i que aquesta petició s'ha completat exitosament i s'ha creat un nou recurs.<br />

Si la resposta no arriba exitosament, pot ser que sigui per dos possibles motius. Que hi hagi algun error per part del client o per part del servidor.<br />

En cas de que l'error sigui per part del client, pot pendre els valors: **400, 401, 403 i 404**.<br />
Si pren el valor 400, informa que la petició no s'ha pot completar per un error de sintaxi.<br />
Si pren el valor 401, informa que l’autorització és necessària però errònia.<br />
Si pren el valor 403, informa que la petició és legal però el servidor la rebutja.<br />
Si pren el valor 404, informa que l'URL que s'ha indicat no la trobat.<br />

Si l'error ha sigut per part del servidor, pot pendre els valors: **500 i 503**.<br />
Si pren el valor 500, vol dir que hi ha hagut un error en el servidor.
Si pren el valor 503, informa que el servidor no està disponible.<br />


## 4. IQuery<a name="IQuery"></a>
Iquery és una "libreria de JavaScript" o "framework" que té la funció de facilitar la manipulació dels objectes de l'HTML. <br />
La API de IQuery ens facilita molt les coses ja que la seva API és acceptada per tots els navegadors.<br />
...

## 5. JSON<a name="JSON"></a>
JSON (JavaScript Object Notation) és un format lleuger d'emmagatzematge i intercanvi de dades el qual només és text amb sintaxis JS.


