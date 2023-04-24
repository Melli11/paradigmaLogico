% Relaciona al dueño con el nombre del juguete
%y la cantidad de años que lo ha tenido
dueño(andy, woody, 8).
dueño(andy, buzz, 5).
dueño(sam, jessie, 3).
dueño(sam, woody, 1).
dueño(sam, soldados, 3).
% Relaciona al juguete con su nombre
% los juguetes son de la forma:
% deTrapo(tematica)
% deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes)
juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(señorCaraDePapa,caraDePapa([original(pieIzquierdo),original(pieDerecho),original(nariz) ])).
% Dice si un juguete es raro
esRaro(deAccion(stacyMalibu, 1, [sombrero])).
% Dice si una persona es coleccionista
esColeccionista(sam).

tematica(deTrapo(Tematica), Tematica).
tematica(deAccion(Tematica, _), Tematica).
tematica(deAccion(Tematica,_,_), Tematica).
tematica(miniFiguras(Tematica, _), Tematica).
tematica(caraDePapa(_), caraDePapa).

esDePlastico(miniFiguras(_,_)).
esDePlastico(caraDePapa(_)).

esCasiRaro(deAccion(_,_)).
esCasiRaro(deAccion(_,_,_)).
esCasiRaro(caraDePapa(_)).
esDeColeccion(deTrapo(_)).
esDeColeccion(Juguete):-
	esCasiRaro(Juguete),
	esRaro(Juguete).

amigoFiel(Dueño, Juguete):-
	dueño(Dueño, Juguete, Tiempo),
	forall((dueño(Dueño, Juguete2, Tiempo2), (Juguete2 \= Juguete)), Tiempo > Tiempo2).

esOriginal(deAccion(_, Partes)):-
	todasOriginales(Partes).
esOriginal(deAccion(_,_, Partes)):-
	todasOriginales(Partes).
esOriginal(caraDePapa(Partes)):-
	todasOriginales(Partes).
todasOriginales([original(_) | Resto]):-
	todasOriginales(Resto).
todasOriginales([original(_)]).
superValioso(Juguetito):-
	juguete(Juguetito, Tipo),
	esOriginal(Tipo),
	esColeccionista(Persona),
	not(dueño(Persona, Juguetito, _)).


buenaPareja(woody, buzz).
buenaPareja(buzz, woody).
buenaPareja(Juguete1, Juguete2):-
	juguete(Juguete1, Tipo1),
	juguete(Juguete2, Tipo2),
	tematica(Tipo1, Tematica),
	tematica(Tipo2, Tematica).

duoDinamico(Dueño, Juguete1, Juguete2):-
	dueño(Dueño, Juguete1, _),
	dueño(Dueño, Juguete2, _),
	buenaPareja(Juguete1, Juguete2).

esdeaccion(deAccion(_,_)).
esdeaccion(deAccion(_,_,_)).
cantFel(_,deTrapo(_), 100).
cantFel(_,miniFiguras(_, Cantidad), Cantidad* 20).
cantFel(Dueño, Juguete, Cantidad):-
	esdeaccion(Juguete),
	esDeColeccion(Juguete),
	esColeccionista(Dueño),
	Cantidad is 120.
cantFel(Dueño, Juguete, Cantidad):-
	esdeaccion(Juguete),
	not(esDeColeccion(Juguete)),
	esColeccionista(Dueño),
	Cantidad is 100.
cantFel(Dueño, Juguete, Cantidad):-
	esdeaccion(Juguete),
	not(esColeccionista(Dueño)),
	esDeColeccion(Juguete),
	Cantidad is 100.
cantFel(Dueño, Juguete, Cantidad):-
	esdeaccion(Juguete),
	not(esColeccionista(Dueño)),
	not(esDeColeccion(Juguete)),
	Cantidad is 100.

cantFel(_, caraDePapa(Partes), Cantidad):-
	darValorDeFelicidadDePartes(Partes, Valores),
	sumlist(Valores, Cantidad).
darValorDeFelicidadDePartes([original(_) | Resto], [5 | Otro]):- darValorDeFelicidadDePartes(Resto, Otro).
darValorDeFelicidadDePartes([repuesto(_) | Resto], [8 | Otro]):- darValorDeFelicidadDePartes(Resto, Otro).
darValorDeFelicidadDePartes([original(_)], [5]).
darValorDeFelicidadDePartes([repuesto(_)], [8]).
felicidadQueDa(Dueño , Juguete, CantidadFel):-
	juguete(Juguete, Tipo),
	cantFel(Dueño ,Tipo, CantidadFel).

felicidad(Dueño, Felicidad):-
	dueño(Dueño, _, _),
	findall(CantidadFel, (dueño(Dueño, Juguete, _), felicidadQueDa( Dueño, Juguete, CantidadFel)), A),
	sumlist(A, Felicidad).

seLoPuedenPrestar(Dueño, Juguetito):-
	dueño(Dueño,_,_),
	findall(Juguetes, dueño(Dueño, Juguetes, _), JuguetesDelPostor),
	length(JuguetesDelPostor, LosQueTieneElPostor),
	dueño(Dueño2, Juguetito, _),
	findall(Juguetes2, dueño(Dueño2, Juguetes2, _), JuguetesDelPrestador),
	length(JuguetesDelPrestador, CantidadDelPrestador),
	CantidadDelPrestador > LosQueTieneElPostor.

puedeJugarCon(Dueño, Juguetito):-
	seLoPuedenPrestar(Dueño, Juguetito).
puedeJugarCon(Dueño, Juguetito):-
	dueño(Dueño, Juguetito, _).

cantidadFelicidad(Dueño, [Juguete | Resto], [Felicidad | Otro]):-
	dueño(Dueño, Juguete, _),
	cantFel(Dueño, Juguete, Felicidad),
	cantidadFelicidad(Dueño, Resto, Otro).
cantidadFelicidad(Dueño, [Juguete], [Felicidad]):-
	dueño(Dueño, Juguete, _),
	cantFel(Dueño, Juguete, Felicidad).

podriaDonar(Dueño, Juguetes, Felicidad):-
	dueño(Dueño, _ , _),
	cantidadFelicidad(Dueño,Juguetes, FelicidadCadaUno),
	sumlist(FelicidadCadaUno, FelicidadDeLista),
	FelicidadDeLista < Felicidad.

%%	Interprete que se refiere a una lista de juguetes que yo le paso
%	y que son de el. no me sale el inversible del 8.
