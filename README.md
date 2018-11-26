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
