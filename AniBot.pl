base_de_datos([
    % Nombre anime, rating, popularidad, genero
    % Traidos por los profesores
    ["Dragon Ball", 3, 7, ["Shounen","Aventura"]],
    ["Naruto", 1, 5, ["Shounen"]],
    ["Bleach", 4, 8, ["Shounen", "Sobrenatural"]],
    ["HunterXHunter", 5, 3, ["Seinen", "Aventura"]],
    ["Hamtaro", 2, 10, ["Kodomo"]],
    ["Full Metal Alchemist: Brotherhood", 4, 1, ["Shounen", "Magia"]],
    % Llenados por nosotros
    ["Death Note", 4, 10, ["Sobrenatural", "Mystery"]],
    ["Attack on Titan", 5, 10, ["Shounen", "Aventura"]],
    ["Code Geass", 5, 10, ["Mecha", "Mystery", "Shounen"]],
    ["Fairy Tail", 3, 8, ["Magia", "Accion", "Aventura"]],
    ["One Piece", 4, 7, ["Aventura", "Accion"]],
    ["One Punch Man", 5, 10, ["Comedia", "Accion", "Sci-Fi", "Sobrenatural"]],
    ["Akame ga Kill!", 3, 7, ["Accion", "Drama", "Fantasia", "Shounen"]],
    ["Pokemon", 5, 10, ["Comedia", "Accion", "Fantasia", "Aventura"]],
    ["Noragami", 3, 6, ["Aventura", "Accion", "Fantasia", "Shounen"]],
    ["Ao no Exorcist", 2, 5, ["Mystery", "Drama"]]
]).

anime(X) :- base_de_datos(L), member([X, _, _, _], L).

generomap([], []).
generomap([[_, _, _, X]], [X]) :- !.
generomap([[_, _, _, X]|Rest], [X|List]) :- generomap(Rest, List).

unique([], []).
unique([X], [X]) :- !.
unique([X,X|R], Rest) :- unique([X|R], Rest).
unique([H,Y | T], [H|T1]):- Y \= H, unique( [Y|T], T1).


% todos_los_generos(X) :-
%     findall
genero(X) :-
    base_de_datos(L),
    generomap(L, L0),
    append(L0, L1),
    sort(L1, L2),
    member(X, L2).

generoAnime(X, L) :-
    base_de_datos(List), member([X, _, _, L], List).

rating(X, L) :-
    base_de_datos(List), member([X, L, _, _], List).

popularidad(X, L):-
    base_de_datos(List), member([X, _, L, _], List).

% Dado un arreglo imprime cada elemento en una linea
printByLine([]).
printByLine([X|List]) :-
    writeln(X),
    printByLine(List).


printAnime([]).
printAnime([(X,_)|List]) :-
    atom_concat(" - ",X, Anime),
    writeln(Anime),
    printAnime(List).

%Pasa una lista de strings todos a minuscula
toLower([],[]).
toLower([X|Xs],[I|R]) :- string_lower(X, I), toLower(Xs, R).

% Realiza el query sobre el rating de todos los anime y los imprime en orden decreciente
orderBy(rating, Sorted) :-
    findall((Y,X), rating(Y,X), List),
    sort(2,  @>=, List,  Sorted).

% Realiza el query sobre la popularidad de todos los anime y los imprime en orden decreciente
orderBy(popularidad, Sorted) :-
    findall((Y,X), popularidad(Y,X), List),
    sort(2,  @>=, List,  Sorted).

 
%Leer input el usuario y llama a la lista de respuestas
leerRespuesta :-
    readln(X),
    nl,
    respuesta(X),
    leerRespuesta.


%Verifica que un entero este entre 1 y X
checkRange(X,Top) :- X @=< Top , 1 @=< X.

%Queries sobre rating
respuesta([cuales,son,los,mejores,rating,?]):-
    findall((X,_),rating(X,5), List),
    writeln("Listado de animes con rating 5: "),
    printAnime(List).
respuesta([cuales,son,los,peores,rating,?]):-
    findall((X,_),rating(X,1), List),
    writeln("Listado de animes con rating 1: "),
    printAnime(List).
respuesta([que,animes,tienen,rating,Q,?]):-
    checkRange(Q,5), findall((X,_),rating(X,Q), List),
    atom_concat("Listado de animes con rating ", Q, Salida),
    writeln(Salida),
    printAnime(List).
respuesta([que,animes,tienen,rating,_,?]):-
    writeln("Disculpa, peros olo me han hablado de ratings entre 1 y 5. Intenta con uno de estos valores.").

%Queries sobre popularidad
respuesta([cuales,son,los,mas,populares,?]):-
    findall((X,_),popularidad(X,10), List),
    writeln("Listado de animes bastante conocidos: "),
											  printAnime(List).

respuesta([cuales,son,los,menos,populares,?]):-
    findall((X,_),(popularidad(X,Y), (Y=1; Y=2)), List),
    writeln("Listado de animes muy poco conocidos: "),
											  printAnime(List).
respuesta([que,animes,son,poco,conocidos,?]):-
    findall((X,_),(popularidad(X,Y), (Y=3; Y=4; Y=5)), List),
    writeln("Listado de animes poco conocidos: "),
											  printAnime(List).
respuesta([que,animes,son,conocidos,?]):-
    findall((X,_),(popularidad(X,Y), (Y=6; Y=7)), List),
    writeln("Listado de animes conocidos: "),
											  printAnime(List).
respuesta([que,animes,son,muy,conocidos,?]):-
    findall((X,_),(popularidad(X,Y), (Y=8; Y=9)), List),
    writeln("Listado de animes muy conocidos: "),
											  printAnime(List).

%Dada una lista de generos en formato [articulo,genero,...] devuelve una lista solo con generos
separarGeneros([_, X, Y| Generos], [X|R]):-  (Y=,; Y=y) , separarGeneros(Generos,R).
separarGeneros([_, X| Generos], [X|R]):- separarGeneros(Generos,R).
separarGeneros([],[]).
 
%Dada una lista de generos, imprime para cada uno su nombre y los animes asociados.

buscarPorGenero([X|T],[Respuesta|L],P) :- 
              (P=rating; P=popularidad), atom_string(X,Q),writeln(Q), genero(Q),
              findall((A,G), (generoAnime(A,G), member(Q,G)), Lista), orderBy(P, Sorted), 
              filterByList(Sorted, Lista, Respuesta), printAnime(Respuesta), 
							buscarPorGenero(T,L,P), !.
buscarPorGenero([X|T],L,P) :- atom_string(X,Q),write('Lo siento no tengo información sobre '), 
              writeln(Q), buscarPorGenero(T,L,P).
buscarPorGenero([],[],_).


%Dadas dos listas conformadas por tuplas (X,Y), intersecta las dos listas conservando el orden de la primera.
filterByList([(X,Y)|T], L1, [(X,Y)|R]) :- member((X,_),L1), filterByList(T, L1, R), !.
filterByList([_|T], L1, R) :- filterByList(T,L1,R).
filterByList([], _, []).  

%Query sobre listado de generos
respuesta([me,gusta|Generos]) :- separarGeneros(Generos, Listado), writeln("Segun el género te podemos recomendar:\n"), 
                                 buscarPorGenero(Listado,Respuesta,rating).


%Query sobre un genero por popularidad y/o rating
respuesta([muestrame,animes,de,X,por,Y]) :-(Y = rating ; Y = popularidad), buscarPorGenero([X], Animes, Y).
respuesta([muestrame,animes,de,X,por,Y,y,Z]) :-(Y = rating ; Y = popularidad), (Z = rating ; Z = popularidad), Z\=Y, atom_string(X,Q),writeln(Q), genero(Q), findall((A,G), (generoAnime(A,G), member(Q,G)), Animes),
											 calcularRatingPopularidad(Animes, Temp), sort(2,  @>=, Temp,  Sorted), printAnime(Sorted).

calcularRatingPopularidad([(X,_)|T], [(X,S)|L]) :- popularidad(X,P), rating(X,R), S is R+P, calcularRatingPopularidad(T,L).
calcularRatingPopularidad([],[]).
prueba:- calcularRatingPopularidad(["Naruto","Hamtaro"], Z), writeln(Z).

respuesta([salir]) :- halt.
%RESPUESTAS A PREGUNTAS GENERICAS
% Quizas quisiste preguntar por los animes de cierta popularidad?
