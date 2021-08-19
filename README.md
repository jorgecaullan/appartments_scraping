# Buscador de departamentos

Buscador de departamentos a partir de ciertos filtros con la finalidad de analisis de datos

## Dependencias

* docker-compose
* docker-engine

## Instalación

NOTA: Los mismos pasos pueden ser imitados para instalarlo en un servidor externo (personalmente yo uso el droplet más barato de digital ocean y no tiene ningún problema de rendimiento).

### Guardar un environment propio

1. Copiar el archivo `.env.example` y renombrarlo a `.env` (mantenerlo en el root del proyecto)
2. Abrirlo con tu editor de codigo perferido y modificar las siguientes variables de entorno:
   * `MASTER_PASSWORD`: Clave que se pedirá al abrir la aplicación desde un nuevo dispositivo (se recomienda una clave extensa con letras mayusculas y minusculas, digitos y simbolos). Pensada para poder subir la aplicación a un servidor publico y asi ingresar desde cualquier dispositivo.
   * `POSTGRES_USER`: Usuario de la base de datos (a gusto).
   * `POSTGRES_PASSWORD`: Password de la base de datos (a gusto, pero se recomienda generar un hexagesimal seguro).

### Ejecutar docker

Posicionarse en el root del proyecto, junto al .env guardado anteriormente y ejecutar:

`docker-compose up`

y esperar hasta ver un mensaje como el siguiente

```sh
=> Booting Puma
=> Rails 5.2.6 application starting in development 
=> Run `rails server -h` for more startup options
Puma starting in single mode...
* Version 3.12.6 (ruby 2.5.1-p57), codename: Llamas in Pajamas
* Min threads: 5, max threads: 5
* Environment: development
* Listening on tcp://0.0.0.0:3000
Use Ctrl-C to stop
```

NOTA: en caso de ejecutarlo en un servidor puedes agregar el argumento `-d` al final del comando, para ejecutarlo en background.

luego de eso (mientras la aplicación esta ejecutandose), en una nueva consola tendras que ejecutar las migraciones manualmente usando:

`docker-compose exec appartment_searchs rake db:migrate`

Finalmente podrás ingresar mediante el navegador a <http://localhost:3000>, donde se pedirá la `MASTER_PASSWORD` que se definio en las variables de entorno.

### Ejecutar scrapping de departamentos

#### En localhost

Ya teniendo un listado con los filtros de departamentos que coincidan con lo que quieres, puedes manualmente ejecutar un task creado para atraer los departamentos y guardarlos en tu base de datos. Solo se debe ejecutar:

`docker-compose exec appartment_searchs rake get_appartments`

Lo cual debera traer una respuesta del estilo:

```sh
"Getting appartments urls on Ñuñoa"
"Created /appartments/1"
"Created /appartments/2"
"Created /appartments/3"
"Created /appartments/4"
"Appartments createds: 4"
"Appartments skiped: 0"
"Analizing previous appartments"
"Not sold appartments found"
```

#### En un servidor publico

La aplicación permite que cada cierto tiempo (por defecto 6 hrs) se ejecute el codigo que hace scrapping a los filtros, para agregar nuevos departamentos, verificar los departamentos que se han vendido o que ya no coinciden con los filtros (subidas de precio u otros cambios en la publicación o en los mismos filtros).

Para ejecutar el cronjob se debe actualizar el crontab con el comando:
`docker-compose exec appartment_searchs whenever --update-crontab`

Y luego iniciarlo utilizando:
`docker-compose exec appartment_searchs service cron start`

en donde la respuesta esperada debiera ser:

```sh
[ ok ] Starting periodic command scheduler: cron.
```

NOTA: Si deseas cambiar el rango de horario en que se ejecuta el cronometro, se debiera detener el cronometro actual (`docker-compose exec appartment_searchs service cron stop`) modificar el archivo `/code/config/schedule.rb`, la linea en que dice `every 6.hours do` para ajustarlo al horario deseado y volver a ejecutar los comandos anteriores para actualizarlo y ejecutarlo.

## Uso

### Filtros

Para utilizar la aplicación de manera efectiva, el principal requerimiento es agregar filtros.

Para ello, en el navegador luego de haber ingresado la clave correcta, se debe ingresar a `Filtros` y seleccionar `New Filter`

Para crear un filtro se debe tener en cuenta que el scrapping lo unico que hace es leer la url y el nombre de la comuna del filtro, el resto de campos son unicamente informativos para reconocer facilmente cuales fueron los filtros que se utilizaron.

El campo `Url` debe obtenerse a partir de <https://www.portalinmobiliario.com> haciendo uso de los filtros nativos que ofrece la pagina. Se recomienda que no sea un filtro demasiado extenso de departamentos (+100 resultados) que coincidan con la busqueda para aprovechar al maximo las opciones de aprobar y rechazar departamentos.

En el campo `Comuna` no es necesario guardar el nombre de la comuna en si, el campo es un texto abierto, por lo que podria ser un barrio o cualquier nombre ojala no muy extenso para no romper la lista de departamentos.

### Visualización de departamentos

Luego de haber guardado los filtros y esperado a que se ejecutara el scrapping (o haberlo ejecutado manualmente `docker-compose exec appartment_searchs rake get_appartments`) todos los departamentos nuevos apareceran en el listado de departamentos. El cual tiene 2 versiones. Vista por listado (botones de la izquierda) y vista por mapa (botones de la derecha).

Cada uno tiene 4 estados de departamentos:

* Por analizar: Donde estaran todos los nuevos departamentos que coinciden con los filtros y estan disponibles. La vista esta pensada para ir viendo cada departamento (o rechazarlo en caso de parecer muy malo segun la data scrapeada), entrar al link de portal inmobiliario para ver las fotografias y decidir si aprobarlo o rechazarlo (en caso de rechazarlo se tiene la opcion de ingresar una razon de rechazo).
* Pre aprobados: Donde estaran todos los departamentos que hayan sido aprobados por alguno de los que estan utilizando la aplicación en tu servidor.
* Rechazados: Donde se encuentran todos los departamentos que han sido rechazados por ti o que dejaron de coincidir con los filtros.
* Vendidos: Donde apareceran todos los departamentos que ya fueron vendidos (al verlos en la lista se mostrará tambien despues de cuanto tiempo se vendieron según la fecha de publicación de portal inmobiliario)

#### Listado

El listado esta pensado prinsipalmente para tener una vision global de todos los departamentos que se estan analizando, donde se mostrará (por categoria) coloreado en rojo los peores y en verde los mejores entre todos los departamentos que hay a la vista.

Las categorias por defecto que apareceran coloreadas son `Costo total`, `Dormitorios`, `Baños` y `Superficie útil`.

#### Mapa

En caso de que tambien estes interesado en analizar los departamentos acorde a su ubicacion, tienes la opcion de ingresar a las vistas del mapa para ir filtrando mas a medida en los que estas interesado y los que no (ya sea por que estan muy lejos de un metro u otras razones).

NOTA: Se recomienda que manualmente se modifique el centro y zoom de las vistas de los mapas (`/code/app/views/appartments/index_map_*.html.erb`) para ajustarlo a las zonas donde buscas.

## Nota

El codigo aqui presente esta desarrollado únicamente para uso particular de cada uno y debe ser utlizado bajo tu propia responsabilidad.
