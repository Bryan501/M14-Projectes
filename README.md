# Scripts 2023-2024

## 2ASIX-M14

Llistat d'exercicis dels projectes fets a M14

per clonar el repositori:
```bash
git clone git@github.com:Bryan501/M06-AS-2.git
```
Per pujar els apunts:
```bash
git add . ; git commit -m "asd" ; git push origin master
```
Per pausar totes les imatges
```bash
docker stop $(docker ps -aq)
```
Per esborrar les imatges detingudes:
```bash
docker rm $(docker ps -aq)
```
Per esborrar les imatges:
```bash
docker rmi $(docker images -q)
```
Per esborrar les imatges forçadament:
```bash
docker rmi -f $(docker images -q)
```

