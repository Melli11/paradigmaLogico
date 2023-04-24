% jugadores conocidos
jugador(maradona).
jugador(chamot).
jugador(balbo).
jugador(caniggia).
jugador(passarella).
jugador(pedemonti).
jugador(basualdo).
% relaciona lo que toma cada jugador
tomo(maradona, sustancia(efedrina)).
tomo(maradona, compuesto(cafeVeloz)).
tomo(caniggia, producto(cocacola, 2)).
tomo(chamot, compuesto(cafeVeloz)).
tomo(balbo, producto(gatoreit, 2)).
% relaciona la máxima cantidad de un producto que 1 jugador puede ingerir
maximo(cocacola, 3). maximo(gatoreit, 1).
maximo(naranju, 5).
% relaciona las sustancias que tiene un compuesto
composicion(cafeVeloz, [efedrina, ajipupa, extasis, whisky, cafe]).
% sustancias prohibidas por la asociación
sustanciaProhibida(efedrina). sustanciaProhibida(cocaina).

amigo(maradona, caniggia).
amigo(caniggia, balbo).
amigo(balbo, chamot).
amigo(balbo, pedemonti).

atiende(cahe, maradona).
atiende(cahe, chamot).
atiende(cahe, balbo).
atiende(zin, caniggia).
atiende(cureta, pedemonti).
atiende(cureta, basualdo).		

nivelFalopez(efedrina, 10).
nivelFalopez(cocaina, 100).
nivelFalopez(extasis, 120).
nivelFalopez(omeprazol, 5).

				
/* punto 1 */

tomo(passarella,Bebida):-	not(tomo(maradona,Bebida)).

tomo(pedemonti,Bebida):-	tomo(chamot,Bebida).

tomo(pedemonti,Bebida):-	tomo(maradona,Bebida).

/* punto 2 */

puedeSerSuspendido(Jugador):-	jugador(Jugador),
								tomo(Jugador,sustancia(Sustancia)),
								sustanciaProhibida(Sustancia).
								
puedeSerSuspendido(Jugador):-	jugador(Jugador),
								tomo(Jugador,compuesto(Compuesto)),
								composicion(Compuesto,Sustancias),
								member(Sustancia,Sustancias),
								sustanciaProhibida(Sustancia).
								
puedeSerSuspendido(Jugador):-	jugador(Jugador),
								tomo(Jugador,producto(Producto,Cant)),
								maximo(Producto,Max),
								Cant > Max.
								
/* punto 3 */

malaInfluencia(J1,J2):-	puedeSerSuspendido(J1),
						puedeSerSuspendido(J2),
						seConocen(J1,J2).
						
seConocen(J1,J2):-	amigo(J1,J2).

seConocen(J1,J2):-	amigo(J1,Amigo),
					amigo(Amigo,J2).
					
seConocen(J1,J2):-	amigo(J2,Amigo),
					amigo(Amigo,J1).
					
seConocen(J1,J2):-	amigo(J1,Amigo),
					amigo(J2,Amigo).
					
seConocen(J1,J2):-	amigo(Amigo,J1),
					amigo(Amigo,J2).

/* punto 4 */

chanta(Medico):-	atiende(Medico,_),
					forall(atiende(Medico,Jugador),puedeSerSuspendido(Jugador)).

/* punto 5 */

cuantaFalopaTiene(Alteracion,Jugador):-	jugador(Jugador),
										findall(Nivel,(tomo(Jugador,Bebida),nivelDeFalopa(Bebida,Nivel)),Niveles),
										sumlist(Niveles,Alteracion).
										
nivelDeFalopa(producto(Producto,Cant),Nivel):-	Nivel is 0 .
										
nivelDeFalopa(sustancia(Sustancia),Nivel):-	nivelFalopez(Sustancia,Nivel).

nivelDeFalopa(compuesto(Compuesto),Nivel):-	findall(Falopa,(member(Sustancia,Compuesto),nivelFalopez(Sustancia,Falopa)),Falopas),
											sumlist(Falopas,Nivel).

/* punto 6 */

medicoConProblemas(Medico):-	atiende(Medico,_),
								findall(Jugador,(atiende(Medico,Jugador),puedeSerSuspendido(Jugador)),Jugadores),
								length(Jugadores,Cant),
								Cant > 3 .
								
medicoConProblemas(Medico):-	atiende(Medico,_),
								findall(Jugador,(atiende(Medico,Jugador),seConocen(Jugador,maradona)),Jugadores),
								length(Jugadores,Cant),
								Cant > 3 .

/* punto 7 */	

programaTVFantinesco(Lista):-	findall(Jugador,puedeSerSuspendido(Jugador),Jugadores),
								subconjunto(Jugadores,Lista).							