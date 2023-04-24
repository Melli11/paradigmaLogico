% guardia(Nombre)
guardia(bennett).
guardia(mendez).
guardia(george).
% prisionero(Nombre, Crimen)
prisionero(piper, narcotrafico([metanfetaminas])).
prisionero(alex, narcotrafico([heroina])).
prisionero(alex, homicidio(george)).
prisionero(red, homicidio(rusoMafioso)).
prisionero(suzanne, robo(450000)).
prisionero(suzanne, robo(250000)).
prisionero(suzanne, robo(1000)).
prisionero(dayanara, narcotrafico([metanfetaminas])).
prisionero(dayanara, narcotrafico([heroina,opio])).

% controla(Controlador, Controlado)
controla(piper, alex).
controla(bennett, dayanara).
%el primer parametro del predicado controla puede ser tanto un guardia como un prisionero.

controla(Guardia, Otro):- % en un principio el predicado controla es inversible para su seg parametro
    prisionero(Otro,_),
    guardia(Guardia), % se agrega la sentencia guardia(Guardia) para que llegue la variable ligada al not
    not(controla(Otro, Guardia)).

%.
% conflictoDeIntereses/2: relaciona a dos personas distintas (ya sean guardias o prisioneros)
% si no se controlan mutuamente y existe algún tercero al cual ambos controlan.

conflictoDeIntereses(UnaPersona,OtraPersona):-
    controla(UnaPersona,Alguien),
    controla(OtraPersona,Alguien),
    not(seControlanMutuamente(UnaPersona,OtraPersona)),
    UnaPersona \= OtraPersona.

seControlanMutuamente(UnaPersona,OtraPersona):-
    controla(UnaPersona,OtraPersona),
    controla(OtraPersona,UnaPersona),
    UnaPersona \= OtraPersona.

conflictoDeIntereses_v2(Uno,Otro):-
    controla(Uno,Alguien),
    controla(Otro,Alguien),
    not(controla(Uno,Otro)),
    not(controla(Otro,Uno)),
    Uno \= Otro.

% Punto 3
% peligroso/1: Se cumple para un preso que sólo cometió crímenes graves.
% ○ Un robo nunca es grave.
% ○ Un homicidio siempre es grave.
% ○ Un delito de narcotráfico es grave cuando incluye al menos 5 drogas a la vez, o
% incluye metanfetaminas.

peligroso_v2(Prisionero):- %aca estoy diciendo que un prisionero será peligroso si tiene al menos un crimen grave en su prontuario
    prisionero(Prisionero, Crimen),
    cometioCrimenGrave(Crimen).

%corrección el prisionero SOLO cometio crimenes graves es lo mismo a decir
% que la condicion de peligroso se cumple para un prisionero que todos los crimenes
% que realizó fueron graves.


peligroso(Prisionero):- %correccion ok, acá estoy elaborando una consulta donde cada prisionero solo tiene crimenes graves en su prontuario.
    prisionero(Prisionero, _),
    forall(prisionero(Prisionero, Crimen),cometioCrimenGrave(Crimen)).


cometioCrimenGrave(homicidio(_)).

cometioCrimenGrave(narcotrafico(Drogas)):-
    member(metanfetaminas,Drogas).

cometioCrimenGrave(narcotrafico(Drogas)):-
    length(Drogas, Cantidad),
    Cantidad > 5.
    

asesino(Prisionero):-
    prisionero(Prisionero,homicidio(_)).
%  

:- begin_tests(test_punto3).

test(es_peligroso,nondet):-
    peligroso(piper), %por trafico de meta
    peligroso(red). %por homicidio

:- end_tests(test_punto3).

% ladronDeGuanteBlanco/1: Aplica a un prisionero si sólo cometió robos y todos fueron por
% más de $100.000.

ladronGroso(Prisionero):-
    prisionero(Prisionero,robo(Monto)),
    Monto>100000.

ladronDeGuanteBlanco_v2(Prisionero):-
    prisionero(Prisionero,_),
    forall(prisionero(_,_), ladronGroso(Prisionero)).

%predicadoAuxiliar
monto(robo(Monto),Monto).

ladronDeGuanteBlanco(Prisionero):- %%correccion ok
    prisionero(Prisionero,_),
    forall(prisionero(Prisionero,Robo),(monto(Robo,Monto),Monto>100000)).

:- begin_tests(test_punto4).

test(ladronDeGuanteBlanco,nondet):-
    not(ladronDeGuanteBlanco(suzanne)).

:- end_tests(test_punto4).


% condena/2: Relaciona a un prisionero con la cantidad de años de condena que debe
% cumplir. Esto se calcula como la suma de los años que le aporte cada crimen cometido, que
% se obtienen de la siguiente forma:
% ○ La cantidad de dinero robado dividido 10.000.
% ○ 7 años por cada homicidio cometido, más 2 años extra si la víctima era un guardia.
% ○ 2 años por cada droga que haya traficado.

condena(Prisionero,AniosCondena):-
    prisionero(Prisionero,_),
    findall(Anios,(prisionero(Prisionero,Crimen),pena(Crimen,Anios)),ListaDePenas),
    sumlist(ListaDePenas,AniosCondena).

pena(robo(Dinero),Anios):-
    prisionero(_,robo(Dinero)),
    Anios is Dinero/10000.

pena(homicidio(Persona),9):-
    guardia(Persona).

pena(homicidio(Persona),7):-
    not(guardia(Persona)).

pena(narcotrafico(Drogas),Anios):-
    prisionero(_,narcotrafico(Drogas)),
    length(Drogas, Total),
    Anios is Total*2.
    
% 6 capoDiTutiLiCapi/1: Se dice que un preso es el capo de todos los capos cuando nadie lo
% controla, pero todas las personas de la cárcel (guardias o prisioneros) son controlados por
% él, o por alguien a quien él controla (directa o indirectamente).

capoDiTutiLiCapi(Capo):-
    prisionero(Capo,_),
    not(controla(_,Capo)),
    forall(todoElPersonal(Persona),controlaDirectaOIndirectamente(Capo,Persona)).

todoElPersonal(Persona):-
    guardia(Persona).

todoElPersonal(Persona):-
    prisionero(Persona,_).

controlaDirectaOIndirectamente(Uno,Otro):-
    controla(Uno,Otro).

controlaDirectaOIndirectamente(Uno,Otro):-
    controla(Uno,Tercero),
    controlaDirectaOIndirectamente(Tercero,Otro).