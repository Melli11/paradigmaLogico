jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta, pescado], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).

tieneItem(Jugador, Item):-
	jugador(Jugador, Inventario, _),
	member(Item, Inventario).

sePreocupaPorSuSalud(Jugador):-
	jugador(Jugador, Inventario,_),
	setof(Item,( member(Item, Inventario), comestible(Item)), A),
	length(A, X),
	X > 1.
sePreocupaSin(Jugador):-
	comestible(Item1),
	comestible(Item2),
	Item1 \= Item2,
	tieneItem(Jugador, Item1),
	tieneItem(Jugador, Item2).

cantidadDelItem(Jugador, Item, Cantidad):-
	jugador(Jugador, Inventario, _),
	jugador(_,I,_),
	member(Item, I),
	findall(Item, member(Item, Inventario), A),
	length(A, Cantidad).

tieneMasDe(Jugador, Item):-
	jugador(Jugador,_,_),
	tieneItem(Jugador, Item),
	forall((jugador(Jugador2,_,_), Jugador \= Jugador2), tieneMenosQueElPrimero(Jugador, Jugador2, Item)).
tieneMenosQueElPrimero(Jugador1, Jugador2, Item):-
	cantidadDelItem(Jugador1, Item, Cant1),
	cantidadDelItem(Jugador2, Item, Cant2),
	Cant2 < Cant1.

%2)

hayMonstruos(Lugar):-
	lugar(Lugar,_,Oscuridad),
	Oscuridad > 6.
correPeligro(Jugador):-
	jugador(Jugador,_,_),
	lugar(Lugar,Jugadores,_),
	hayMonstruos(Lugar),
	member(Jugador, Jugadores).
correPeligro(Jugador):-
	jugador(Jugador, Inventario, Hambre),
	Hambre < 4,
	forall(member(Item, Inventario), not(comestible(Item))).
hambrienta(Persona):-
	jugador(Persona,_,Hambre),
	Hambre < 4.
calcularNivel(Lugar, _, _, Nivel):-
	hayMonstruos(Lugar),
	Nivel is 100.
calcularNivel(_, Gente, _, Nivel):-
	length(Gente, X),
	X >0,
	findall(Persona, (member(Persona, Gente), hambrienta(Persona)), A),
	length(A, Hambrientas),
	length(Gente, Poblacion),
	Nivel is ((Hambrientas/Poblacion)*100).
calcularNivel(_, Gente, Oscuridad, Nivel):-
	length(Gente, 0),
	Nivel is Oscuridad.

nivelPeligrosidad(Lugar, Nivel):-
	lugar(Lugar, Gente, Oscuridad),
	calcularNivel(Lugar, Gente, Oscuridad, Nivel).


item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1)]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).

dispone(Persona, [itemSimple(Item, Cantidad) | Resto]):-
	cantidadDelItem(Persona, Item, CantidadQuePosee),
	Cantidad =< CantidadQuePosee,
	dispone(Persona, Resto).

dispone(Persona, [itemCompuesto(Item) | Resto]):-
	puedeConstruir(Persona, Item),
	dispone(Persona, Resto).
dispone(Persona, [itemSimple(Item, Cantidad)]):-
	cantidadDelItem(Persona, Item, CantidadQuePosee),
	Cantidad =< CantidadQuePosee.
dispone(Persona, [itemCompuesto(Item)]):-
	puedeConstruir(Persona, Item).


puedeConstruir(Persona, Objeto):-
	item(Objeto, Elementos),
	dispone(Persona, Elementos).

