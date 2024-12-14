# PROGRAMACION WEB I - A
# CONSTRUCCION DEL PROYECTO
- Primero creamos una network
`docker network create net`
- Luego en el fichero sql, creamos el dockerfile
`docker build . -t data`
- Regresamos y construimos el servidor
`cd ..`
`docker build . -t server`
- Construimos los contenedores con la network referenciada
`docker run -p 8085:8085 --name miserver --network net -d server`
`docker run -p 3307:3306 --name midb --network net -e MYSQL_ROOT_PASSWORD=1234 -d data`
- La ubicacion del programa es en:
`http://localhost:8085/index.html`
