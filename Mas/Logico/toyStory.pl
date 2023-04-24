dueno(andy, woody, 8).
dueno(andy, buzz, 1).
dueno(sam, jessie, 3). 
dueno(sam, monitosEnBarril, 2).   
dueno(sam, soldados,4).

juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)). 
juguete(buzz, deAccion(espacial, [original(casco)])). 
juguete(soldados,miniFiguras(soldado, 60)). 
juguete(monitosEnBarril, miniFiguras(mono, 50)). 
juguete(señorCaraDePapa, caraDePapa([ original(pieIzquierdo),
                                     original(pieDerecho),
                                     repuesto(nariz) ])).

  % Dice si un juguete es raro 
esRaro(deAccion(stacyMalibu, 1, [sombrero])).    
% Dice si una persona es coleccionista  
esColeccionista(sam).

existe(juguete(Nombre,_)):-
    juguete(Nombre,_).


%1a
tematica(juguete(_,deTrapo(T)),T).
tematica(juguete(_,deAccion(T)),T).
tematica(juguete(_,miniFiguras(T,_)),T).
tematica(juguete(_,caraDePapa(_)),caraDePapa).

%1b
esDePlastico(juguete(_,miniFiguras(_,_))).
esDePlastico(juguete(_,caraDePapa(_))).

esDeColeccion(juguete(_,deTrapo(_))).
esDeColeccion(juguete(_,deAccion(_))):-
    esRaro(juguete(_,deAccion(_))).
esDeColeccion(juguete(_,caraDePapa(_))):-
    esRaro(juguete(_,caraDePapa(_))).

amigoFiel(Dueno,J):-
   juguete(J,_),
   forall(dueno(Dueno,J,T),
         T>4).
