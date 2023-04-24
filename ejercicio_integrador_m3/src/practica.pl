% natacion: estilos (lista), metros nadados, medallas
practica(ana, natacion([pecho, crawl], 1200 , 10 )).
practica(luis, natacion([perrito], 200 , 0 )).
practica(vicky, natacion([crawl, mariposa, pecho, espalda], 800 , 0 )).
% fútbol: medallas, goles marcados, veces que fue expulsado
practica(deby, futbol ( 2 , 15 , 5 )).
practica(mati, futbol ( 1 , 11 , 7 )).
% rugby:posición que ocupa, medallas
practica(zaffa, rugby (pilar, 0 )).

% Aclaraciones:
% ● para la natación sabemos los estilos que nada, la cantidad de metros
% diarios que recorre, y la cantidad de medallas que consiguió a lo largo de
% su carrera deportiva
% ● para el fútbol primero conocemos las medallas, luego los goles
% convertidos y por último las veces que fue expulsado
% ● para el rugby, queremos saber la posición que ocupa y luego la cantidad
% de medallas obtenidas

% 5.1 Quiénes son nadadores
% Los nadadores son aquellos que practican deporte, donde ese deporte es la
% natación. Puesto en una base de conocimientos, necesitamos trabajar primero
% con el predicado practica, para luego hacer pattern matching con el functor y así
% poder hacer consultas inversibles:

esNadador(UnaPersona):
    practica(UnaPersona, natacion(_,_,_)).
    
