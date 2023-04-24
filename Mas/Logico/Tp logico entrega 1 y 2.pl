%sabe(Quien, Que)/2
sabe(fernando, cobol).
sabe(fernando, visualbasic).
sabe(fernando, java).
sabe(julieta, java).
sabe(marcos, java).
sabe(santiago, ecmascript).
sabe(santiago, java).

persona(Persona):- trabajaEn(Persona,_).
% Assembler no puede relacionarse con ninguna persona, ya que nadie
% programa en el.Y no sabemos si julieta programo en go

%es(Quien, trabajo) /2
rol(fernando,analistafuncional).
rol(andres, projectleader).
%esProgramador(Persona):- sabe(Persona,_).
rol(Persona,programador):-sabe(Persona,_).

%sabe(fernando,Lenguaje).
%sabe(Quien, java).
%sabe(Quien, assembler).
%esProgramador(fernando).
%rol(fernando, Rol).
%rol(Quien, programador).//esProgramador(Quien).
%rol(Quien, projectleader).


%3 Proyectos
%

%proyecto (nombre, lenguajes)
%trabajaEn(persona, proyecto)
%proyecto/2.
%trabajaEn/2.

trabajaEn(julieta,sumatra).
trabajaEn(andres,sumatra).
trabajaEn(marcos,sumatra).
trabajaEn(santiago,prometeus).
trabajaEn(fernando,prometeus).

proyecto(sumatra,[java, net]).
proyecto(prometeus,[cobol]).

%lugarCorrecto/2
%lugarCorrecto(Persona, Proyecto).
lugarCorrecto(Persona, Proyecto):-
    trabajaEn(Persona,Proyecto),
    proyecto(Proyecto, Lenguajes),
    sabe(Persona,Lenguaje),
    member(Lenguaje,Lenguajes).

lugarCorrecto(Persona,Proyecto):-
     trabajaEn(Persona,Proyecto),
    proyecto(Proyecto,_),
    rol(Persona,analistafuncional).

lugarCorrecto(Persona,Proyecto):-
    trabajaEn(Persona,Proyecto),
    proyecto(Proyecto,_),
    rol(Persona,projectleader).

%proyecto(sumatra, Lenguajes).
%trabajaEn(fernando,prometeus).
%trabajaEn(santiago, prometeus).

programadoresDe(Proyecto, Programadores):-
    findall(Programador,
            (trabajaEn(Programador,Proyecto),
            rol(Programador,programador)),
            Programadores).

%lugarCorrecto(julieta,sumatra). etc
%

%4
%
%bienDefinido/1
bienDefinido(Proyecto):-
    proyecto(Proyecto,_),
    forall(trabajaEn(Persona,Proyecto),lugarCorrecto(Persona,Proyecto)),
    findall(Persona,(trabajaEn(Persona,Proyecto),rol(Persona, projectleader)),Personas),
    length(Personas,Cantidad),
    Cantidad <2.
%Creo que el cfd va a ser bajo por esto
%
%5
%bienDefinido(X).
%
%6
%esCopadoCon/2
esCopadoCon(fernando,santiago).
esCopadoCon(santiago,julieta).
esCopadoCon(santiago, marcos).
esCopadoCon(julieta,andres).

%puedeEnsenarle/3
puedeEnsenarle(Persona1,Lenguaje, Persona2):-
    persona(Persona1),
    persona(Persona2),
    Persona1\=Persona2,
    sabe(Persona1,Lenguaje),
    not(sabe(Persona2,Lenguaje)),
    hayBuenaOnda(Persona1,Persona2).

hayBuenaOnda(P1,P2):-
    esCopadoCon(P1,P2).

hayBuenaOnda(P1,P2):-
    esCopadoCon(P1,P3),
    hayBuenaOnda(P3,P2).

%falta que funcione para n niveles.

%6.1.1 esCopadoCon(fernando,santiago). true
%6.1.2 esCopadoCon(fernando,julieta). false
% 6.1.3 puedeEnsenarle(fernando,cobol,Q). Q=santiago,julieta,marcos,
% andres no aparece todavia
%6.1.4 puedeEnsenarle(fernando,haskell,Alguien). false
% 6.1.5 puedeEnsenarle(Q,java,andres). Q=julieta,santiago. fernando tdv
%no
%6.1.6 puedeEnsenarle(fernando,java,C). deberia responder c=andres
%6.1.7puedeEnsenarle(marcos,Algo,Alguien). false

%7
%tarea(Persona, tipo).
tarea(fernando, evolutiva(compleja)).
tarea(fernando, correctiva(8, brainfuck)).
tarea(fernando, algoritmica(150)).
tarea(marcos, algoritmica(20)).
tarea(julieta, correctiva(412, cobol)).
tarea(julieta, correctiva(21, go)).
tarea(julieta, evolutiva(simple)).


gradoDeSeniority(Persona,Suma):-
    persona(Persona),
    findall(Puntos,(tarea(Persona, Tarea),puntos(Tarea,Puntos)),Puntuacion),
    sum_list(Puntuacion,Suma).

puntos(evolutiva(compleja),5).
puntos(evolutiva(simple),3).
puntos(correctiva(Cantidad,_),4):-
    Cantidad>50.
puntos(correctiva(_,brainfuck),4).
puntos(algoritmica(Cantidad),Puntos):-
   Puntos is Cantidad/10.
