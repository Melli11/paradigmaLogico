%Modelado 1ra version
% mago(nombreCompleto,FechaDeNacimiento,SangrePura)
% mago(nombreCompleto(harry,potter),nacio(31,07,1980),si).
% mago(nombreCompleto(hermione,granger),nacio(19,09,1979),no).
% mago(nombreCompleto(tom,riddle),nacio(19,09,1979),si).
% mago(nombreCompleto(sirius,black),nacio(03,11,1959),si).
% mago(nombreCompleto(peter,pettigrew),nacio(01,09,1959),si).
% mago(nombreCompleto(ginny,weasley),nacio(11,08,1981),si).
% mago(nombreCompleto(minerva,mcGonagall),nacio(04,11,1935),no).

mago(harry_Potter,nacio(31,07,1980)).
mago(hermione_Granger,nacio(19,09,1979)).
mago(tom_Riddle,nacio(19,09,1979)).
mago(sirius_Black,nacio(03,11,1959)).
mago(ginny_Weasley,nacio(11,08,1981)).
mago(peter_Pettigrew,nacio(01,09,1959)).
mago(minerva_McGonagall,nacio(04,11,1935)).
esSangrePura(harry_Potter).
esSangrePura(tom_Riddle).
esSangrePura(sirius_Black).
esSangrePura(peter_Pettigrew).
esSangrePura(ginny_Weasley).
esSangrePura(minerva_McGonagall).


%Modelado 1ra version
% aptitudes(nombreCompleto,notas(Encantamiento,HistoriaMagica,Defensa),Animagos,Quiddich(PartidosTotales,PartidosGanados)).

% aptitudes(nombreCompleto(harry,potter),notas(6,7,10),no,quiddich(15,10)).
% aptitudes(nombreCompleto(hermione,granger),notas(10,10,9),no,quiddich(0,0)).
% aptitudes(nombreCompleto(tom,riddle),notas(9,9,10),no,quiddich(0,0)).
% aptitudes(nombreCompleto(sirius,black),notas(5,3,8),si,quiddich(0,0)).
% aptitudes(nombreCompleto(peter,pettigrew),notas(4,6,2),si,quiddich(10,3)).
% aptitudes(nombreCompleto(ginny,weasley),notas(7,7,8),no,quiddich(20,15)).
% aptitudes(nombreCompleto(minerva,mcGonagall),notas(8,9,10),no,quiddich(0,0)).


aptitud(harry_Potter, notas(6,7,10)).
aptitud(harry_Potter, quiddich(15,10)).
aptitud(tom_Riddle,notas(9,9,10)).
aptitud(hermione_Granger, notas(10,10,9)).
aptitud(sirius_Black,notas(5,3,8)).
aptitud(sirius_Black,animago).
aptitud(minerva_McGonagall,notas(8,9,10)).
aptitud(ginny_Weasley,notas(7,7,8)).
aptitud(ginny_Weasley,quiddich(20,15)).
aptitud(peter_Pettigrew,notas(4,6,2)).
aptitud(peter_Pettigrew,quiddich(10,3)).
aptitud(peter_Pettigrew,animago).

% % 1)  La calificación de una aptitud para una profesion en particular

% calificacion(Profesion,Aptitudes,Calificacion)
% calificacion/3

calificacion(mortifago,aptitud(Mago,notas(Encantamiento,_,_)),Calificacion):-
    aptitud(Mago,notas(Encantamiento,_,_)),
    Calificacion is Encantamiento * 2 .

calificacion(mortifago,aptitud(Mago,notas(_,_,Defensa_Artes_Oscuras)),Calificacion):-
    aptitud(Mago,notas(_,_,Defensa_Artes_Oscuras)),
    Defensa_Artes_Oscuras >= 10,
    Calificacion is 20 + Defensa_Artes_Oscuras.

calificacion(mortifago,aptitud(Mago,notas(_,_,Defensa_Artes_Oscuras)),Calificacion):-
    aptitud(Mago,notas(_,_,Defensa_Artes_Oscuras)),
    Defensa_Artes_Oscuras < 10,
    Calificacion is Defensa_Artes_Oscuras.

% % calificacion(mortifago,Aptitudes,Calificacion)
% % calificacion/3

calificacion(auror,aptitud(Mago,notas(_,_,Defensa_Artes_Oscuras)),Calificacion):-
    aptitud(Mago,notas(_,_,Defensa_Artes_Oscuras)),
    Calificacion is Defensa_Artes_Oscuras * 7 .

calificacion(auror,aptitud(Mago,quiddich(PartidosTotales,PartidosGanados)),Calificacion):-
    aptitud(Mago,quiddich(PartidosTotales,PartidosGanados)),
    partidosGanadosSobrePerdidos(PartidosTotales,PartidosGanados,Cociente),
    Calificacion is  60 * Cociente.

calificacion(auror,Mago,40):-
    aptitud(Mago,animago).

% calificacion(auror,aptitud(_,animago),40).%no es inversible

%Predicado Auxiliar

partidosGanadosSobrePerdidos(0,_,0). % si no jugo ningun partido, entonces el indice es 0
partidosGanadosSobrePerdidos(MismaCantidad,MismaCantidad,1):- % si ganó la misma cantidad de partidos que jugó su indice es de 1
    MismaCantidad >= 1.

partidosGanadosSobrePerdidos(PartidosTotales,PartidosGanados,Cociente):- % partidosGanadosSobrePerdidos resuelve  el cociente entre la cantidad de partidos ganados sobre los perdidos
    PartidosPerdidos is PartidosTotales - PartidosGanados,
    PartidosPerdidos > 0, % evito la division por 0
    Cociente is PartidosGanados/PartidosPerdidos.


% Nota: 
% Para el resto de las profesiones que no sean auror ni mortifago no se tiene una calificacion
% Por el principio de universo cerrado, no se consideran las otras profesiones y por lo tanto será falsa cualquier
% consulta realizada para obtener una calificacion para otra profesion (que no sean auror y  mortifago)

% 2) Es apto para una profesion

% a)    Todas las profesiones requieren haberse sacado mas de un 5 en historia magica.

esApto(Profesion,Mago):-
    requisitoNotaDeHistoriaMayorACinco(Mago),
    esAptoPara(Profesion,Mago).

requisitoNotaDeHistoriaMayorACinco(Mago):-
    mago(Mago,_),
    forall(aptitud(Mago,notas(_,CalificacionHistoriaMagica,_)),CalificacionHistoriaMagica > 5).
%   calificacion(Profesion,Aptitud,Calificacion)
    % "Del conjunto de magos y sus notas, quiero saber solo aquellos cuya calificacion en historia magica sea mayor a 5".

% esApto /2 

% b)    Para ser apto para ser mortifago el mago tiene que tener alguna aptitud que le de una calificación
%  mayor a 30 para esta profesión   ser sangre pura y haber nacido antes de 1960.


esAptoPara(mortifago,Mago):-
        mago(Mago,nacio(_,_,AnioNacimiento)),
        esSangrePura(Mago),
        calificacion(mortifago,aptitud(Mago,_),Calificacion),
        Calificacion > 30,
        AnioNacimiento < 1960.

% c)    Para ser apto para ser auror todas las aptitudes de auror del mago tienen que darle una clasificación mayor a 15.
esAptoPara(auror,Mago):-
    mago(Mago,_),
    forall(calificacion(auror,aptitud(Mago,_),Calificacion),Calificacion>15).

% d) Para ser apto para ser jugador de quidditch tiene que haber ganado al menos la mitad de sus partidos

esAptoPara(jugador,Nombre):-
    mago(Nombre,_),
    aptitud(Nombre,quiddich(PartidosTotales,PartidosGanados)),
    partidosGanadosSobrePerdidos(PartidosTotales,PartidosGanados,Valor),
    Valor >= 2.

% e) Para ser apto para ser adivinador el mago tiene que tener una fecha de nacimiento 
% donde la suma de su década + su mes + su día sea igual a 100.

esAptoPara(adivinador,Nombre):-
    mago(Nombre,nacio(Dia,Mes,Anio)),
    calculoDeDecada(Anio,Decada),
    laSumaEsIgualA(Dia,Mes,Decada,100).

calculoDeDecada(Anio,Decada):-
    Decenas is Anio mod 100,
    Unidades is Anio mod 10,
    Decada is Decenas - Unidades. 

laSumaEsIgualA(Dia,Mes,Decada,Resultado):-
    Resultado is Dia + Mes + Decada.

% 3) Si un mago está complicado, que sucede cuando no es apto para ninguna profesión.

estaComplicado(Mago):-
    mago(Mago,_),
    not(esApto(_,Mago)).

% Version usando forall

estaComplicado_2(Mago):-
    mago(Mago,_),
    forall(calificacion(Profesion,_,_), not(esApto(Profesion,Mago))).

% 4) Para que profesión se tiene un talento nato, que es aquella 
% para la cual un mago tiene su calificación más alta (no hay que sumar, es la más alta entre todas sus aptitudes).

tieneUnTalentoNato(Profesion,Mago,Calificacion):-
    calificacion(Profesion,aptitud(Mago,_),Calificacion),  
    forall(calificacion(_,aptitud(Mago,_),OtraCalificacion), Calificacion>= OtraCalificacion).
    

% 5) Si tiene un destino marcado, que se cumple si el mago  tiene solamente una sola profesion para la que es apto.

tieneUnDestinoMarcado(Mago):-
esApto(Profesion,Mago),
not((esApto(OtraProfesion,Mago),Profesion\=OtraProfesion)).

    
:- begin_tests(tp4).

test(dada_la_aptitud_su_calificacion_para_mortifago_es,nondet):-
    calificacion(mortifago,aptitud(harry_Potter,notas(6,_,_)),12), %Porque la calificacion es = encantamiento(6) * 2  = 12
    calificacion(mortifago,aptitud(harry_Potter,notas(_,_,10)),30), %Porque la calificacion es = def artes osc (10) + 20 = 30 
    calificacion(mortifago,aptitud(hermione_Granger,notas(_,_,9)),9), %Porque la calificacion es = def artes osc (9) = 9  ,porque su nota de artes oscuras es menor a 10
    calificacion(mortifago,aptitud(hermione_Granger,notas(10,_,_)),20), %Porque la calificacion es = encantamiento(10) * 2 = 20
    calificacion(mortifago,aptitud(peter_Pettigrew,notas(4,_,_)),8), %Porque la calificacion es = encantamiento(4) * 2  = 8.
    calificacion(mortifago,aptitud(peter_Pettigrew,notas(_,_,2)),2). %Porque la calificacion es = def artes osc (2) = 2 ,porque su nota de artes oscuras es menor a 10.

test(dada_la_aptitud_nota_defensaVsArtesOscuras_su_calificacion_para_auror_es,nondet):-
    calificacion(auror,aptitud(harry_Potter,notas(_,_,10)),70). % Porque la calificacion es la nota * 7

test(dada_la_aptitud_de_Quidditch_su_calificacion_para_auror_es,nondet):-
    calificacion(auror,aptitud(harry_Potter,quiddich(15,10)),120). % Porque perdio 5 partidos, entonces el cociente de 10/5 es 2 y la calificacion es el cociente * 60.

test(dada_la_aptitud_de_Animago_su_calificacion_para_auror_es_40,nondet):-
    calificacion(auror,peter_Pettigrew,40). % porque peter_Pettigrew es animago entonces su calificacion será  40

test(es_apto_para_una_profesion,nondet):-
    \+esApto(_,sirius_Black). %son todos aptos menos sirius,black

test(es_apto_para_ser_mortifago,nondet):-
    \+esApto(mortifago,_). % % no hay nadie apto para ser mortifago, ningun mago cumple con los requisitos para la calificacion para ser  mortifago

test(es_apto_para_ser_auror,nondet):-
    \+esApto(auror,peter_Pettigrew). % porque nacio antes de 1960 , es sangre pura, tiene nota historia >5, posee calificaciones para mortifago > 30.

test(es_apto_para_ser_jugador,nondet):-
    esApto(jugador,harry_Potter), % tanto ginny como harry son los unicos magos que ganaron mas de la mitad de sus partidos
    esApto(jugador,ginny_Weasley).

test(es_apto_para_ser_adivinador,nondet):-
    \+esAptoPara(adivinador,_). % no hay nadie apto para ser adivinador.

test(esta_complicado):-
    estaComplicado(sirius_Black), % es el unico mago que tiene una nota de historia menor a 5, por lo tanto no es apto para ninguna profesion.
    estaComplicado(peter_Pettigrew). % No llega a ser apto para ninguna profesion, la mas cercana es para ser auror pero tiene una aptitud que le da una calificacion de 14.

test(tiene_un_talento_nato,nondet):-
    tieneUnTalentoNato(auror,harry_Potter,120),
    tieneUnTalentoNato(auror,ginny_Weasley,180).

test(tiene_un_destino_marcado,nondet):-
    tieneUnDestinoMarcado(hermione_Granger), %solo  es apta para ser auror
    tieneUnDestinoMarcado(tom_Riddle),  %solo  es apta para ser auror
    tieneUnDestinoMarcado(minerva_McGonagall), %solo  es apto para ser auror
    \+tieneUnDestinoMarcado(harry_Potter), %no cumple porque puede ser jugador y auror
    \+tieneUnDestinoMarcado(ginny_Weasley). %no cumple porque puede ser jugador y auror .
 
:- end_tests(tp4).
