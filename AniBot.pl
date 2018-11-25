base_de_datos([
    % Nombre anime, rating, popularidad, genero
    % Traidos por los profesores
    ["Dragon Ball", 3, 7, ["Shounen","Aventura"]],
    ["Naruto", 1, 5, ["Shounen"]],
    ["Bleach", 4, 8, ["Shounen", "Sobrenatural"]],
    ["HunterXHunter", 5, 3, ["Seinen", "Aventura"]],
    ["Hamtaro", 2, 10, ["Kodomo"]],
    ["Full Metal Alchemist : Brotherhood", 4, 1, ["Shounen", "Magia"]],
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

inicializarCantidadPreguntas([]).
inicializarCantidadPreguntas([Anime|Animes]) :-
    assert(cantidadPreguntas(Anime, 0)), inicializarCantidadPreguntas(Animes).

inicializarPopularidad([]).
inicializarPopularidad([Anime|Animes]) :-
    base_de_datos(L),
    member([Anime, _, P, _], L),
    assert(popularidad(Anime, P)),
    inicializarPopularidad(Animes).

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

printListItems([]).
printListItems([X]):- writeln(X).
printListItems([X|T]):- write(X), write(', '), printListItems(T).

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


%Dada una lista de generos en formato [articulo,genero,...] devuelve una lista solo con generos
separarGeneros([_, X, Y| Generos], [X|R]):-  (Y=,; Y=y) , separarGeneros(Generos,R).
separarGeneros([X, Y| Generos], [X|R]):-  (Y=,; Y=y) , separarGeneros(Generos,R).
separarGeneros([_, X], [X]).
separarGeneros([X], [X]).
separarGeneros([],[]).

%Dada una lista de generos, imprime para cada uno su nombre y los animes asociados.

buscarPorGenero([X|T],[Respuesta|L],P) :-
              (P=rating; P=popularidad), genero(Q), atom_string(X,Q),writeln(Q),
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

%Dada una lista se introduce entre sus elementos <Elem> y retorna el string resultante
unirCon(Entrada, Elem, String) :- atomic_list_concat(Entrada, Elem, Atom), atom_string(Atom, String).


calcularRatingPopularidad([(X,_)|T], [(X,S)|L]) :- popularidad(X,P), rating(X,R), S is R+P, calcularRatingPopularidad(T,L).
calcularRatingPopularidad([],[]).

buscarPorPopularidadRating(Rinf, Rsup, Pinf, Psup, Respuesta):-
        findall(
            ([N,R,P,_]),
            (
                (anime(N), rating(N, R), popularidad(N, P)),
                R@>=Rinf, R@<Rsup,
                P@>=Pinf, P@<Psup
            ), Respuesta).

%Dada una lista que contiene listas con 4 elementos, imprime los primeros 3 en formato de columnas
printGrid(X):- format("~a~t~35| ~t~a~t~11+ ~t~a~t~11+~n",['Anime','Rating','Popularidad']),  printGridAux(X),!.
printGridAux([[N,R,P,_]|T]):- format("~a~t~35| ~t~a~t~11+ ~t~a~t~11+~n",[N,R,P]), printGridAux(T).
printGridAux([]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Predicados de utilidad %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% leerRating: Predicado que unifica el rating dado por el usuario
% cuando se le pregunta por los datos del anime que no existe
%   Rating: Valor entre 1 y 5 dado por el usuario
leerRating(Rating) :-
    write('¿Que rating tiene? '),
    readln(X),
    (   X=[Rating],
        member(Rating, [1, 2, 3, 4, 5])
        % Se le termina de pedir input cuando ya el numero esta entre 1 y 5
    ->  !
        % El input valido debe estar entre 1 y 5, si no es asi se le pide input nuevamente
    ;   writeln('El rating especificado no es valido, debe ser un numero entre 1 y 5'),
        leerRating(Rating)
    ).

% leerPopularidad: Predicado que unifica la popularidad dada por el usuario
% con el parametro dado. Si el input es omitido (se le da a enter sin haber
% escrito nada) se le asigna una popularidad por defecto (1)
leerPopularidad(Popularidad) :-
    write('¿Que popularidad tiene? '),
    readln(X),
    (
        X = []
    ->  Popularidad is 1
    ;   (
            X = [Popularidad],
            member(Popularidad, [1,2,3,4,5,6,7,8,9,10])
            % Si se satisface nos regresamos felices
        ->  !
            % En caso contrario le indicamos en que se equivoco y luego volvemos a pedir todo
        ;   writeln('La popularidad espeficiada no es valida, debe ser un numero'),
            writeln(' entre 1 y 10; o vacio, espeficicando 1'),
            leerPopularidad(Popularidad)
        )
    ).

% anadirGeneros: Anade los generos a la base de datos de generos.
anadirGeneros([]) :- !.
anadirGeneros([Genero|ListaDeGeneros]) :-
    atom_string(Genero, GeneroAtom),
    assert(genero(GeneroAtom)), anadirGeneros(ListaDeGeneros).

% generosToString: Recibe una lista de generos como atomos y las pasa a strings
generosToString([], []) :- !.
generosToString([Genero| ListaGeneros], [GeneroStr| ListaStr]) :-
    atom_string(Genero, GeneroStr),
    generosToString(ListaGeneros, ListaStr).


% subirPopularidad: Predicado que sube la popularidad de un anime si su cantidad
% de preguntas es igual a 5.
:- (dynamic cantidadPreguntas/2).
subirPopularidad(Anime) :-
    cantidadPreguntas(Anime, CantPreg),
    retract(cantidadPreguntas(Anime, CantPreg)),
    (   CantPreg<4
    ->  NuevaCantPreg is CantPreg+1,
        assert(cantidadPreguntas(Anime, NuevaCantPreg))
    ;   assert(cantidadPreguntas(Anime, 0))
    ).

% Respuestas a preguntas definidas por el bot
%Queries sobre rating
respuesta([cuales, son, los, mejores, rating, ?]) :-
    findall((X, _), rating(X, 5), List),
    writeln("Listado de animes con rating 5: "),
    printAnime(List).
respuesta([cuales, son, los, peores, rating, ?]) :-
    findall((X, _), rating(X, 1), List),
    writeln("Listado de animes con rating 1: "),
    printAnime(List).
respuesta([que, animes, tienen, rating, Q, ?]) :-
    checkRange(Q, 5),
    findall((X, _), rating(X, Q), List),
    atom_concat("Listado de animes con rating ", Q, Salida),
    writeln(Salida),
    printAnime(List).
respuesta([que, animes, tienen, rating, _, ?]) :-
    writeln("Disculpa, pero solo me han hablado de ratings entre 1 y 5. Intenta con uno de estos valores.").

%Queries sobre popularidad
respuesta([cuales, son, los, mas, populares, ?]) :-
    findall((X, _), popularidad(X, 10), List),
    writeln("Listado de animes bastante conocidos: "),
    printAnime(List).

respuesta([cuales, son, los, menos, populares, ?]) :-
    findall((X, _),
            ( popularidad(X, Y),
              (   Y=1
              ;   Y=2
              )
            ),
            List),
    writeln("Listado de animes muy poco conocidos: "),
    printAnime(List).
respuesta([que, animes, son, poco, conocidos, ?]) :-
    findall((X, _),
            ( popularidad(X, Y),
              (   Y=3
              ;   Y=4
              ;   Y=5
              )
            ),
            List),
    writeln("Listado de animes poco conocidos: "),
    printAnime(List).
respuesta([que, animes, son, conocidos, ?]) :-
    findall((X, _),
            ( popularidad(X, Y),
              (   Y=6
              ;   Y=7
              )
            ),
            List),
    writeln("Listado de animes conocidos: "),
    printAnime(List).
respuesta([que, animes, son, muy, conocidos, ?]) :-
    findall((X, _),
            ( popularidad(X, Y),
              (   Y=8
              ;   Y=9
              )
            ),
            List),
    writeln("Listado de animes muy conocidos: "),
    printAnime(List).

%Query sobre listado de generos
respuesta([me, gusta|Generos]) :-
    separarGeneros(Generos, Listado),
    writeln("Segun el género te podemos recomendar:\n"),
    buscarPorGenero(Listado, _, rating).


%Query sobre un genero por popularidad y/o rating
respuesta([muestrame, animes, de, X, por, Y]) :-
    (   Y=rating
    ;   Y=popularidad
    ),
    buscarPorGenero([X], _, Y).
respuesta([muestrame, animes, de, X, por, Y, y, Z]) :-
    (   Y=rating
    ;   Y=popularidad
    ),
    (   Z=rating
    ;   Z=popularidad
    ),
    Z\=Y,
    atom_string(X, Q),
    writeln(Q),
    genero(Q),
    findall((A, G),
            ( generoAnime(A, G),
              member(Q, G)
            ),
            Animes),
    calcularRatingPopularidad(Animes, Temp),
    sort(2, @>=, Temp, Sorted),
    printAnime(Sorted).

%Query sobre datos de un animes
respuesta([conoces, sobre|X]) :-
    unirCon(X, ' ', Nombre),
    anime(Nombre),
    write('Si, esto es lo que se sobre '),
    writeln(Nombre),
    rating(Nombre, R),
    popularidad(Nombre, P),
    generoAnime(Nombre, G),
    write('Tiene rating '),
    write(R),
    write(', popularidad '),
    write(P),
    write(' y su genero entra en '),
    printListItems(G),
    subirPopularidad(Nombre), !.
respuesta([conoces, sobre|X]) :-
    unirCon(X, ' ', Nombre),
    \+ anime(Nombre),
    write('Lo siento, no conozco el anime: "'),
    write(Nombre),
    writeln('"'),
    writeln('Pero si me das informacion adicional, lo puedo tomar en cuenta para la siguiente :)'),
    nl,
    write('¿X que generos pertenece el anime? '),
    readln(Gen),
    separarGeneros(Gen, Gen1),
    leerRating(Rating),
    leerPopularidad(Popularidad),
    writeln(generosTo),
    generosToString(Gen1, Generos),
    writeln(generosTa),
    anadirGeneros(Generos),
    assert(anime(Nombre)),
    assert(rating(Nombre, Rating)),
    assert(generoAnime(Nombre, Generos)),
    assert(popularidad(Nombre, Popularidad)),
    assert(cantidadPreguntas(Nombre, 1)),
    writeln('¡Perfecto! La proxima vez que preguntes ya sabre que responder').
    % writeln('Lo siento, aca es donde German te pregunta y agrega a la DB').


%Preguntas sobre popularidad Y rating especifico
%rating entre 4 y 5-- interesante
respuesta([quiero,ver,un, anime| X]):-
        (X=[interesante,y,muy,poco,conocido];
         X=[muy,poco,conocido,e,interesante]),
        Rinf is 4, Rsup is 6,
        Pinf is 1, Psup is 3,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).


respuesta([quiero,ver,un, anime| X]):-
        (X=[interesante,y,poco,conocido];
         X=[poco,conocido,e,interesante]),
        Rinf is 4, Rsup is 6,
        Pinf is 3, Psup is 6,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

respuesta([quiero,ver,un, anime| X]):-
        (X=[interesante,y,conocido];
         X=[conocido,e,interesante]),
        Rinf is 4, Rsup is 6,
        Pinf is 6, Psup is 8,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

respuesta([quiero,ver,un, anime| X]):-
        (X=[interesante,y,muy,conocido];
         X=[muy,conocido,e,interesante]),
        Rinf is 4, Rsup is 6,
        Pinf is 8, Psup is 10,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

respuesta([quiero,ver,un, anime| X]):-
        (X=[interesante,y,bastante,conocido];
         X=[bastante,conocido,e,interesante]),
        Rinf is 4, Rsup is 6,
        Pinf is 10, Psup is 11,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

%Rating = 3 -- normal
respuesta([quiero,ver,un, anime| X]):-
        (X=[normal,y,muy,poco,conocido];
         X=[muy,poco,conocido,y,normal]),
        Rinf is 3, Rsup is 4,
        Pinf is 1, Psup is 3,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).


respuesta([quiero,ver,un, anime| X]):-
        (X=[normal,y,poco,conocido];
         X=[poco,conocido,y,normal]),
        Rinf is 3, Rsup is 4,
        Pinf is 3, Psup is 6,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

respuesta([quiero,ver,un, anime| X]):-
        (X=[normal,y,conocido];
         X=[conocido,y,normal]),
        Rinf is 3, Rsup is 4,
        Pinf is 6, Psup is 8,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

respuesta([quiero,ver,un, anime| X]):-
        (X=[normal,y,muy,conocido];
         X=[muy,conocido,y,normal]),
        Rinf is 3, Rsup is 4,
        Pinf is 8, Psup is 10,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

respuesta([quiero,ver,un, anime| X]):-
        (X=[normal,y,bastante,conocido];
         X=[bastante,conocido,y,normal]),
        Rinf is 3, Rsup is 4,
        Pinf is 10, Psup is 11,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

%Rating entre 1 y 2 -- aburrido
respuesta([quiero,ver,un, anime| X]):-
        (X=[aburrido,y,muy,poco,conocido];
         X=[muy,poco,conocido,y,aburrido]),
        Rinf is 1, Rsup is 3,
        Pinf is 1, Psup is 3,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).


respuesta([quiero,ver,un, anime| X]):-
        (X=[aburrido,y,poco,conocido];
         X=[poco,conocido,y,aburrido]),
        Rinf is 1, Rsup is 3,
        Pinf is 3, Psup is 6,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

respuesta([quiero,ver,un, anime| X]):-
        (X=[aburrido,y,conocido];
         X=[conocido,y,aburrido]),
        Rinf is 1, Rsup is 3,
        Pinf is 6, Psup is 8,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

respuesta([quiero,ver,un, anime| X]):-
        (X=[aburrido,y,muy,conocido];
         X=[muy,conocido,y,aburrido]),
        Rinf is 1, Rsup is 3,
        Pinf is 8, Psup is 10,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

respuesta([quiero,ver,un, anime| X]):-
        (X=[aburrido,y,bastante,conocido];
         X=[bastante,conocido,y,aburrido]),
        Rinf is 1, Rsup is 3,
        Pinf is 10, Psup is 11,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).





respuesta([salir]) :-
    halt.
%RESPUESTAS A PREGUNTAS GENERICAS
% Quizas quisiste preguntar por los animes de cierta popularidad?


:- dynamic cantidadPreguntas/2.
:-
    findall(X, anime(X), Animes),
    inicializarCantidadPreguntas(Animes),
    inicializarPopularidad(Animes),
    writeln("¡Hola! Mi nombre es Anibot"),
    writeln("Se mucho sobre animes, pero puedo aprender por lo que me vayas pidiendo"),
    writeln("¿Que necesitas?"),
    prompt('|: ', '> '),
    leerRespuesta.


