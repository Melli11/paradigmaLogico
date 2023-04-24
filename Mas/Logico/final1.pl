%--todosSiguenA(Rey) :-
 %--   personaje(Rey),
  % --    not((personaje(Personaje), not(sigueA(Personaje, Rey)))).

  todosSiguenA(Alguien):-
personaje(Alguien),
    forall(personaje(Personaje),sigueA(Personaje,Alguien)).



personaje(uno).
personaje(dos).
personaje(tres).
personaje(rey).

sigueA(uno,rey).
sigueA(dos,rey).
sigueA(tres,rey).
sigueA(uno,dos).
sigueA(rey,rey).

comidaVegana(Comida) :-
    ingrediente( _, Comida),
    forall(ingrediente(Ingrediente, Comida),
		(not(contieneCarne(Ingrediente)),
                 not(contieneHuevo(Ingrediente)),
                 not(contieneLeche(Ingrediente)))).

ingrediente(queso,tarta).
ingrediente(jamon, tarta).
ingrediente(harina, donna).

contieneCarne(jamon).
contieneLeche(queso).
contieneHuevo(pan).


