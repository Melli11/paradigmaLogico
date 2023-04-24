usuario(lider,capitalFederal).
usuario(alf,lanus).
usuario(roque,laPlata).
usuario(fede, capitalFederal).

 % los functores cupon son de la forma % cupon(Marca,Producto,PorcentajeDescuento)
cuponVigente(capitalFederal,cupon(elGatoNegro,setDeTe,35)).
cuponVigente(capitalFederal,cupon(lasMedialunasDelAbuelo,panDeQueso,43)).
cuponVigente(capitalFederal,cupon(laMuzzaInspiradora,pizzaYBirraParaDos,80)).
cuponVigente(lanus,cupon(maoriPilates,ochoClasesDePilates,75)).
cuponVigente(lanus,cupon(elTano,parrilladaLibre,65)).
cuponVigente(lanus,cupon(niniaBonita,depilacionDefinitiva,73)).

accionDeUsuario(lider,compraCupon(60,"20/12/2010",laGourmet)).
accionDeUsuario(lider,compraCupon(50,"04/05/2011",elGatoNegro)).
accionDeUsuario(alf,compraCupon(74,"03/02/2011",elMundoDelBuceo)).
accionDeUsuario(fede,compraCupon(35,"05/06/2011",elTano)).

accionDeUsuario(fede,recomiendaCupon(elGatoNegro,"04/05/2011",lider)).
accionDeUsuario(lider,recomiendaCupon(cuspide,"13/05/2011",alf)).
accionDeUsuario(alf,recomiendaCupon(cuspide,"13/05/2011",fede)).
accionDeUsuario(fede,recomiendaCupon(cuspide,"13/05/2011",roque)).
accionDeUsuario(lider,recomiendaCupon(cuspide,"24/07/2011",fede)).

ciudad(Ciudad):-
    cuponVigente(Ciudad,_).

ciudadGenerosa(Ciudad):-
    ciudad(Ciudad),
    forall(cuponVigente(Ciudad,cupon(_,_,D)),D>60).

puntosGanados(Persona,Puntos):-
    usuario(Persona,_),
    findall(Punto1,recomExitosa(Persona,Punto1),Puntaje1),
    findall(Punto2,recNoEx(Persona,Punto2),Puntaje2),
    findall(Punto3,comprasDe(Persona,Punto3),Puntaje3),
    sum_list(Puntaje1,C1),sum_list(Puntaje2,C2),sum_list(Puntaje3,C3),
    Puntos is C1+C2+C3.


recomExitosa(Persona,5):-
    accionDeUsuario(Persona,recomiendaCupon(M,F,Aquien)),
    accionDeUsuario(Aquien,compraCupon(_,F,M)).
recNoEx(Persona,1):-
    accionDeUsuario(Persona,recomiendaCupon(M,F,Aquien)),
    not(accionDeUsuario(Aquien,compraCupon(_,F,M))).

comprasDe(Persona,Puntos):-
    findall(Cupon,accionDeUsuario(Persona,compraCupon(_,_,Cupon)),Cupones),
    length(Cupones,C),
    Puntos is C*10.




