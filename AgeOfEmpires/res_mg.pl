% nombre, su rating y su civilización favorita. 
jugador(juli, 2200, jemeres).
jugador(aleP, 1600, mongoles).
jugador(feli, 500000, persas).
jugador(aleC, 1723, otomanos).
jugador(ger, 1729, ramanujanos).
jugador(juan, 1515, britones).
jugador(marti, 1342, argentinos).

%También sabemos qué unidades, recursos y edificios tiene cada jugador.
tiene(aleP, unidad(samurai, 199)).
tiene(aleP, unidad(espadachin, 10)).
tiene(aleP, unidad(granjero, 10)).
tiene(aleP, recurso(800, 300, 100)).
tiene(aleP, edificio(casa, 40)).
tiene(aleP, edificio(castillo, 1)).
tiene(juan, unidad(carreta, 10)).
tiene(carolina, unidad(granjero, 1)).
%inventando
tiene(martin,unidad(espadachin,100)).
tiene(raul,unidad(alabardero,100)).

% De las unidades sabemos que pueden ser militares o aldeanos. 
% De los militares sabemos su tipo, cuántos recursos cuesta y a qué categoría pertenece.
% De los aldeanos sabemos su tipo y cuántos recursos por minuto produce. Su categoría es aldeano.

% militar(Tipo, costo(Madera, Alimento, Oro), Categoria).
militar(espadachin, costo(0, 60, 20), infanteria).
militar(arquero, costo(25, 0, 45), arqueria).
militar(mangudai, costo(55, 0, 65), caballeria).
militar(samurai, costo(0, 60, 30), unica).
militar(keshik, costo(0, 80, 50), unica).
militar(tarcanos, costo(0, 60, 60), unica).
militar(alabardero, costo(25, 35, 0), piquero).
% … y muchos más tipos pertenecientes a estas categorías.

% aldeano(Tipo, produce(Madera, Alimento, Oro)).
aldeano(lenador, produce(23, 0, 0)).
aldeano(granjero, produce(0, 32, 0)).
aldeano(minero, produce(0, 0, 23)).
aldeano(cazador, produce(0, 25, 0)).
aldeano(pescador, produce(0, 23, 0)).
aldeano(alquimista, produce(0, 0, 25)).
% … y muchos más también

% edificio(Edificio, costo(Madera, Alimento, Oro)).
edificio(casa, costo(30, 0, 0)).
edificio(granja, costo(0, 60, 0)).
edificio(herreria, costo(175, 0, 0)).
edificio(castillo, costo(650, 0, 300)).
edificio(maravillaMartinez, costo(10000, 10000, 10000)).
% … y muchos más también


% PUNTO 1 
esUnAfano(JugadorA,JugadorB):-
    jugador(JugadorA, RatingA , _),
    jugador(JugadorB, RatingB, _),
    JugadorA \= JugadorB,
    Diferencia is RatingA - RatingB,
    Diferencia > 500.

% PUNTO 2

categoriaLeGana(caballeria,arqueria).
categoriaLeGana(arqueria,infanteria).
categoriaLeGana(infanteria,piquero).
categoriaLeGana(piquero,caballeria).

esEfectivo(UnidadA,UnidadB):-
    categoriaLeGana(CategoriaA,CategoriaB),
    militar(UnidadA,_,CategoriaA),
    militar(UnidadB,_, CategoriaB),
    CategoriaA \= CategoriaB,
    UnidadA \= UnidadB.

esEfectivo(samurai,UnidadB):-
    militar(UnidadB,_,unica).
    
% PUNTO 3 

alarico(Jugador):-
    tiene(Jugador,_),    
    forall(tiene(Jugador,unidad(Unidad,_)),militar(Unidad,_,infanteria)).

% PUNTO 4 

leonidas(Jugador):-
    tiene(Jugador,_),    
    forall(tiene(Jugador,unidad(Unidad,_)),militar(Unidad,_,piquero)).
    
% PUNTO 5
nomada(Jugador):-
    tiene(Jugador,_),
    not(tiene(Jugador, edificio(casa,_))).
  
% PUNTO 6

cuantoCuesta(UnidadOEdificio,Costo):-
    militar(UnidadOEdificio, Costo, _).
cuantoCuesta(UnidadOEdificio,Costo):-
    edificio(UnidadOEdificio, Costo).
cuantoCuesta(aldeano,costo(0,50,0)).
cuantoCuesta(carreta,costo(100,0,0)).
cuantoCuesta(urnasMercantes,costo(0,0,50)).

% PUNTO 7
% aldeano(Tipo, produce(Madera, Alimento, Oro)).

% produccion(Unidad,Produccion):-

:-begin_tests(punto3).
test(punto3_alarico,nondet):-
alarico(martin).
end_tests(punto3).

:-begin_tests(punto4).
test(punto4_leonidas,nondet):-
leonidas(raul).
end_tests(punto4).

:-begin_tests(punto5).
test(punto5_nomada,nondet):-
nomada(juan),
nomada(carolina),
nomada(martin),
nomada(raul),
not(nomada(aleP)).
end_tests(punto4).



% alarico(Nombre):-
%     tiene(Nombre, _),
%     soloTieneUnidadMilitarDe(infanteria, Nombre).

% soloTieneUnidadMilitarDe(Categoria, Nombre):-
%     forall(tiene(Nombre, unidad(Tipo, _)), esMilitar(Tipo, _, Categoria)).

