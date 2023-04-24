mago(harry, mestiza, [coraje, amistad, orgullo, inteligencia]).
mago(ron, pura, [amistad, diversion, coraje]).
mago(hermione, impura, [inteligencia, coraje, responsabilidad, amistad, orgullo]).
mago(hannahAbbott, mestiza, [amistad, diversion]).
mago(draco, pura, [inteligencia, orgullo]).
mago(lunaLovegood, mestiza, [inteligencia, responsabilidad, amistad, coraje]).

odia(harry,slytherin).
odia(draco,hufflepuff).

casa(gryffindor).
casa(hufflepuff).
casa(ravenclaw).
casa(slytherin).

caracteriza(gryffindor,amistad).
caracteriza(gryffindor,coraje).
caracteriza(slytherin,orgullo).
caracteriza(slytherin,inteligencia).
caracteriza(ravenclaw,inteligencia).
caracteriza(ravenclaw,responsabilidad).
caracteriza(hufflepuff,amistad).
caracteriza(hufflepuff,diversion).

permiteEntrar(Casa, Mago):-
	mago(Mago, _, _),
	casa(Casa),
	Casa \= slytherin.
permiteEntrar(slytherin, Mago):-
	mago(Mago, Sangre, _),
	Sangre \= impura.

tieneCaracter(Mago, Casa):-
	mago(Mago, _, Caracteristicas),
	casa(Casa),
	forall(caracteriza(Casa, Caracteristica), member(Caracteristica, Caracteristicas)).
casaPosible(Mago, Casa):-
	permiteEntrar(Casa, Mago),
	tieneCaracter(Mago, Casa),
	not(odia(Mago, Casa)).

esAmistoso(Mago):-
	mago(Mago, _, Lista),
	member(amistad, Lista).
compartenCasas([Mago1, Mago2 | Resto]):-
	casaPosible(Mago1, Casa),
	casaPosible(Mago2, Casa),
	compartenCasas([Mago2 | Resto]).
compartenCasas([Mago1, Mago2]):-
	casaPosible(Mago1, Casa),
	casaPosible(Mago2, Casa).

cadenaDeAmistades(Magos):-
	forall(member(Mago, Magos), esAmistoso(Mago)),
	compartenCasas(Magos).

lugarProhibido(bosque,50).
lugarProhibido(seccionRestringida,10).
lugarProhibido(tercerPiso,75).

alumnoFavorito(flitwick, hermione).
alumnoFavorito(snape, draco).
alumnoOdiado(snape, harry).

hizo(ron, buenaAccion(jugarAlAjedrez, 50)).
hizo(harry, fueraDeCama).
hizo(hermione, irA(tercerPiso)).
hizo(hermione, responder("Donde se encuentra un Bezoar", 15, snape)).
hizo(hermione, responder("Wingardium Leviosa", 25, flitwick)).
hizo(ron, irA(bosque)).
hizo(draco, irA(mazmorras)).
hizo(draco, buenaAccion(serUnGil, 1000)).
hizo(harry, buenaAccion(reventarloAVoldemort, 10000)).

esDe(harry, gryffindor).
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(draco, slytherin).
esDe(hannahAbbott, ravenclaw).
esDe(lunaLovegood,hufflepuff).

suma(_,fueraDeCama, Puntos):-
	Puntos is -50.
suma(_,irA(Lugar), Puntos):-
	lugarProhibido(Lugar, Puntaje),
	Puntos is -Puntaje.
suma(_ ,buenaAccion(_, Puntos), Puntos).
suma(Mago,responder(_, Valor, Profesor), Puntos):-
	alumnoFavorito(Profesor, Mago),
	Puntos is (Valor*2).
suma(Mago, responder(_, _, Profesor), Puntos):-
	alumnoOdiado(Profesor, Mago),
	Puntos is 0.
esBuenAlumno(Mago):-
	hizo(Mago, _),
	forall((hizo(Mago, Accion)), (suma(_,Accion,Puntos), not(Puntos < 0))).
sumaAlumnoDe(Casa, Cantidad):-
	esDe(Mago, Casa),
	findall(Puntos, (hizo(Mago, Accion), suma(Mago, Accion, Puntos)), PuntosMago),
	sumlist(PuntosMago, Cantidad).


puntosDeCasa(Casa, Puntos):-
	casa(Casa),
	findall(Suma, sumaAlumnoDe(Casa, Suma), Total),
	sumlist(Total, Puntos).

casaGanadora(Casa):-
	casa(Casa),
	puntosDeCasa(Casa, Puntos),
	forall((puntosDeCasa(Casa2, OtroP), Casa \= Casa2), Puntos > OtroP).
