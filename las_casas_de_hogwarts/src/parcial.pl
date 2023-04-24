sangre(harry,mestiza).
sangre(draco,pura).
sangre(hermione,impura).

caracter(harry,coraje).
caracter(harry,amistoso).
caracter(harry,orgulloso).
caracter(harry,inteligente).
caracter(draco,inteligente).
caracter(draco,orgulloso).
caracter(hermione,inteligente).
caracter(hermione,orgulloso).
caracter(hermione,responsable).

odiaria(draco,hufflepuff).
odiaria(harry,slytherin).

seleccionSombrero(gryffindor,coraje).
seleccionSombrero(slytherin,orgulloso).
seleccionSombrero(slytherin,inteligente).
seleccionSombrero(ravenclaw,inteligente).
seleccionSombrero(ravenclaw,responsable).
seleccionSombrero(hufflepuff,amistoso).

% --Abstraccion
mago(Mago):- 
    sangre(Mago,_).

mago(ron).
mago(luna).
mago(iniesta).%inventado para casa ganadora

% Punto1)
% 1. Saber si una casa permite entrar a un mago, lo cual se cumple para cualquier mago y 
% cualquier casa excepto en el caso de Slytherin, que no permite entrar a magos de sangre 
% impura. 

laCasaPermiteEntrar(slytherin,Mago):- %especifico el que no cumple la condicion
    mago(Mago),
    not(sangre(Mago,impura)). % restriccion

laCasaPermiteEntrar(Casa,Mago):- %se cumple para todos
    mago(Mago),
    seleccionSombrero(Casa,_),
    not(Casa = slytherin). % menos para slytherin

% 2. Saber si un mago tiene el carácter apropiado para una casa, lo cual se cumple para cualquier 
% mago si sus características incluyen todo lo que se busca para los integrantes de esa casa, 
% independientemente de si la casa le permite la entrada.

tieneElCaracterApropiado(Mago,Casa):-
    seleccionSombrero(Casa,_),
    mago(Mago),
    forall(seleccionSombrero(Casa,Caracter),caracter(Mago,Caracter)).


% 3. Determinar en qué casa podría quedar seleccionado un mago sabiendo que tiene que tener 
% el carácter adecuado para la casa, la casa permite su entrada y además el mago no odiaría 
% que lo manden a esa casa. Además Hermione puede quedar seleccionada en Gryffindor, 
% porque al parecer encontró una forma de hackear al sombrero.

puedeQuedarSeleccionado(Casa,Mago):-
    tieneElCaracterApropiado(Mago,Casa),
    laCasaPermiteEntrar(Casa,Mago),
    not(odiaria(Mago,Casa)). % tanto Mago como Casa llegan ligados al not

puedeQuedarSeleccionado(gryffindor,hermione).

% 4. Definir un predicado cadenaDeAmistades/1 que se cumple para una lista de magos si todos 
% ellos se caracterizan por ser amistosos y cada uno podría estar en la misma casa que el 
% siguiente. No hace falta que sea inversible, se consultará de forma individual.

% Parte 2 - La copa de las casas 

lugar(prohibido(ir_al_bosque,-50)).
lugar(prohibido(ir_seccion_restringida_biblio,-10)).
lugar(prohibido(ir_tercer_piso,-75)).
lugar(no_prohibido(ir_a_mazmorras)).

accion(mala,fuera_de_la_cama,-50).
accion(mala,Actividad,Puntaje):-
    lugar(prohibido(Actividad,Puntaje)). %abro functor

accion(neutral,Actividad,0):-
    lugar(no_prohibido(Actividad)). %abro functor

accion(buena,Actividad,Puntaje):-
    reconocimiento(_,Actividad,Puntaje).

magoHizo(harry,fuera_de_la_cama).
magoHizo(harry,ir_al_bosque).
magoHizo(harry,ir_tercer_piso).
magoHizo(hermione,ir_tercer_piso).
magoHizo(hermione,ir_seccion_restringida_biblio).
magoHizo(draco,ir_a_mazmorras).
magoHizo(ron,ganar_partida_ajedrez_magico).
magoHizo(hermione,salvar_amigos).
magoHizo(harry,vencer_voldemort).
magoHizo(iniesta,vencer_voldemort).
magoHizo(iniesta,ganar_partida_ajedrez_magico).

magoHizo(hermione,respondio(ubicacion_bezoar,20,snape)).
magoHizo(hermione,respondio(como_levitar_pluma,25,flitwick)).


%reconocimiento para las malas acciones
reconocimiento(Mago,Accion,Puntaje):-
    magoHizo(Mago,Accion),
    accion(mala,Accion,Puntaje).

%reconocimiento por las acciones neutras
reconocimiento(_,Accion,0):-
    accion(neutral,Accion,_).


% reconocimiento para las buenas acciones individuales
reconocimiento(ron,ganar_partida_ajedrez_magico,50).
reconocimiento(hermione,salvar_amigos,50).
reconocimiento(harry,vencer_voldemort,60).
reconocimiento(iniesta,vencer_voldemort,160).
reconocimiento(iniesta,ganar_partida_ajedrez_magico,170).

reconocimiento(Mago,Pregunta,Puntaje):-
    magoHizo(Mago,respondio(Pregunta,Dificultad,snape)),
    Puntaje is Dificultad/2.

reconocimiento(Mago,Pregunta,Puntaje):-
    magoHizo(Mago,respondio(Pregunta,Dificultad,Profesor)),
    Profesor \= snape,
    Puntaje is Dificultad.


esDe(hermione,gryffindor). 
esDe(ron,gryffindor). 
esDe(harry,gryffindor). 
esDe(draco,slytherin). 
esDe(luna,ravenclaw).
esDe(iniesta,riverPlate).

casa(Casa):-
    esDe(_,Casa).

% Punto 2.1
% Saber si un mago es buen alumno, que se cumple si hizo alguna acción y ninguna de las cosas 
% que hizo se considera una mala acción (que son aquellas que provocan un puntaje negativo)

hizoAlgoMalo(Mago,Accion):- %existencia
    magoHizo(Mago,Accion),
    accion(mala,Accion,_).

esBuenAlumno(Mago):-
    magoHizo(Mago,_), %el mago hizo alguna accion
    not(hizoAlgoMalo(Mago,_)). %mas simple
% not((magoHizo(Mago,Accion),accion(mala,Accion,_))).


% Punto 2.2
% Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción. 

esRecurrente(Accion):-%existencia
    magoHizo(Mago,Accion),
    magoHizo(Mago2,Accion),
    Mago \= Mago2. %afirmo que se trata de magos diferentes.

% Punto 2.3
% Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus 
% miembros.

puntajeTotal(Casa,Puntaje):-
    esDe(_,Casa),
    findall(Puntaje,(esDe(Mago,Casa),puntajeDeMago(Mago,Puntaje)),ListaDePuntos),
    sum_list(ListaDePuntos,Puntaje).

puntajeDeMago(Mago,Puntaje):-
    mago(Mago),
    findall(Puntaje,reconocimiento(Mago,_,Puntaje),ListaDePuntos),
    sum_list(ListaDePuntos,Puntaje).

% puntajes
% harry = -115
% hermione = -35
% draco = 0
% ron = +50
% luna = 0

% gryffindor:
% hermione, ron, harry = -35 +50 -115 = -100
% slytherin :
% draco = 0

% ravenclaw:
% luna = 0

% % Punto 2.4
% Saber cuál es la casa ganadora de la copa, que se verifica para aquella casa que haya 
% obtenido una cantidad mayor de puntos que todas las otras.

casaGanadora(Casa):-
    puntajeTotal(Casa,PuntajeMasAlto),
    not((puntajeTotal(OtraCasa,Puntaje),OtraCasa\=Casa,Puntaje>PuntajeMasAlto)).


% Punto 2.5
% Queremos agregar la posibilidad de ganar puntos por responder preguntas en clase. La 
% información que nos interesa de las respuestas en clase son: cuál fue la pregunta, cuál es la 
% % dificultad de la pregunta y qué profesor la hizo.  
% Por ejemplo, sabemos que Hermione respondió a la pregunta de dónde se encuentra un Bezoar, de 
% dificultad 20, realizada por el profesor Snape, y cómo hacer levitar una pluma, de dificultad 25, 
% realizada por el profesor Flitwick. 
 
% Modificar lo que sea necesario para que este agregado funcione con lo desarrollado hasta ahora, 
% teniendo en cuenta que los puntos que se otorgan equivalen a la dificultad de la pregunta, a menos 
% que la haya hecho Snape, que da la mitad de puntos en relación a la dificultad de la pregunta. 


:- begin_tests(parcial).

test(parte1a_laCasaPermiteEntrar_a_un_mago,nondet):-
    \+laCasaPermiteEntrar(slytherin,hermione),
    laCasaPermiteEntrar(_,draco),
    laCasaPermiteEntrar(_,harry),
    laCasaPermiteEntrar(gryffindor,hermione),
    laCasaPermiteEntrar(hufflepuff,hermione),
    laCasaPermiteEntrar(ravenclaw,hermione).

test(parte1b_tiene_el_caracter_apropiado_para_la_casa,nondet):-
    tieneElCaracterApropiado(draco,slytherin),
    tieneElCaracterApropiado(harry,slytherin),
    tieneElCaracterApropiado(harry,gryffindor),
    tieneElCaracterApropiado(hermione,ravenclaw),
    tieneElCaracterApropiado(harry,hufflepuff).

test(parte1c_puede_quedar_seleccionado,nondet):-
    puedeQuedarSeleccionado(slytherin,draco),
    puedeQuedarSeleccionado(gryffindor,hermione).

test(parte2_a_No_Hizo_niguna_mala_accion,nondet):-
    esBuenAlumno(draco),
    esBuenAlumno(ron).

test(parte2_b_accion_recurrente,nondet):-
    esRecurrente(ir_tercer_piso).

test(parte2_d_casaGanadora,nondet):-
    casaGanadora(riverPlate).


test(parte2_c_1_puntaje_invididual,nondet):-
    % puntajeDeMago(harry,-115),
    % puntajeDeMago(iniesta,330).
    puntajeDeMago(hermione,0),
    puntajeDeMago(draco,0),
    puntajeDeMago(ron,50),
    puntajeDeMago(luna,0).

% test(parte2_c_2_puntaje_de_la_casa):-
%     puntajeTotal(riverPlate,330),
%     puntajeTotal(gryffindor,-100),
%     puntajeTotal(slytherin,0),
%     puntajeTotal(ravenclaw,0).


:- end_tests(parcial).
