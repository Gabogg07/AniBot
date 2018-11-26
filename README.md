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
