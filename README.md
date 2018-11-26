# AniBot

AniBot es un bot escrito en prolog al que le puedes preguntar cosas sobre
[Animes](https://es.wikipedia.org/wiki/Anime).

## Empezando

Para ejecutar el bot, debes correr ejecutar en la consola:

```bash
swipl -s AniBot.pl
```

El bot te responderá lo siguiente:

```bash
¡Hola! Mi nombre es Anibot
Se mucho sobre animes, pero puedo aprender por lo que me vayas pidiendo
¿Que necesitas?
>
```

## Preguntas que puede responder el bot

### Preguntar por animes de un género en específico

Para preguntar por animes de un género en específico, puedes intentar con las
siguientes preguntas:

_me gusta lista-de-generos_

Donde la lista-de-generos tiene la siguiente gramática:
```
lista-de-generos -> la <genero>, lista-de-generos
lista-de-generos -> el <genero>, lista-de-generos
lista-de-generos -> <genero>, lista-de-generos
lista-de-generos -> la <genero> y lista-de-generos
lista-de-generos -> el <genero> y lista-de-generos
lista-de-generos -> <genero> y lista-de-generos
lista-de-generos -> el <genero>
lista-de-generos -> la <genero>
lista-de-generos -> <genero>
```
donde \<genero> es cualquier cadena de caracteres que no tenga la ',' o la 'y'.

#### Ejemplos
```
>  me gusta el Shounen

Segun el género te podemos recomendar:

Shounen
 - Attack on Titan
 - Code Geass
 - Bleach
 - Full Metal Alchemist : Brotherhood
 - Dragon Ball
 - Akame ga Kill!
 - Noragami
 - Naruto
> me gusta el genero desconocido

Segun el género te podemos recomendar:

Lo siento no tengo información sobre generodesconocido
> me gusta el generodesconocido y Shounen

Segun el género te podemos recomendar:

Lo siento no tengo información sobre generodesconocido
Aventura
 - HunterXHunter
 - Attack on Titan
 - Pokemon
 - One Piece
 - Dragon Ball
 - Fairy Tail
 - Noragami
> me gusta el Shounen y la Aventura

Segun el género te podemos recomendar:

Shounen
 - Attack on Titan
 - Code Geass
 - Bleach
 - Full Metal Alchemist : Brotherhood
 - Dragon Ball
 - Akame ga Kill!
 - Noragami
 - Naruto
Aventura
 - HunterXHunter
 - Attack on Titan
 - Pokemon
 - One Piece
 - Dragon Ball
 - Fairy Tail
 - Noragami
```

### Preguntar por animes de un genero y ordenarlos

AniBot puede ordenar los animes de un género en orden descenciente o ascendiente
a partir del rating y la popularidad de cada uno. Para ello, debe preguntar de la
siguiente forma:

_muestrame animes de <genero> por popularidad_
_muestrame animes de <genero> por rating_
_muestrame animes de <genero> por popularidad y rating_
_muestrame animes de <genero> por rating y popularidad_

Se le puede añadir al final _creciente_ o _decreciente_ para especificar el orden.
Por defecto es _decreciente_. En caso de que se pregunte tanto por rating como por
popularidad, se suma ambas y se ordena el resultado.

#### Ejemplos
```
> muestrame animes de Shounen por rating

Shounen
 - Attack on Titan
 - Code Geass
 - Bleach
 - Full Metal Alchemist : Brotherhood
 - Dragon Ball
 - Akame ga Kill!
 - Noragami
 - Naruto
> muestrame animes de Shounen por popularidad

Shounen
 - Attack on Titan
 - Code Geass
 - Bleach
 - Dragon Ball
 - Akame ga Kill!
 - Noragami
 - Naruto
 - Full Metal Alchemist : Brotherhood
> muestrame animes de Shounen por rating y popularidad

Shounen
 - Attack on Titan
 - Code Geass
 - Bleach
 - Dragon Ball
 - Akame ga Kill!
 - Noragami
 - Naruto
 - Full Metal Alchemist : Brotherhood
```

### Filtrar por valor de rating y popularidad

Sea categoria entendida como:
- interesante -- rating entre 4 y 5
- normal      -- rating igual a 3
- aburrido    -- rating entre 1 y 2

popularidad como:
- muy poco conocido -- popularidad entre 1 y 2
- poco conocido     -- popularidad entre 3 y 5
- conocido          -- popularidad entre 6 y 7
- muy conocido      -- popularidad entre 8 y 9
- bastante conocido -- popularidad igual a 10

y no se puede usar categoria o popularidad en ambos casos. Si quiero preguntar
por animes con ciertos valores de popularidad y rating, se procede de la siguiente manera:

_quiero ver un anime <categoria|popularidad> y <categoria|popularidad>_

#### Ejemplos
```
> quiero ver un anime interesante y bastante conocido

Anime                                 Rating   Popularidad
Death Note                              4          10
Attack on Titan                         5          10
Code Geass                              5          10
One Punch Man                           5          10
Pokemon                                 5          10
> quiero ver un anime aburrido y bastante conocido

Anime                                 Rating   Popularidad
Hamtaro                                 2          10
> quiero ver un anime interesante y muy poco conocido

Anime                                 Rating   Popularidad
Full Metal Alchemist : Brotherhood      4          1
> quiero ver un anime aburrido y muy poco conocido

Anime                                 Rating   Popularidad
> quiero ver un anime normal y conocido

Anime                                 Rating   Popularidad
Dragon Ball                             3          7
Akame ga Kill!                          3          7
Noragami                                3          6
```

### Filtrar solamente por rating (y genero)

AniBot puede filtrar por un valor especifico de rating y genero (este ultimo
opcional). Para hacerlo, se le pregunta lo siguiente:

_cuales son los mejores rating?_
_cuales son los peores rating?_
_que animes tienen rating <rating>?_
_que animes del genero <genero> tienen rating <rating>?_
_cuales son los mejores rating del genero <genero>?_
_cuales son los peores rating del genero <genero>?_

donde <rating> es un numero del 1 al 5 y genero es una palabra sin espacios.

#### Ejemplos

```
> que animes tienen rating 7?

Disculpa, pero solo me han hablado de ratings entre 1 y 5. Intenta con uno de estos valores.
> que animes tienen rating 5?

Listado de animes con rating 5
 - HunterXHunter
 - Attack on Titan
 - Code Geass
 - One Punch Man
 - Pokemon
> cuales son los mejores rating?

Listado de animes con rating 5:
 - HunterXHunter
 - Attack on Titan
 - Code Geass
 - One Punch Man
 - Pokemon
> cuales son los peores rating?

Listado de animes con rating 1:
 - Naruto
> que animes del genero Shounen tienen rating 1?

Listado de animes con rating 1
 - Naruto
 ```

### Filtrar solamente por popularidad

Se le puede preguntar fácilmente animes con cierta popularidad:

_cuales son los mas populares?_
_cuales son los menos populares?_
_que animes son poco conocidos?_
_que animes son conocidos?_
_que animes son muy conocidos?_

El significado de cada frase es análogo al de la sección _Filtrar por valor de rating y popularidad_.

#### Ejemplos
```
> cuales son los mas populares?

Listado de animes bastante conocidos:
 - Hamtaro
 - Death Note
 - Attack on Titan
 - Code Geass
 - One Punch Man
 - Pokemon
> cuales son los menos populares?

Listado de animes muy poco conocidos:
 - Full Metal Alchemist : Brotherhood
```
(no me cuadra que Full Metal Alchemist sea muy poco conocido, pero ok).

### Preguntar por un anime específico

Anibot te puede dar detalles sobre un anime en específico, para ello
debes preguntarle lo siguiente:

_conoces sobre <anime>_

_Nota_: El anime puede ser cualquier cadena separada por espacios, pero
si el título del anime contiene caracteres especiales (.:*!?) debera espaciarlos.
Ejemplo: Akame ga Kill !

Anibot buscará en la base de datos del conocimiento un anime con ese nombre.
Pueden ocurrir los siguientes dos casos:

#### Lo consigue

En este caso AniBot te va a dar todos los detalles
que conozca sobre el anime

##### Ejemplo

```
> conoces sobre Dragon Ball

Si, esto es lo que se sobre Dragon Ball
Tiene rating 3, popularidad 7 y su genero entra en Shounen, Aventura
> conoces sobre Naruto

Si, esto es lo que se sobre Naruto
Tiene rating 1, popularidad 5 y su genero entra en Shounen
> conoces sobre Akame ga Kill !

Si, esto es lo que se sobre Akame ga Kill !
Tiene rating 3, popularidad 7 y su genero entra en Accion, Drama, Fantasia, Shounen
```

#### No lo consigue

¡AniBot puede aprender sobre tu anime! En caso de que no consiga tu anime en
la KD (Knowledge Database), te pedira los datos del mismo
para guardarlo. La popularidad es opcional, si no se especifica se deja en 1.

##### Ejemplo

```
> conoces sobre Mi Anime desconocido

Lo siento, no conozco el anime: "Mi Anime desconocido"
Pero si me das informacion adicional, lo puedo tomar en cuenta para la siguiente :)

¿X que generos pertenece el anime? Shounen, la Aventura, Fantasia y Comedia
¿Que rating tiene? 3
¿Que popularidad tiene?
¡Perfecto! La proxima vez que preguntes ya sabre que responder
> conoces sobre Mi Anime desconocido

Si, esto es lo que se sobre Mi Anime desconocido
Tiene rating 3, popularidad 1 y su genero entra en Shounen, Aventura, Fantasia, Comedia
>
```
### Preguntas recurrentes sobre animes

Cuando anibot se da cuenta que han preguntado más de 5 veces por un anime en
particular, este le sube la popularidad automáticamente.

#### Ejemplo
```
> conoces sobre Dragon Ball

Si, esto es lo que se sobre Dragon Ball
Tiene rating 3, popularidad 7 y su genero entra en Shounen, Aventura
> conoces sobre Dragon Ball

Si, esto es lo que se sobre Dragon Ball
Tiene rating 3, popularidad 7 y su genero entra en Shounen, Aventura
> conoces sobre Dragon Ball

Si, esto es lo que se sobre Dragon Ball
Tiene rating 3, popularidad 7 y su genero entra en Shounen, Aventura
> conoces sobre Dragon Ball

Si, esto es lo que se sobre Dragon Ball
Tiene rating 3, popularidad 7 y su genero entra en Shounen, Aventura
> conoces sobre Dragon Ball

Si, esto es lo que se sobre Dragon Ball
Tiene rating 3, popularidad 7 y su genero entra en Shounen, Aventura
> conoces sobre Dragon Ball

Si, esto es lo que se sobre Dragon Ball
Tiene rating 3, popularidad 8 y su genero entra en Shounen, Aventura
```

No tienen que ser preguntas sucesivas, anibot mantiene su base de datos para
la cantidad de preguntas que lleva cada anime.

### Como salir del bot

Para despedirse del bot, solo hay que escribir _salir_
```
> salir

Espero que hayas pasado un rato agradable :)
```
