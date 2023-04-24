%tarea(agente, tarea, ubicacion)
%tareas:
%  ingerir(descripcion, tama�o, cantidad)
%  apresar(malviviente, recompensa)
%  asuntosInternos(agenteInvestigado)
%  vigilar(listaDeNegocios)

tarea(jefeSupremo, vigilar([congreso,casaRosada,tribunales,alfajoreria]),laBocsaa).
tarea(vega, apresar(neneCarrizo,50),avellanedaas).
tarea(vigilanteDelBarrio, ingerir(pizza, 1.5, 2),laBoca).
tarea(vigilanteDelBarrio, vigilar([pizzeria, heladeria]), barracas).
tarea(canaBoton, asuntosInternos(vigilanteDelBarrio), barracas).
tarea(sargentoGarcia, vigilar([pulperia, haciendaDeLaVega, plaza]),puebloDeLosAngeles).
tarea(sargentoGarcia, ingerir(vino, 0.5, 5),puebloDeLosAngeles).
tarea(sargentoGarcia, apresar(elzorro, 100), puebloDeLosAngeles).
tarea(vega, apresar(neneCarrizo,50),avellaneda).
tarea(jefeSupremo, vigilar([congreso,casaRosada,tribunales,alfajoreria]),laBoca).

%Las ubicaciones que existen son las siguientes:
ubicacion(puebloDeLosAngeles).
ubicacion(avellaneda).
ubicacion(barracas).
ubicacion(marDelPlata).
ubicacion(laBoca).
ubicacion(uqbar).

%jefe(jefe, subordinado)
jefe(jefeSupremo,vega ).
jefe(vega, vigilanteDelBarrio).
jefe(vega, canaBoton).
jefe(jefeSupremo,sargentoGarcia).

%1
frecuenta(Agente, Lugar):-
	tarea(Agente, _, Lugar).
frecuenta(Agente, buenosAires):-
	tarea(Agente,_,_).
frecuenta(vega, quilmes).
frecuenta(Agente, marDelPlata):-
	tarea(Agente, vigilar(Lugares), _),
	member(alfajoreria, Lugares).

%2
inaccesible(Lugar):-
	ubicacion(Lugar),
	not(frecuenta(_,Lugar)).

%3

afincado(Agente):-
	tarea(Agente,_,Lugar),
	forall(tarea(Agente,_,Lugar2), Lugar = Lugar2).

%4
sublista([],_).
sublista([X|Resto], [X|Otro]):- sublista(Resto, Otro).
sublista(Lista, [_ |Algo]):- sublista(Lista, Algo).

esCadenaDeMando([Agente1, Agente2 | Resto]):-
	jefe(Agente1, Agente2),
	esCadenaDeMando([Agente2 | Resto]).
esCadenaDeMando([Agente1, Agente2]):-
	jefe(Agente1, Agente2).

cadenaDeMando(Sub):-
	findall(Agente, tarea(Agente,_,_), Agentes),
	sublista(Sub, Agentes),
	esCadenaDeMando(Sub).

%5
valor(vigilar(Lista), Valor):-
	length(Lista, Cantidad),
	Valor is Cantidad*5.
valor(ingerir(_,Tama�o, Cantidad), Valor):-
	Valor is -(Tama�o*Cantidad)*10.
valor(apresar(_,Algo), Valor):-
	Valor is (Algo/2).
valor(asuntosInternos(Agente), Valor):-
	puntaje(Agente, Puntaje),
	Valor is Puntaje*2.
puntaje(Agente, Puntaje):-
	findall(Valor, (tarea(Agente, Tarea, _), valor(Tarea, Valor)), Valores),
	sumlist(Valores, Puntaje).
agentePremiado(Agente):-
	tarea(Agente,_,_),
	puntaje(Agente, Puntaje),
	forall((tarea(Agente2,_,_), Agente2\=Agente), (puntaje(Agente2, Puntaje2) ,Puntaje > Puntaje2)).
