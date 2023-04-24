jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [loly], 6).

comestible(pan). comestible(panceta). comestible(pollo). comestible(pescado).

tieneItem(Jugador,Item):-
    jugador(Jugador,Items,_),
    member(Item,Items).

sePreocupaPorSuSalud(Jugador):-
    jugador(Jugador,Items,_),
    member(Item,Items),
    comestible(Item).

cantidadDeItem(Jugador,Item,Cantidad):-
    existe(Item),
    findall(Item,(jugador(Jugador,Items,_),member(Item,Items)),Itemms),
    length(Itemms,Cantidad).

existe(Item):-
    jugador(_,Is,_),
    member(Item,Is).

tieneMasDe(Jugador,Item):-
    tieneItem(Jugador,Item),
    cantidadDeItem(Jugador,Item,Cantidad),
    forall(cantidadDeItem(_,Item,Cantidad2),Cantidad>=Cantidad2).

hayMonstruos(Lugar):-
    lugar(Lugar,_,Oscuridad),
    Oscuridad >=6.

correPeligro(Jugador):-
    estaEn(Jugador,Lugar),
    hayMonstruos(Lugar).
correPeligro(Jugador):-
    jugador(Jugador,_,Hambre),
    not(sePreocupaPorSuSalud(Jugador)),
    Hambre<4.


estaEn(Jugador,Lugar):-
    lugar(Lugar,Js,_),
    member(Jugador,Js).

nivelPeligrosidad(Lugar,100):-
    hayMonstruos(Lugar).

nivelPeligrosidad(Lugar,Nivel):-
    lugar(Lugar,[],Oscuridad),
    Nivel is Oscuridad * 10.

nivelPeligrosidad(Lugar,Nivel):-
    not(hayMonstruos(Lugar)),
    lugar(Lugar,Js,_),
    findall(Jugador,(estaEn(Jugador,Lugar),tieneHambre(Jugador)),Hambrientos),
    length(Js,PoblacionTotal),
    length(Hambrientos,Hs),
    Nivel is 100*Hs/PoblacionTotal.

tieneHambre(Jugador):-
    jugador(Jugador,_,Hambre),
    Hambre<4.

