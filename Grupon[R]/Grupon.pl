usuario(lider,capitalFederal).
usuario(alf,lanus).
usuario(roque,laPlata).
usuario(fede, capitalFederal).


% los functores cupon son de la forma
% cupon(Marca,Producto,PorcentajeDescuento)
cuponVigente(capitalFederal,cupon(elGatoNegro,setDeTe,35)).
cuponVigente(capitalFederal,cupon(lasMedialunasDelAbuelo,panDeQueso,43)).
cuponVigente(capitalFederal,cupon(laMuzzaInspiradora,pizzaYBirraParaDos,80)).
cuponVigente(lanus,cupon(maoriPilates,ochoClasesDePilates,75)).
cuponVigente(lanus,cupon(elTano,parrilladaLibre,65)).
cuponVigente(lanus,cupon(niniaBonita,depilacionDefinitiva,73)).

/*El predicado accionDeUsuario registra las acciones que el usuario realiza en el sitio, que
pueden ser:
? comprar con un cup�n, que se representa con un functor:
compraCupon(PorcentajeDescuento,Fecha,Marca)
? recomendar un cup�n, representado como:
recomiendaCupon(Marca,Fecha,UsuarioRecomendado)*/

accionDeUsuario(lider,compraCupon(60,"20/12/2010",laGourmet)).
accionDeUsuario(lider,compraCupon(50,"04/05/2011",elGatoNegro)).
accionDeUsuario(alf,compraCupon(74,"03/02/2011",elMundoDelBuceo)).
accionDeUsuario(fede,compraCupon(35,"05/06/2011",elTano)).
accionDeUsuario(fede,recomiendaCupon(elGatoNegro,"04/05/2011",lider)).
accionDeUsuario(lider,recomiendaCupon(cuspide,"13/05/2011",alf)).
accionDeUsuario(alf,recomiendaCupon(cuspide,"13/05/2011",fede)).
accionDeUsuario(fede,recomiendaCupon(cuspide,"13/05/2011",roque)).
accionDeUsuario(lider,recomiendaCupon(cuspide,"24/07/2011",fede)).


/* punto 1 */
ciudadGenerosa(Ciudad):- 	
	usuario(_,Ciudad),
	forall(cuponVigente(Ciudad,cupon(_,_,Descuento)),Descuento > 60).
							
/* punto 2 */
							
puntosGanados(Usuario,Puntos):-	
	findall(Puntos,recomendacion(Usuario,Puntos),PuntosRecomendaciones),
	findall(Puntos,compraDeCupon(Usuario,Puntos),PuntosCompras),
	sumlist(PuntosRecomendaciones,TotalRecomendaciones),
	sumlist(PuntosCompras,TotalCompras),
	Puntos is TotalRecomendaciones + TotalCompras.

recomendacion(Usuario,Puntos):- 
	accionDeUsuario(Usuario,recomiendaCupon(Marca,Fecha,UsuarioRecomendado)),
	accionDeUsuario(UsuarioRecomendado,compraCupon(_,Fecha,Marca)),
	Puntos is 5 .
										
recomendacion(Usuario,Puntos):- 
	accionDeUsuario(Usuario,recomiendaCupon(Marca,Fecha,UsuarioRecomendado)),
	not(accionDeUsuario(UsuarioRecomendado,compraCupon(_,Fecha,Marca))),
	Puntos is 1 .
								
compraDeCupon(Usuario,Puntos):- 
	accionDeUsuario(Usuario,compraCupon(_,_,_)),
	Puntos is 10 .
								
/* punto 3 */

promedioDePuntosPorMarca(Marca,Promedio):-  
	findall(Puntos,recomendacionDeMarca(Marca,Puntos),PuntosRecomendaciones),
	findall(Puntos,compraDeMarca(Marca,Puntos),PuntosCompras),
	sumlist(PuntosRecomendaciones,TotalRecomendaciones),
	sumlist(PuntosCompras,TotalCompras),
	length(PuntosRecomendaciones,CantRecomendaciones),
	length(PuntosCompras,CantCompras),
	Sum is TotalRecomendaciones + TotalCompras,
	Cant is CantRecomendaciones + CantCompras,
	Prom is Sum / Cant.
											
recomendacionDeMarca(Marca,Puntos):-
	accionDeUsuario(_,recomiendaCupon(Marca,Fecha,UsuarioRecomendado)),
	accionDeUsuario(UsuarioRecomendado,compraCupon(_,Fecha,Marca)),
	Puntos is 5 .

recomendacionDeMarca(Marca,Puntos):-
	accionDeUsuario(_,recomiendaCupon(Marca,Fecha,UsuarioRecomendado)),
	not(accionDeUsuario(UsuarioRecomendado,compraCupon(_,Fecha,Marca))),
	Puntos is 1 .
								
compraDeMarca(Marca,Puntos):-	
	accionDeUsuario(_,compraCupon(_,_,Marca)),
	Puntos is 10 .
								
/* punto 4 */

lePuedeInteresarElCupon(Usuario,cupon(Marca,Producto,Descuento)):-  
	usuario(Usuario,Ciudad),
	cuponVigente(Ciudad,cupon(Marca,Producto,Descuento)),
	accionDeUsuario(Usuario,compraCupon(_,_,Marca)).
																	
lePuedeInteresarElCupon(Usuario,cupon(Marca,Producto,Descuento)):-  
	usuario(Usuario,Ciudad),
	cuponVigente(Ciudad,cupon(Marca,Producto,Descuento)),
	accionDeUsuario(_,recomiendaCupon(Marca,_,Usuario)).

/* punto 5 */

nadieLeDioBola(Usuario):-	
	not((accionDeUsuario(Usuario,recomiendaCupon(Marca,Fecha,Recomendado)),accionDeUsuario(Recomendado,compraCupon(_,Fecha,Marca)))).

/* punto 6 */

% cadenaDeRecomendacionesValida(Marca,Fecha,Recomendaciones):-