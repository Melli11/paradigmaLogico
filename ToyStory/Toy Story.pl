% Relaciona al due�o con el nombre del juguete
%y la cantidad de a�os que lo ha tenido
due�o(andy, woody, 8).
due�o(andy, buzz, 5).
due�o(sam, jessie, 3).
due�o(sam, woody, 1).
due�o(sam, soldados, 3).
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
juguete(se�orCaraDePapa,caraDePapa([original(pieIzquierdo),original(pieDerecho),original(nariz) ])).
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

amigoFiel(Due�o, Juguete):-
	due�o(Due�o, Juguete, Tiempo),
	forall((due�o(Due�o, Juguete2, Tiempo2), (Juguete2 \= Juguete)), Tiempo > Tiempo2).

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
	not(due�o(Persona, Juguetito, _)).


buenaPareja(woody, buzz).
buenaPareja(buzz, woody).
buenaPareja(Juguete1, Juguete2):-
	juguete(Juguete1, Tipo1),
	juguete(Juguete2, Tipo2),
	tematica(Tipo1, Tematica),
	tematica(Tipo2, Tematica).

duoDinamico(Due�o, Juguete1, Juguete2):-
	due�o(Due�o, Juguete1, _),
	due�o(Due�o, Juguete2, _),
	buenaPareja(Juguete1, Juguete2).

esdeaccion(deAccion(_,_)).
esdeaccion(deAccion(_,_,_)).
cantFel(_,deTrapo(_), 100).
cantFel(_,miniFiguras(_, Cantidad), Cantidad* 20).
cantFel(Due�o, Juguete, Cantidad):-
	esdeaccion(Juguete),
	esDeColeccion(Juguete),
	esColeccionista(Due�o),
	Cantidad is 120.
cantFel(Due�o, Juguete, Cantidad):-
	esdeaccion(Juguete),
	not(esDeColeccion(Juguete)),
	esColeccionista(Due�o),
	Cantidad is 100.
cantFel(Due�o, Juguete, Cantidad):-
	esdeaccion(Juguete),
	not(esColeccionista(Due�o)),
	esDeColeccion(Juguete),
	Cantidad is 100.
cantFel(Due�o, Juguete, Cantidad):-
	esdeaccion(Juguete),
	not(esColeccionista(Due�o)),
	not(esDeColeccion(Juguete)),
	Cantidad is 100.

cantFel(_, caraDePapa(Partes), Cantidad):-
	darValorDeFelicidadDePartes(Partes, Valores),
	sumlist(Valores, Cantidad).
darValorDeFelicidadDePartes([original(_) | Resto], [5 | Otro]):- darValorDeFelicidadDePartes(Resto, Otro).
darValorDeFelicidadDePartes([repuesto(_) | Resto], [8 | Otro]):- darValorDeFelicidadDePartes(Resto, Otro).
darValorDeFelicidadDePartes([original(_)], [5]).
darValorDeFelicidadDePartes([repuesto(_)], [8]).
felicidadQueDa(Due�o , Juguete, CantidadFel):-
	juguete(Juguete, Tipo),
	cantFel(Due�o ,Tipo, CantidadFel).

felicidad(Due�o, Felicidad):-
	due�o(Due�o, _, _),
	findall(CantidadFel, (due�o(Due�o, Juguete, _), felicidadQueDa( Due�o, Juguete, CantidadFel)), A),
	sumlist(A, Felicidad).

seLoPuedenPrestar(Due�o, Juguetito):-
	due�o(Due�o,_,_),
	findall(Juguetes, due�o(Due�o, Juguetes, _), JuguetesDelPostor),
	length(JuguetesDelPostor, LosQueTieneElPostor),
	due�o(Due�o2, Juguetito, _),
	findall(Juguetes2, due�o(Due�o2, Juguetes2, _), JuguetesDelPrestador),
	length(JuguetesDelPrestador, CantidadDelPrestador),
	CantidadDelPrestador > LosQueTieneElPostor.

puedeJugarCon(Due�o, Juguetito):-
	seLoPuedenPrestar(Due�o, Juguetito).
puedeJugarCon(Due�o, Juguetito):-
	due�o(Due�o, Juguetito, _).

cantidadFelicidad(Due�o, [Juguete | Resto], [Felicidad | Otro]):-
	due�o(Due�o, Juguete, _),
	cantFel(Due�o, Juguete, Felicidad),
	cantidadFelicidad(Due�o, Resto, Otro).
cantidadFelicidad(Due�o, [Juguete], [Felicidad]):-
	due�o(Due�o, Juguete, _),
	cantFel(Due�o, Juguete, Felicidad).

podriaDonar(Due�o, Juguetes, Felicidad):-
	due�o(Due�o, _ , _),
	cantidadFelicidad(Due�o,Juguetes, FelicidadCadaUno),
	sumlist(FelicidadCadaUno, FelicidadDeLista),
	FelicidadDeLista < Felicidad.

%%	Interprete que se refiere a una lista de juguetes que yo le paso
%	y que son de el. no me sale el inversible del 8.
