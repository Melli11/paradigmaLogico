% natacion: estilos (lista), metros nadados, medallas
practica(ana,natacion([pecho, crawl],1200,10)).
practica(luis,natacion([perrito],200,0)).
practica(vicky,natacion([crawl,mariposa,pecho,espalda],800,0)).
% fútbol: medallas, goles marcados, veces que fue expulsado
practica(deby,futbol(2,15,5)).
practica(mati,futbol(1,11,7)).
% rugby:posición que ocupa, medallas
practica(zaffa,rugby(pilar,0)).

% 1raForma: Directa 
% esNadador(UnaPersona):- practica(UnaPersona,natacion(_,_,_)).

% 2da Forma: Logrando Abstraccion
nadadores(UnaPersona):-
    practica(UnaPersona,Deporte),
    esNadador(Deporte).

esNadador(natacion(_,_,_)).


% Bonues El mas ganador
% Quiero saber quien es el mas ganador de medallas de todas los deportistas

elMasGanador(UnaPersona):-
    cantidadMedallas(UnaPersona,Cantidad),
    not((cantidadMedallas(OtraPersona,Cantidad2),UnaPersona \= OtraPersona, Cantidad2 > Cantidad)).

% 1er Paso:
% Fijamos una relacion  persona y sus medallas, y luego decimos es cierto que NO existe otra Persona (Diferente) con otra cantidad superior.


% elMasGanador(UnaPersona,Cantidad):-
%     practica(UnaPersona,_),
%     findall(Cantidad,cantidadMedallas(UnaPersona,Cantidad),ListaCantidadMedallas),
%     max_member(Cantidad,ListaCantidadMedallas).

% primeroDeLaLista(X,[X|_]).


% 5.2 Medallas obtenidas
% Si queremos saber cuántas medallas tiene alguien, debemos relacionar primero
% una persona con el deporte que practica...

cantidadMedallas(UnaPersona,Cantidad):-
    practica(UnaPersona,Deporte),
    medallas(Deporte,Cantidad).

% pattern matching en base a cada functor:
medallas(natacion(_,_,Medallas),Medallas).
medallas(rugby(_,Medallas),Medallas).
medallas(futbol(Medallas,_,_),Medallas).

% 5.3 Buen deportista
% Quiero saber si alguien es buen deportista

esBuenDeportista(UnaPersona):-
    practica(UnaPersona,Deporte),
    deporteCumpleCondicion(Deporte).

% deporteCumpleCondicion(Deporte):-


% ● en el caso de la natación, si recorren más de 1.000 metros diarios o nadan
% más de 3 estilos

deporteCumpleCondicion(natacion(_,Metros,_)):-
    Metros > 1000.

deporteCumpleCondicion(natacion(Estilos,_,_)):-
    length(Estilos, Total),
    Total > 3.

% ● en el caso del fútbol, si la diferencia de goles menos las expulsiones
% suman más de 5

deporteCumpleCondicion(futbol(_,Goles,Expulsiones)):-
    Diferencia is Goles - Expulsiones,
    Diferencia > 5.

% ● en el caso del rugby, si son wings o pilares

deporteCumpleCondicion(rugby(wing,_)).
deporteCumpleCondicion(rugby(pilar,_)).
