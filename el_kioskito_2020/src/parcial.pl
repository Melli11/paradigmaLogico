

trabajador(dodain,atiende(lunes,9,15)).
trabajador(dodain,atiende(miercoles,9,15)).
trabajador(dodain,atiende(viernes,9,15)).

trabajador(lucas,atiende(martes,10,20)).
trabajador(juanC,atiende(sabados,18,22)).
trabajador(lucas,atiende(domingos,18,22)).

trabajador(juanFdS,atiende(jueves,10,20)).
trabajador(juanFdS,atiende(viernes,12,20)).

trabajador(leoC,atiende(lunes,14,18)).
trabajador(leoC,atiende(miercoles,14,18)).
trabajador(martu,atiende(miercoles,23,24)).

% Punto 1: calentando motores

% vale atiende los mismos días y horarios que dodain y juanC
trabajador(vale,atiende(Dias,Hora_Inicio,Hora_Fin)):-
    trabajador(dodain,atiende(Dias,Hora_Inicio,Hora_Fin)).

trabajador(vale,atiende(Dias,Hora_Inicio,Hora_Fin)):-
    trabajador(juanC,atiende(Dias,Hora_Inicio,Hora_Fin)).


% maiu está pensando si hace el horario de 0 a 8 los martes y miércoles

% RTA: No será necesario modelar este caso, ya que solo consideraremos las personas que
% trabajan con un horario definido y por el principio de UC todo aquello que no es cierto
% sera falso

% Punto 2: quién atiende el kiosko... (2 puntos)

trabajaEnEseHorario(Persona,Dia,Hora):-
    rangoHorario(Persona,Dia,Horario),
    member(Hora,Horario).

% Rango Horario:
rangoHorario(Persona,Dia,Horario_De_Atencion):-
    trabajador(Persona,atiende(Dia,Horas_Inicio,Horas_Fin)),
    findall(TotalHoras,between(Horas_Inicio, Horas_Fin,TotalHoras),Horario_De_Atencion).
    
% Punto 3: Forever alone (2 puntos)
% Definir un predicado que permita saber si una persona en un día y horario determinado
% está atendiendo ella sola.

atiendeSolo(Persona,Dia,Hora):-
    trabajaEnEseHorario(Persona,Dia,Hora),
    not((trabajaEnEseHorario(OtraPersona,Dia,Hora),OtraPersona\=Persona)).

% Punto 4: posibilidades de atención (3 puntos / 1 punto)


% Punto 5: ventas / suertudas (4 puntos)

% En el kiosko tenemos por el momento tres ventas posibles:
% ● golosinas, en cuyo caso registramos el valor en plata
% ● cigarrillos, de los cuales registramos todas las marcas de cigarrillos que se vendieron (ej: Marlboro y Particulares)
% ● bebidas, en cuyo caso registramos si son alcohólicas y la cantidad
% Punto 5: ventas / suertudas (4 puntos)

venta(dodain,fecha(lunes,10,agosto),[golosinas(1200),cigarrillos(jockey),golosinas(50)]).
venta(dodain,fecha(miercoles,12,agosto),[bebidas(alc,8),bebidas(no_alc,1),golosinas(10)]).
venta(martu,fecha(miercoles,12,agosto),[golosinas(1000),cigarrillos([chesterfield,colorado,parisienes])]). 
venta(lucas,fecha(miercoles,11,agosto),[golosinas(600)]).
venta(lucas,fecha(miercoles,18,agosto),[bebidas(no_alc,2),cigarrillos(derby)]).
venta(jose,fecha(miercoles,18,agosto),[bebidas(alc,2),cigarrillos(derby)]). %% ejemplo
venta(fer,fecha(miercoles,18,agosto),[bebidas(alc,5),cigarrillos(derby)]). %% ejemplo

% Punto 5a
% Queremos saber si una persona vendedora es suertuda, esto ocurre si para todos los
% días en los que vendió, la primera venta que hizo fue importante. Una venta es
% importante

esSuertuda(UnaPersona):-
    venta(UnaPersona,_,_),
    forall(venta(UnaPersona,_,Venta),laPrimeraVentaFueImportante(UnaPersona,Venta)).

laPrimeraVentaFueImportante(UnaPersona,TotalVentas):-
    venta(UnaPersona,_,TotalVentas),
    primeraVenta(UnaPersona,PrimeraVenta,TotalVentas),
    esImportante(PrimeraVenta).

primeraVenta(UnaPersona,PrimeraVenta,ListaDeVentas):-
    venta(UnaPersona,_,ListaDeVentas),
    primeroDeLaLista(PrimeraVenta,ListaDeVentas).

primeroDeLaLista(X,[X|_]).

esImportante(golosinas(Valor)):-
    Valor > 100.

esImportante(cigarrillos(Marcas)):-
    length(Marcas, Cantidad),
    Cantidad > 2.

esImportante(bebidas(alc,_)).
esImportante(bebidas(_,Cantidad)):-
    Cantidad > 5.


:- begin_tests(parcial).

test(punto1_vale_atiende_mismos_dias_que_dodain_y_juanC,nondet):-

    trabajador(vale,atiende(lunes, 9, 15)),
    trabajador(vale,atiende(miercoles, 9, 15)),
    trabajador(vale,atiende(viernes, 9, 15)),
    trabajador(vale,atiende(sabados, 18, 22)).

% test(nadie_hace_el_horario_de_leo):-
test(punto2_quien_atiende,nondet):-
    trabajaEnEseHorario(dodain,lunes,14),
    trabajaEnEseHorario(leoC,lunes,14),
    trabajaEnEseHorario(vale,lunes,14),
    trabajaEnEseHorario(juanC,sabados,18),
    trabajaEnEseHorario(juanFdS,jueves,11),
    trabajaEnEseHorario(vale,lunes,10),
    trabajaEnEseHorario(vale,miercoles,10),
    trabajaEnEseHorario(vale,viernes,10).

test(punto3_forver_alone,nondet):-
    atiendeSolo(lucas,martes,19),
    atiendeSolo(juanFdS,jueves,10),
    \+atiendeSolo(martu,miercoles,22),
    \+atiendeSolo(dodain,lunes,10).
    
:- end_tests(parcial).
