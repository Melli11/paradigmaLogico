% Sea la siguiente base
tiene(juan, foto([juan, hugo, pedro, lorena, laura], 1988 )).
tiene(juan, foto([juan], 1977 )).
tiene(juan, libro(saramago, "Ensayo sobre la ceguera")).
tiene(juan, bebida(whisky)).
tiene(valeria, libro(borges, "Ficciones")).
tiene(lucas, bebida(cusenier)).
tiene(pedro, foto([juan, hugo, pedro, lorena, laura], 1988 )).
tiene(pedro, foto([pedro], 2010 )).
tiene(pedro, libro(octavioPaz, "Salamandra")).
premioNobel(octavioPaz).
premioNobel(saramago).

% Determinamos que alguien es coleccionista si todos los elementos que tiene son
% valiosos:
% ● un libro de un premio Nobel es valioso
% ● una foto con más de 3 integrantes es valiosa
% ● una foto anterior a 1990 es valiosa
% ● el whisky es valioso

esColeccionista(UnaPersona):-
    tiene(UnaPersona,_),
    forall(tiene(UnaPersona,Elemento),esValioso(Elemento)).

% ● un libro de un premio Nobel es valioso
esValioso(libro(Autor,_)):-
    premioNobel(Autor).

% ● una foto con más de 3 integrantes es valiosa
esValioso(foto(Integrantes,_)):-
    tiene(_,foto(Integrantes,_)),%necesario para generar inversibilidad.
    length(Integrantes, Cantidad_de_fotos),
    Cantidad_de_fotos > 3.

esValioso(bebida(whisky)).

esValioso(foto(_,Anio)):-
    between(1900,1990,Anio), % acoto rango para hacer el predicado inversible.
    Anio < 1990.    
