/**
    @descr Anibot.pl
            Código fuente de Anibot, bot que interactua con el usuario respondiendo ciertas preguntas
            asociadas a animes.
    @author German Robayo     14-10924 
            Gabriel Gutierrez 13-10625
    @date Noviembre de 2018
*/

listing(random_member).

/**
    @form base_de_datos(List)
    @descr True si List es es la base de datos del momento.
            Predicado que se usa para llevar la informacion de los animes,
            su rating, popularidad y generos.
*/
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
    ["Akame ga Kill !", 3, 7, ["Accion", "Drama", "Fantasia", "Shounen"]],
    ["Pokemon", 5, 10, ["Comedia", "Accion", "Fantasia", "Aventura"]],
    ["Noragami", 3, 6, ["Aventura", "Accion", "Fantasia", "Shounen"]],
    ["Ao no Exorcist", 2, 5, ["Mystery", "Drama"]]
]).

/**
    @form anime(Value)
    @descr True si value es un anime contenido en la base de datos
*/
anime(X) :- base_de_datos(L), member([X, _, _, _], L).

/**
    @form generomap(List1, List2)
    @descr True si List1 es una lista en formato [[W,X,Y,Z]] que contiene los mismos
            generos que los contenidos en List2. Usada para obtener todos los generos
            de la base de datos.
*/
generomap([], []).
generomap([[_, _, _, X]], [X]) :- !.
generomap([[_, _, _, X]|Rest], [X|List]) :- generomap(Rest, List).

/**
    @form genero(Value)
    @descr True si value es un genero contenido en la base de datos
*/
genero(X) :-
    base_de_datos(L),
    generomap(L, L0),
    append(L0, L1),
    sort(L1, L2),
    member(X, L2).

/**
    @form generoAnime(Value, List)
    @descr True si los generos de value en la base de datos son los mismos que los de List.
           Usado para obtener los generos del anime pasado como Value
*/
generoAnime(X, L) :-
    base_de_datos(List), member([X, _, _, L], List).

/**
    @form anime(Value1, Value2)
    @descr True si value2 es el rating de value1 en la base de datos.
            Usado para obtener el rating del anime pasado como value1
*/
rating(X, L) :-
    base_de_datos(List), member([X, L, _, _], List).

/**
    @form inicializarCantidadPreguntas(List)
    @descr True siempre que list sea una lista. Usado para inicializar cantidad de preguntas en 0 para todos los animes
        contenidos en List.
        Cantidad de preguntas es la cantidad de veces restantes que deben preguntar por un anime antes
        de que a este se le suba la popularidad
*/
inicializarCantidadPreguntas([]).
inicializarCantidadPreguntas([Anime|Animes]) :-
    assert(cantidadPreguntas(Anime, 0)), inicializarCantidadPreguntas(Animes).

/**
    @form inicializarPopularidad(List)
    @descr True siempre que list sea una lista. Usado para poblar el predicado popularidad con la popularidad
            de cada anime pasado en List, segun lo contenido en la base de datos.
*/
inicializarPopularidad([]).
inicializarPopularidad([Anime|Animes]) :-
    base_de_datos(L),
    member([Anime, _, P, _], L),
    assert(popularidad(Anime, P)),
    inicializarPopularidad(Animes).

/**
    @form printByLine(List)
    @descr True siempre que List sea una lista. Imprime cada elemento de List en una linea separada.
*/
printByLine([]).
printByLine([X|List]) :-
    writeln(X),
    printByLine(List).

/**
    @form printAnime(List)
    @descr True siempre que List sea una lista de elementos con forma (X,Y). 
           Imprime en una linea nueva cada elemento X precedido por un "-"
*/
printAnime([]).
printAnime([(X,_)|List]) :-
    atom_concat(" - ",X, Anime),
    writeln(Anime),
    printAnime(List).

/**
    @form printListItems(List)
    @descr True siempre que List sea una lista. Imprime todos los elementos de list separados por ",".
*/
printListItems([]).
printListItems([X]):- writeln(X).
printListItems([X|T]):- write(X), write(', '), printListItems(T).

/**
    @form printGrid(List)
    @descr True siempre que List sea una lista de listas de 4 elementos. Imprime en forma de tabla todos los elementos de List,
            tomando cada elemento en una fila.
*/
printGrid(X):- format("~a~t~35| ~t~a~t~11+ ~t~a~t~11+~n",['Anime','Rating','Popularidad']),  printGridAux(X),!.
printGridAux([[N,R,P,_]|T]):- format("~a~t~35| ~t~a~t~11+ ~t~a~t~11+~n",[N,R,P]), printGridAux(T).
printGridAux([]).

/**
    @form toLower(List1,List2)
    @descr True si List2 es igual al string contenido en List1 pero en minusculas.
*/
toLower([],[]).
toLower([X|Xs],[I|R]) :- string_lower(X, I), toLower(Xs, R).


/**
    @form printByLine(parameter, List, Order)
    @contraints
        @restricted parameter, debe ser rating o ppularidad.
    @descr True si List contiene todos los elementos del predicado rating|popularidad ordenados de forma decreciente
            segun el segundo valor de la tupla, segun Order. Usado para obtener una lista de animes ordenados de forma
            decreciente segun su rating|popularidad, segun lo indique parameter
*/
orderBy(rating, Sorted, Order) :-
    findall((Y,X), rating(Y,X), List),
    (
        Order = creciente
        -> sort(2, @>=, List, Sorted)
        ; sort(2, @=<, List, Sorted)
    ).

orderBy(popularidad, Sorted, Order) :-
    findall((Y,X), popularidad(Y,X), List),
    (
        Order = decreciente
        -> sort(2,  @>=, List,  Sorted)
        ; sort(2,  @=<, List,  Sorted)
    ).


/**
    @form leerRespuesta
    @descr True siempre. Lee el input del usuario y llama al predicado respuesta con una lista
            contenedora del input.
            Usado como loop principal de Anibot.
*/
leerRespuesta :-
    flush_output,
    readln(X),
    nl,
    respuesta(X),
    leerRespuesta.


/**
    @form checkRange(Value1,Value2)
    @descr True si Value1 esta contenido entre 1 y Value2
*/
checkRange(X,Top) :- X @=< Top , 1 @=< X.


/**
    @form separarGeneros(List1, List2)
    @descr True si List2 contiene los generos de la lista de valores pasada en List1.
            Usado para descomponer listas de generos ingresadas por el usuario en una lista,
            considera que List1 es una lista de generos con sus articulos y separados
            por ","|"y". 
            Ej. separarGeneros([la,Aventura,,,el,Shounen]) devuelve [Aventura,Shounen] 
*/
separarGeneros([_, X, Y| Generos], [X|R]):-  (Y=,; Y=y) , separarGeneros(Generos,R).
separarGeneros([X, Y| Generos], [X|R]):-  (Y=,; Y=y) , separarGeneros(Generos,R).
separarGeneros([_, X], [X]).
separarGeneros([X], [X]).
separarGeneros([],[]).

/**
    @form printByLine(List, parameter, Orden)
    @constraints
        @restricted parameter, debe ser rating o popularidad
    @descr True siempre que List sea una lista. 
            Sea List una lista con generos imprime el nombre de cada uno
            seguido de todos los animes que se clasifican con ese genero, ordenados segun Orde.
*/
buscarPorGenero([X|T],[Respuesta|L],P, Orden) :-
              (P=rating; P=popularidad), genero(Q), atom_string(X,Q),writeln(Q),
              findall((A,G), (generoAnime(A,G), member(Q,G)), Lista), orderBy(P, Sorted, Orden),
              filterByList(Sorted, Lista, Respuesta), printAnime(Respuesta),
							buscarPorGenero(T,L,P,Orden), !.
buscarPorGenero([X|T],L,P,O) :- atom_string(X,Q),write('Lo siento no tengo información sobre '),
              writeln(Q), buscarPorGenero(T,L,P,O).
buscarPorGenero([],[],_,_).

/**
    @form filterByList(List1, List2, List3)
    @descr True si List3 contiene la intersección de List1 con List2, en el orden en que aparecen
            en List1. Usado para ordenar listas desordenadas de animes usando una lista por rating
            o popularidad 
*/
filterByList([(X,Y)|T], L1, [(X,Y)|R]) :- member((X,_),L1), filterByList(T, L1, R), !.
filterByList([_|T], L1, R) :- filterByList(T,L1,R).
filterByList([], _, []).

/**
    @form unirCon(List, Value2, Value3)
    @descr True si value3 es una representacion en forma de string de los elementos de List separados por Elem.
            Ej. unirCon([CI,LLA,PS], "-",String) devuelve String = "CI-LLA-PS"
*/
unirCon(Entrada, Elem, String) :- atomic_list_concat(Entrada, Elem, Atom), atom_string(Atom, String).

/**
    @form calcularRatingPopularidad(List1, List2)
    @descr True si List2 es una Lista con los mismos elementos (X,_) de los elementos contenidos en List1.
            Usado para obtener una lista de animes acompañados de un valor S que es la suma del rating y la popularidad.
*/
calcularRatingPopularidad([(X,_)|T], [(X,S)|L]) :- popularidad(X,P), rating(X,R), S is R+P, calcularRatingPopularidad(T,L).
calcularRatingPopularidad([],[]).

/**
    @form buscarPorPopularidadRating(Value1, Value2, Value3, Value4, List)
    @descr devuelve en List una lista de animes que cumplen con tener una popularidad entre Pinf y Psup-1,
            al igual que un rating entre Rinf y Rsup1-1
*/
buscarPorPopularidadRating(Rinf, Rsup, Pinf, Psup, Respuesta):-
        findall(
            ([N,R,P,_]),
            (
                (anime(N), rating(N, R), popularidad(N, P)),
                R@>=Rinf, R@<Rsup,
                P@>=Pinf, P@<Psup
            ), Respuesta).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Predicados de utilidad %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
    @form leerRating(Rating)
    @descr True siempre. Unifica el rating dado por el usuario
            cuando se le pregunta por los datos del anime que no existe
            Rating: Valor entre 1 y 5 dado por el usuario
*/

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

/**
    @form leerPopularidad(Popularidad)
    @descr True siempre. Unifica la popularidad dada por el usuario
            con el parametro dado. Si el input es omitido (se le da a enter sin haber
            escrito nada) se le asigna una popularidad por defecto (1)
*/
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

/**
    @form anadirGeneros(List)
    @descr True siempre que list sea una Lista. Anade los elementos de list a
            la base de datos de generos.
*/
anadirGeneros([]) :- !.
anadirGeneros([Genero|ListaDeGeneros]) :-
    atom_string(Genero, GeneroAtom),
    assert(genero(GeneroAtom)), anadirGeneros(ListaDeGeneros).

% generosToString: Recibe una lista de generos como atomos y las pasa a strings
generosToString([], []) :- !.
generosToString([Genero| ListaGeneros], [GeneroStr| ListaStr]) :-
    atom_string(Genero, GeneroStr),
    generosToString(ListaGeneros, ListaStr).

/**
    @form subirPopularidad(Anime)
    @descr True siempre. Sube la popularidad de Anime si su cantidad de preguntas
            igual a 5.
*/
subirPopularidad(Anime) :-
    cantidadPreguntas(Anime, CantPreg),
    retract(cantidadPreguntas(Anime, CantPreg)),
    (   CantPreg<4
    ->  NuevaCantPreg is CantPreg+1,
        assert(cantidadPreguntas(Anime, NuevaCantPreg))
    ;   assert(cantidadPreguntas(Anime, 0)),
        popularidad(Anime, Popularidad),
        (   Popularidad < 10
        ->  NuevaPopularidad is Popularidad + 1,
            retract(popularidad(Anime, Popularidad)),
            assert(popularidad(Anime, NuevaPopularidad))
            ; !
            )
    ).
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Respuestas a preguntas definidas por el bot %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/**
    @form respuesta(List)
    @descr True siempre. Predicado encargado de reaccionar
            ante cada respuesta del usuario
*/

%%%%%%%%%%%%%%% Queries sobre rating %%%%%%%%%%%%%%%%%%%

%%%%%% Rating para todos los generos %%%%%

% cuales son los mejores rating?
respuesta([cuales, son, los, mejores, rating, ?]) :-
    findall((X, _), rating(X, 5), List),
    writeln("Listado de animes con rating 5: "),
    printAnime(List).

% cuales son los peores rating
respuesta([cuales, son, los, peores, rating, ?]) :-
    findall((X, _), rating(X, 1), List),
    writeln("Listado de animes con rating 1: "),
    printAnime(List).

% que animes tienen rating X ?
respuesta([que, animes, tienen, rating, Q, ?]) :-
    checkRange(Q, 5),
    findall((X, _), rating(X, Q), List),
    atom_concat("Listado de animes con rating ", Q, Salida),
    writeln(Salida),
    printAnime(List).

% caso cuando el rating no esta entre 1 y 5
respuesta([que, animes, tienen, rating, _, ?]) :-
    writeln("Disculpa, pero solo me han hablado de ratings entre 1 y 5. Intenta con uno de estos valores.").

%%%%%% Rating para un genero los generos %%%%%

% cuales son los mejores rating?
respuesta([cuales, son, los, mejores, rating, del, genero, G0, ?]) :-
    atom_string(G0,G),
    genero(G),
    findall((X, _), (rating(X, 5), generoAnime(X,Generos), member(G,Generos)), List),
    writeln("Listado de animes con rating 5: "),
    printAnime(List).

% cuales son los peores rating del genero G
respuesta([cuales, son, los, peores, rating, del, genero, G0, ?]) :-
    atom_string(G0,G),
    genero(G),
    findall((X, _), (rating(X, 1), generoAnime(X,Generos), member(G,Generos)), List),
    writeln("Listado de animes con rating 1: "),
    printAnime(List).

% que animes del genero <genero> tienen rating X ?
respuesta([que, animes, del, genero, G0, tienen, rating, Q, ?]) :-
    checkRange(Q, 5),
    atom_string(G0,G),
    genero(G),
    findall((X, _), (rating(X, Q), generoAnime(X,Generos), member(G,Generos)), List),
    atom_concat("Listado de animes con rating ", Q, Salida),
    writeln(Salida),
    printAnime(List).

% caso cuando el rating no esta entre 1 y 5 o el genero es incorrecto
respuesta([cuales, son, los, peores, rating, del, genero, _, ?]):-
    writeln("Asegurate que el genero sea conocido.").

respuesta([cuales, son, los, mejores, rating, del, genero, _, ?]):-
    writeln("Asegurate que el genero sea conocido. ").

respuesta([que, animes, del, genero, _, tienen, rating, _, ?]) :-
    writeln("Asegurate que el rating esta entre 1 y 5 y que el genero sea conocido. Intenta con uno de estos valores.").

%%%%%%%%%%%%%%% Queries sobre popularidad %%%%%%%%%%%%%%%%%%%

% cuales son los mas populares?
respuesta([cuales, son, los, mas, populares, ?]) :-
    findall((X, _), popularidad(X, 10), List),
    writeln("Listado de animes bastante conocidos: "),
    printAnime(List).

% cuales son los menos populares?
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

% que animes son poco conocidos?
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

% que animes son conocidos?
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

% que animes son muy conocidos?
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

%%%%%%%%%%%%%%% Queries sobre genero %%%%%%%%%%%%%%%%%%%

% me gusta <generos>
respuesta([me, gusta|Generos]) :-
    separarGeneros(Generos, Listado),
    writeln("Segun el género te podemos recomendar:\n"),
    buscarPorGenero(Listado, _, rating, decreciente).

% muestrame animes de <genero> por <popularidad|rating> en orden <creciente|decreciente>
respuesta([muestrame, animes, de, X, por, Y, en, orden, W]) :-
    (   Y=rating
    ;   Y=popularidad
    ),
    (   W=creciente
    ;   W=decreciente
    ),
    buscarPorGenero([X], _, Y, W).

% muestrame animes de <genero> por <popularidad|rating>
respuesta([muestrame, animes, de, X, por, Y]) :-
    respuesta([muestrame, animes, de, X, por, Y, en, orden, decreciente]).

% muestrame animes de <genero> por <popularidad|rating> y <rating|popularidad> en orden <creciente|decreciente>
respuesta([muestrame, animes, de, X, por, Y, y, Z, en, orden, W]) :-
    (   Y=rating
    ;   Y=popularidad
    ),
    (   Z=rating
    ;   Z=popularidad
    ),
    (   W=creciente
    ;   W=decreciente
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
    ( 
        W = creciente
        -> sort(2, @>=, Temp, Sorted)
        ; sort(2, @=<, Temp, Sorted)),
    printAnime(Sorted).

% muestrame animes de <genero> por <popularidad|rating> y <rating|popularidad>
% caso decreciente por defecto
respuesta([muestrame, animes, de, X, por, Y, y, Z]) :-
    respuesta([muestrame, animes, de, X, por, Y, y, Z, en, orden, decreciente]).

%%%%%%%%%%%%%%% Queries sobre datos de anime %%%%%%%%%%%%%%%%%%%

% conoces sobre <anime>
% caso en que el anime es conocido
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
    flush_output,
    subirPopularidad(Nombre),
    !.

% conoces sobre <anime>
% caso en que es desconocido y se piden datos al usuario
respuesta([conoces, sobre|X]) :-
    unirCon(X, ' ', Nombre),
    \+ anime(Nombre),
    write('Lo siento, no conozco el anime: "'),
    write(Nombre),
    writeln('"'),
    writeln('Pero si me das informacion adicional, lo puedo tomar en cuenta para la siguiente :)'),
    nl,
    write('¿A que generos pertenece el anime? '),
    readln(Gen),
    separarGeneros(Gen, Gen1),
    leerRating(Rating),
    leerPopularidad(Popularidad),
    generosToString(Gen1, Generos),
    anadirGeneros(Generos),
    assert(anime(Nombre)),
    assert(rating(Nombre, Rating)),
    assert(generoAnime(Nombre, Generos)),
    assert(popularidad(Nombre, Popularidad)),
    assert(cantidadPreguntas(Nombre, 1)),
    writeln('¡Perfecto! La proxima vez que preguntes ya sabre que responder').
    % writeln('Lo siento, aca es donde German te pregunta y agrega a la DB').


%%%%%%%%%%%%%%% Queries sobre rating y popularidad %%%%%%%%%%%%%%%%%%%

% quiero ver un anime <popularidad | categoria> y < categoria | popularidad>
% Sea categoria entendida como:
%   interesante -- rating entre 4 y 5
%   normal      -- rating igual a 3
%   aburrido    -- rating entre 1 y 2
%   popularidad como:
%   muy poco conocido -- popularidad entre 1 y 2
%   poco conocido     -- popularidad entre 3 y 5
%   conocido          -- popularidad entre 6 y 7
%   muy conocido      -- popularidad entre 8 y 9
%   bastante conocido -- popularidad igual a 10

% interesante y muy poco conocido
respuesta([quiero,ver,un, anime| X]):-
        (X=[interesante,y,muy,poco,conocido];
         X=[muy,poco,conocido,e,interesante]),
        Rinf is 4, Rsup is 6,
        Pinf is 1, Psup is 3,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

% interesante y poco conocido
respuesta([quiero,ver,un, anime| X]):-
        (X=[interesante,y,poco,conocido];
         X=[poco,conocido,e,interesante]),
        Rinf is 4, Rsup is 6,
        Pinf is 3, Psup is 6,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

% interesante y conocido
respuesta([quiero,ver,un, anime| X]):-
        (X=[interesante,y,conocido];
         X=[conocido,e,interesante]),
        Rinf is 4, Rsup is 6,
        Pinf is 6, Psup is 8,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

% interesante y muy conocido
respuesta([quiero,ver,un, anime| X]):-
        (X=[interesante,y,muy,conocido];
         X=[muy,conocido,e,interesante]),
        Rinf is 4, Rsup is 6,
        Pinf is 8, Psup is 10,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

% interesante y bastante conocido
respuesta([quiero,ver,un, anime| X]):-
        (X=[interesante,y,bastante,conocido];
         X=[bastante,conocido,e,interesante]),
        Rinf is 4, Rsup is 6,
        Pinf is 10, Psup is 11,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

% normal y muy poco conocido
respuesta([quiero,ver,un, anime| X]):-
        (X=[normal,y,muy,poco,conocido];
         X=[muy,poco,conocido,y,normal]),
        Rinf is 3, Rsup is 4,
        Pinf is 1, Psup is 3,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

% normal y poco conocido
respuesta([quiero,ver,un, anime| X]):-
        (X=[normal,y,poco,conocido];
         X=[poco,conocido,y,normal]),
        Rinf is 3, Rsup is 4,
        Pinf is 3, Psup is 6,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

% normal y conocido
respuesta([quiero,ver,un, anime| X]):-
        (X=[normal,y,conocido];
         X=[conocido,y,normal]),
        Rinf is 3, Rsup is 4,
        Pinf is 6, Psup is 8,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

% normal y muy conocido
respuesta([quiero,ver,un, anime| X]):-
        (X=[normal,y,muy,conocido];
         X=[muy,conocido,y,normal]),
        Rinf is 3, Rsup is 4,
        Pinf is 8, Psup is 10,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

% normal y bastante conocido
respuesta([quiero,ver,un, anime| X]):-
        (X=[normal,y,bastante,conocido];
         X=[bastante,conocido,y,normal]),
        Rinf is 3, Rsup is 4,
        Pinf is 10, Psup is 11,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

% aburrido y muy poco conocido
respuesta([quiero,ver,un, anime| X]):-
        (X=[aburrido,y,muy,poco,conocido];
         X=[muy,poco,conocido,y,aburrido]),
        Rinf is 1, Rsup is 3,
        Pinf is 1, Psup is 3,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

% aburrido y poco conocido
respuesta([quiero,ver,un, anime| X]):-
        (X=[aburrido,y,poco,conocido];
         X=[poco,conocido,y,aburrido]),
        Rinf is 1, Rsup is 3,
        Pinf is 3, Psup is 6,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

% aburrido y conocido
respuesta([quiero,ver,un, anime| X]):-
        (X=[aburrido,y,conocido];
         X=[conocido,y,aburrido]),
        Rinf is 1, Rsup is 3,
        Pinf is 6, Psup is 8,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

% aburrido y muy conocido
respuesta([quiero,ver,un, anime| X]):-
        (X=[aburrido,y,muy,conocido];
         X=[muy,conocido,y,aburrido]),
        Rinf is 1, Rsup is 3,
        Pinf is 8, Psup is 10,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

% aburrido y bastante conocido
respuesta([quiero,ver,un, anime| X]):-
        (X=[aburrido,y,bastante,conocido];
         X=[bastante,conocido,y,aburrido]),
        Rinf is 1, Rsup is 3,
        Pinf is 10, Psup is 11,
        buscarPorPopularidadRating(Rinf,Rsup,Pinf,Psup,QR),
        printGrid(QR).

% predicado para detener la ejecucon de anibot
respuesta([salir]) :-
    halt.

% caso default, en caso de no conocer la respuesta anibot da una 
% respuesta generica
respuesta(_) :- random_member(Respuesta,_), writeln(Respuesta).

%Caso de respuesta generica, no se conoce la pregunta.
/**
    @form random(Value,Value2)
    @descr True siempre. Toma una respuesta al azar de la lista de Respuestas
            genericas y la devuelve en Value
*/
random:random_member(Respuesta,_) :-
    A = ['Quizas quisiste preguntar por los animes de cierta popularidad?',
 'En mi readme puedes ver algunas de las preguntas en las que te podria ayudar',
 'Recuerda que siempre puedes intentar agregar un anime a mi conocimiento, solo preguntame por el y veras',
 'Hay muchos generos de animes por los que me puedes preguntar, intenta con: "me gusta la Aventura" ',
 'Si buscas información sobre un anime en específico solo tienes preguntar si conozco sobre su nombre',
 'Me enseñaron a diferenciar mayúsculas y minúsculas, asi que ¡recuerda prestarles atencion!'],
    length(A, B),
    C is random(B),
    nth0(C, A, Respuesta).


% Inicializacion de Anibot, corre la inicializacion de cantidad de preguntas,
% la popularidad, muestra un mensaje de bienvenida, cambia el simbolo del prompt
% y llama a leerRespuesta para interactuar con el usuario
:- dynamic cantidadPreguntas/2.
:- dynamic popularidad/2.

:- findall(X, anime(X), Animes),
   inicializarCantidadPreguntas(Animes),
   inicializarPopularidad(Animes),
   writeln("¡Hola! Mi nombre es Anibot"),
   writeln("Se mucho sobre animes, pero puedo aprender por lo que me vayas pidiendo"),
   writeln("¿Que necesitas?"),
   prompt('|: ', '> '),
   leerRespuesta.

