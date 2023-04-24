usuario(lider,capitalFederal).
usuario(alf,lanus).
usuario(roque,laPlata).
usuario(fede, capitalFederal).
 
% los functores cupon son de la forma 
%  cupon(Marca,Producto,PorcentajeDescuento)
cuponVigente(capitalFederal,cupon(elGatoNegro,setDeTe,35)).
cuponVigente(capitalFederal,cupon(lasMedialunasDelAbuelo,panDeQueso,43)).
cuponVigente(capitalFederal,cupon(laMuzzaInspiradora,pizzaYBirraParaDos,80)).
cuponVigente(lanus,cupon(maoriPilates,ochoClasesDePilates,75)).
cuponVigente(lanus,cupon(elTano,parrilladaLibre,65)).
cuponVigente(lanus,cupon(niniaBonita,depilacionDefinitiva,73)).


% comprar con un cupón, que se representa con un functor: 
% compraCupon(PorcentajeDescuento,Fecha,Marca)

% ● recomendar un cupón, representado como: 
% recomiendaCupon(Marca,Fecha,UsuarioRecomendado)

accionDeUsuario(lider,compraCupon(60,"20/12/2010",laGourmet)).
accionDeUsuario(lider,compraCupon(50,"04/05/2011",elGatoNegro)).
accionDeUsuario(alf,compraCupon(74,"03/02/2011",elMundoDelBuceo)).
accionDeUsuario(fede,compraCupon(35,"05/06/2011",elTano)).
 
accionDeUsuario(fede,recomiendaCupon(elGatoNegro,"04/05/2011",lider)).
accionDeUsuario(lider,recomiendaCupon(cuspide,"13/05/2011",alf)).
accionDeUsuario(alf,recomiendaCupon(cuspide,"13/05/2011",fede)).
accionDeUsuario(fede,recomiendaCupon(cuspide,"13/05/2011",roque)).
accionDeUsuario(lider,recomiendaCupon(cuspide,"24/07/2011",fede)).

% Predicados Auxiliares
cupones(Cupon):-
    cuponVigente(_,Cupon).

ciudad(Ciudad):-
    usuario(_,Ciudad).

% 1) ciudadGenerosa/1: una ciudad es generosa si todos sus cupones vigentes ofrecen más del 
% 60% de descuento. Este predicado debe ser inversible.

ciudadGenerosa(Ciudad):-
    ciudad(Ciudad),    
    forall(cuponVigente(Ciudad,cupon(_,_,PorcentajeDescuento)),PorcentajeDescuento > 60).

% 2) puntosGanados/2: relaciona a una persona y el total de puntos que ganó usando Grupón.
% ● Por cada recomendación exitosa, el usuario gana 5 puntos.
% ● Por cada cupón que haya comprado, el usuario gana 10 puntos.
% ● Por cada recomendación no exitosa, el usuario gana 1 punto.

