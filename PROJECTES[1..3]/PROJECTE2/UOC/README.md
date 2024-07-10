## MongoDB
- Sistema de gestió de base de dades NoSQL, no utilitza el model relacional tradicional de base de dades.
- Emmagatzema dades en documents BSON dins de col·leccions.
- Altament escalable i flexible, permetent l'emmagatzematge de dades no estructurades o semi-estructurades.
- Útil per a aplicacions que gestionen grans quantitats de dades i requereixen un esquema de base de dades dinàmic.
## Node.js
- Entorn d'execució de JavaScript al costat del servidor.
- Construit dobre motor V8 de Google Chrome i utilitza un model d'E/S no bloquejant i orientat a esdeveniments, la qual cosa el fa eficient i estable
- Adequat per a aplicacions en temps real, com ara aplicacions de xat. 
- Es fa servir comunament amb frameworks com Express.js per facilitar el desenvolupament d'aplicacions web i API's
## MongoDB + Node.js
Quan es combinen MongoDB i Node.js, sovint s'utilitza el controlador oficial de MongoDB per a Node.js (anomenat "mongodb" a npm) per interactuar amb la base de dades MongoDB des de l'entorn de Node.js. Aquesta combinació és popular en el desenvolupament d'aplicacions web modernes, ja que permet l'ús de JavaScript en tots els nivells, des del frontend fins al backend i la base de dades.
## Proxy
Un proxy és un servidor intermig que actua com a intermediari entre un client i un altre servidor al realitzar sol·licituds en nom del client. El propòsit principal d'un proxy és controlar i facilitar la comunicació entre aquests dos extrems. Algunes funcions i usus dels proxies son:
- ***Accés a Internet***:
El proxy pot filtrar contingut, bloquejar llocs web no desitjats i registrar activitats de navegació.
- ***Anonimat i Privadesa***:
Alguns proxies, s'utilitzen per amagar l'adreça IP del client, proporcionant cert nivell d'anonimat mentre naveguen per Internet.
- ***Acceleració i Caché***:
Els proxies poden emmagatzemar en memòria cau els recursos sol·licitats, com ara pàgines web, imatges i fitxers, per accelerar l'accés a aquests recursos i reduir la càrrega en el servidor original.
- ***Seguretat***:
Els proxies també s'utilitzen per millorar la seguretat. Poden actuar com a "firewall" per filtrar i bloquejar trànsit maliciós abans d'arribar al servidor final.
- ***Balanceig de Càrrega***:
En entorns amb múltiples servidors, un proxy pot distribuir les sol·licituds entre aquests servidors per equilibrar la càrrega, assegurant una distribució eficient del trànsit.
- ***Accés a Contingut Restringit Geogràficament***
poden utilitzar-se per eludir restriccions geogràfiques.
- ***Registre i Auditoria***
Els proxies poden dur a terme funcions de registre i auditoria per fer un seguiment de les activitats de xarxa.

