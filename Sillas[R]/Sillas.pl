amigo(juan, alberto).
amigo(juan, pedro).
amigo(pedro,mirta).
amigo(alberto, tomas).
amigo(tomas,mirta).

enemigo(mirta,ana).
enemigo(juan,nestor).
enemigo(juan,mirta).
/* Para cada fiesta tenemos las mesas conformadas
o Para modelar una mesa vamos a usar un functor que tiene número de
mesa y una lista de comensales.*/
mesaArmada(navidad2010,mesa(1,[juan,mirta,ana,nestor])).
mesaArmada(navidad2010,mesa(5,[andres,german,ludmila,elias])).
mesaArmada(navidad2010,mesa(8,[nestor,pedro])).

						
/* punto 1 */

estaSentadaEn(Persona,Mesa):-	mesaArmada(_,Mesa),
								comensales(Mesa,Comensales),
								member(Persona,Comensales).
								
comensales(mesa(_,Comensales),Comensales).

/* punto 2 */

sePuedeSentar(Persona,mesa(_,Comensales)):-	member(Amigo,Comensales),
											sonAmigos(Persona,Amigo),
											forall(member(Comensal,Comensales),not(sonEnemigos(Persona,Comensal))).

sonAmigos(Persona,Amigo):-	amigo(Persona,Amigo).
sonAmigos(Persona,Amigo):-	amigo(Amigo,Persona).

sonEnemigos(Persona,Amigo):-	enemigo(Persona,Amigo).
sonEnemigos(Persona,Amigo):-	enemigo(Amigo,Persona).

/* punto 3 */

mesaDeCumpleaniero(Persona,Mesa):-	findall(Amigo,sonAmigos(Persona,Amigo),Amigos),
									append([Persona],Amigos,Comensales),
									armadoDeMesa(Comensales,Mesa).
									
armadoDeMesa(Comensales,mesa(1,Comensales)).

/* punto 4 */

incompatible(P1,P2):-	sonAmigos(P1,P3),
						sonEnemigos(P2,P3).
						
incompatible(P1,P2):-	sonAmigos(P2,P3),
						sonEnemigos(P1,P3).
						
/* punto 5 */

laPeorOpcion(Persona,Mesa):-	findall(Enemigo,sonEnemigos(Persona,Enemigo),Enemigos),
								append([Persona],Enemigos,Comensales),
								armadoDeMesa(Comensales,Mesa).
							
/* punto 6 */

mesasPlanificadas(Fiesta,Mesas):-	mesaArmada(Fiesta,_),
									findall(Mesa,mesaArmada(Fiesta,Mesa),Mesas).

/* punto 7 */

esViable(Mesas):-	findall(Numero,member(mesa(Numero,_),Mesas),Numeros),
					length(Numeros,Cant),
					numeracionCorrecta(Numeros,Cant),
					forall(member(Mesa,Mesas),esMesaViable(Mesa)).
					
numeracionCorrecta(Numeros,Cant):-	member(Cant,Numeros),
									CantMenos1 is Cant - 1,
									numeracionCorrecta(Numeros,CantMenos1).
numeracionCorrecta(_,0).
							
esMesaViable(mesa(_,Personas)):-	length(Personas,4),
									member(P1,Personas),
									member(P2,Personas),
									not(sonEnemigos(P1,P2)).
	