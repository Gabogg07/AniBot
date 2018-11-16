anime(X) :- member(X,["Dragon Ball", "Naruto", "Bleach", "HunterXHunter", "Hamtaro", "Full Metal Alchemist"]).

genero(X) :- member(X,["Aventura", "Shoujo", "Shounen", "Kodomo", "Seinen", "Josei", "Ficción",
                    "Fantasía", "Mecha", "Sobrenatural", "Magia", "Gore"]).

generoAnime("Naruto",["Shounen","Aventura"]).
generoAnime("Dragon Ball",["Shounen"]).
generoAnime("Bleach",["Shounen", "Sobrenatural"]).
generoAnime("HunterXHunter",["Seinen", "Aventura"]).
generoAnime("Hamtaro",["Kodomo"]).
generoAnime("Full Metal Alchemist",["Shounen", "Magia"]).

rating("Dragon Ball",3).
rating("Naruto",1).
rating("Bleach",4).
rating("HunterXHunter",5).
rating("Hamtaro",2).
rating("Full Metal Alchemist",4).

popularidad("Dragon Ball",7).
popularidad("Naruto",5).
popularidad("Bleach",8).
popularidad("HunterXHunter",3).
popularidad("Hamtaro",10).
popularidad("Full Metal Alchemist",1).

% Dado un arreglo imprime cada elemento en una linea
printByLine([]).
printByLine([X|List]) :- writeln(X), printByLine(List).


printAnime([]).
printAnime([(X,Y)|List]) :- atom_concat(" - ",X, Anime), writeln(Anime), printAnime(List).

%Pasa una lista de strings todos a minuscula
toLower([],[]).
toLower([X|Xs],[I|R]) :- string_lower(X, I), toLower(Xs, R).

% Realiza el query sobre el rating de todos los anime y los imprime en orden decreciente
orderBy(rating) :- findall((Y,X),rating(Y,X), List), sort(2,  @>=, List,  Sorted), printByLine(Sorted).

% Realiza el query sobre la popularidad de todos los anime y los imprime en orden decreciente
orderBy(popularidad) :- findall((Y,X),popularidad(Y,X), List), sort(2,  @>=, List,  Sorted), printByLine(Sorted).
 
%Leer input el usuario y llama a la lista de respuestas
leerRespuesta :- readln(X), nl, respuesta(X), leerRespuesta.

%Verifica que un entero este entre 1 y X
checkRange(X,Top) :- X @=< Top , 1 @=< X.

%Queries sobre rating
respuesta([cuales,son,los,mejores,rating,?]):- findall((X,_),rating(X,5), List), writeln("Listado de animes con rating 5: "), printAnime(List).
respuesta([cuales,son,los,peores,rating,?]):- findall((X,_),rating(X,1), List), writeln("Listado de animes con rating 1: "), printAnime(List).
respuesta([que,animes,tienen,rating,Q,?]):- checkRange(Q,5), findall((X,_),rating(X,Q), List), atom_concat("Listado de animes con rating ", Q, Salida), 
										writeln(Salida), printAnime(List).
respuesta([que,animes,tienen,rating,Q,?]):- writeln("Disculpa, pero solo me han hablado de ratings entre 1 y 5. Intenta con uno de estos valores.").



%Queries sobre popularidad
respuesta([cuales,son,los,mas,populares,?]):- findall((X,_),popularidad(X,10), List), writeln("Listado de animes bastante conocidos: "), printAnime(List).

respuesta(X, Y):- write(X), write(--), write(Y).

