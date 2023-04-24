mago(harry, mestiza, [coraje, amistad, orgullo, inteligencia]).
mago(ron, pura, [amistad, diversion, coraje]).
mago(hermione, impura, [inteligencia, coraje, responsabilidad, amistad, orgullo]).
mago(hannahAbbott, mestiza, [amistad, diversion]).
mago(draco, pura, [inteligencia, orgullo]).
mago(lunaLovegood, mestiza, [inteligencia, responsabilidad, amistad, coraje]).

odia(harry,slytherin).
odia(draco,hufflepuff).

casa(gryffindor). casa(hufflepuff). casa(ravenclaw). casa(slytherin).

caracteriza(gryffindor,amistad).
caracteriza(gryffindor,coraje).
caracteriza(slytherin,orgullo).
caracteriza(slytherin,inteligencia).
caracteriza(ravenclaw,inteligencia).
caracteriza(ravenclaw,responsabilidad).
caracteriza(hufflepuff,amistad).
caracteriza(hufflepuff,diversion).

puedeEntrar(Mago,slytherin):-
    mago(Mago,_,_),
    not(mago(Mago,impura,_)).

puedeEntrar(Mago,Casa):-
   mago(Mago,_,_),
   casa(Casa),
   Casa\=slytherin.

tieneCaracter(Mago,Casa):-
    mago(Mago,_,Caracteristicas),
    foreach(caracteriza(Casa,Atributo),member(Atributo, Caracteristicas)).

casaPosible(Mago,Casa):-
    tieneCaracter(Mago,Casa),
    puedeEntrar(Mago,Casa),
    not(odia(Mago,Casa)).

cadenaDeAmistad([L|Ls]):-
    mago(L,_,Atributos),
    member(amistad,Atributos),
    cadenaDeAmistad(Ls).

cadenaDeAmistad([]).


%segundaPArte

lugarProhibido(bosque,50).
lugarProhibido(seccionRestringida,10).
lugarProhibido(tercerPiso,75).

alumnoFavorito(flitwick, hermione).
alumnoFavorito(snape, draco).
alumnoOdiado(snape, harry).

hizo(ron, buenaAccion(jugarAlAjedrez, 50)).
hizo(lunaLovegood, buenaAccion(jugarAlAjedrez, 50)).

hizo(harry, fueraDeCama).
hizo(hermione, irA(tercerPiso)).
hizo(hermione, responder('Donde se encuentra un Bezoar', 15, snape)).
hizo(hermione, responder('Wingardium Leviosa', 25, flitwick)).
hizo(ron, irA(bosque)).
hizo(draco, irA(mazmorras)).

esDe(harry, gryffindor).
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(draco, slytherin).
esDe(hannahAbott,hufflepuff).
esDe(lunaLovegood,ravenclaw).

esBuenAlumno(Alumno):
    hizo(Alumno,_),
   not(hizo(Alumno,fueraDeCama)),
   not((hizo(Alumno,irA(Lugar)),
    lugarProhibido(Lugar,_))).

puntosDeCasa(Casa,Suma):-
    findall(Puntaje,(esDe(Alguien,Casa),hizo(Alguien,Algo),puntuar(Algo,Puntaje)),Puntos),
    sum_list(Puntos,Suma).


puntuar(irA(Lugar),Puntos):-
    lugarProhibido(Lugar,Puntos).
puntuar(fueraDeCama,-50).
puntuar(buenaAccion(_,Puntos),Puntos).
puntuar(responder(_,Puntos,_),Puntos).

puntajeCasa(gryffindor,482).
puntajeCasa(slytherin,472).
puntajeCasa(ravenclaw,426).
puntajeCasa(hufflepuff,352).







