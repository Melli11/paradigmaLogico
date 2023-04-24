puerto(puerto1,argentina).
puerto(puerto2,espana).
puerto(puerto3,holanda).
puerto(puerto4,japon).

barco(john,auda,32,10).
barco(lock,auda2,23,5).
barco(kuke,auda3,10,1).
barco(barbosa,auda4,1,1).
%barco(flor,unicornio,100,100).
barco(jackSparrow,perlaNegra,25,50).
barco(davyJones,holandesErrante,100,100).



viaje(puerto1,puerto2,100,embarcacion(galeon,23)).
viaje(puerto2,puerto3,75,embarcacion(galera,espana)).
viaje(puerto2,puerto1,75,embarcacion(galera,argentina)).
viaje(puerto3,puerto2,25,embarcacion(carabela,23,100)).
viaje(puerto1,puerto3,50,embarcacion(galeon,23)).
viaje(puerto1,puerto4,1000,embarcacion(galeon,60)).

rutaEntre(puerto1,puerto4,100).
rutaEntre(puerto1,puerto2,50).
rutaEntre(puerto2,puerto1,40).
rutaEntre(puerto2,puerto3,30).
rutaEntre(puerto3,puerto2,20).
rutaEntre(puerto1,puerto3,10).


cualPuerto(Nombre,puerto(Nombre,Pais)):-
    puerto(Nombre,Pais).

puedeIntervenir(Capitan,Embarcacion):-
    poderio(Capitan,Poderio),
    resistencia(Embarcacion,Resistencia),
    Poderio>Resistencia.

poderio(Capitan,Poderio):-
    barco(Capitan,_,Cantidad,Espiritu),
    Poderio is (2+Cantidad)*Espiritu.

resistencia(embarcacion(galeon,Canones),Resistencia):-
    viaje(PuertoOrigen,PuertoDestino,_,embarcacion(galeon,Canones)),
    rutaEntre(PuertoOrigen,PuertoDestino,Distancia),
    Resistencia is Canones*100/Distancia.

resistencia(embarcacion(carabela,_,Soldados),Resistencia):-
    viaje(_,_,Mercancia,embarcacion(carabela,_,Soldados)),
    Resistencia is Mercancia/10+Soldados.

resistencia(embarcacion(galera,espana),Resistencia):-
    viaje(Po,Pd,_,embarcacion(galera,espana)),
    rutaEntre(Po,Pd,D),
    Resistencia is 100/D.


resistencia(embarcacion(galera,Pais),Resistencia):-
    Pais\=espana,
    viaje(_,_,Mercancia,embarcacion(galera,_)),
    Resistencia is Mercancia*10.

bloqueo(_,puerto(Puerto,_),BotinTotal):-
    findall(Mercancia,viaje(Puerto,_,Mercancia,_),Botin),
    findall(Mercancia,viaje(_,Puerto,Mercancia,_),Botin2),
    sum_list(Botin,B1),sum_list(Botin2,B2),
    BotinTotal is B1+B2.

usaElPuerto(Embarcacion,Puerto):-
    viaje(_,Puerto,_,Embarcacion).

usaElPuerto(Embarcacion,Puerto):-
    viaje(Puerto,_,_,Embarcacion).


tipoDePirata(Capitan,decadente):-
    barco(Capitan,_,Piratas,_),
    Piratas<10,
    not(puedeIntervenir(Capitan,_)).

tipoDePirata(Capitan,terrorDelPuerto):-
    controlaPuerto(Capitan,_).

existeCapitan(Capitan):-
    barco(Capitan,_,_,_).

controlaPuerto(Capitan,Puerto):-
    existeCapitan(Capitan),
    puerto(Puerto,_),
    findall(Pirata,intervenirPuerto(Pirata,Puerto),Piratas),
    length(Piratas,1),
    member(Capitan,Piratas).

intervenirPuerto(Capitan,Puerto):-
    existeCapitan(Capitan),
    puerto(Puerto,_),
    forall(usaElPuerto(Embarcacion,Puerto),puedeIntervenir(Capitan,Embarcacion)).
