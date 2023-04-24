% Contamos con una base de conocimientos con la siguiente información en un
% jardín de infantes:

% -- jugoCon/3: nene, juego, minutos
jugoCon(tobias, pelota, 15 ).
jugoCon(tobias, bloques, 20 ).
jugoCon(tobias, rasti, 15 ).
jugoCon(tobias, dakis, 5 ).
jugoCon(tobias, casita, 10 ).
jugoCon(cata, muniecas, 30 ).
jugoCon(cata, rasti, 20 ).
jugoCon(luna, muniecas, 10 ).


% Queremos saber
% ● cuántos minutos jugó un nene según la base de conocimientos
% ● cuántos juegos distintos jugó (no hay duplicados en la base)
    

elQueMasMinutosJugo(Nene,TiempoDeJuego):-
    cuantosMinutosJugo(Nene,TiempoDeJuego),
    not((cuantosMinutosJugo(OtroNene,OtroTiempoDeJuego),OtroNene\=Nene,OtroTiempoDeJuego>TiempoDeJuego)). 

elQueMenosMinutosJuego(Nene,TiempoDeJuego):-
    cuantosMinutosJugo(Nene,TiempoDeJuego),
    not((cuantosMinutosJugo(OtroNene,OtroTiempoDeJuego),OtroNene\=Nene,OtroTiempoDeJuego<TiempoDeJuego)). 

cuantosMinutosJugo(Nene,TotalMinutos):-
    nene(_,Nene),
    findall(Minutos,jugoCon(Nene,_,Minutos),LTotalMinutos),
    sum_list(LTotalMinutos,TotalMinutos).

cuantosJuegosDistintosJugo(Nene,CantidadJuegos):-
    nene(_,Nene),
    findall(Juegos,jugoCon(Nene,Juegos,_),LTotalJuegos),
    length(LTotalJuegos, CantidadJuegos).
    
nene(Nene,Resultado):-
    findall(Nene,jugoCon(Nene,_,_),ListaNenes),
    list_to_set(ListaNenes,LSRepetidos),
    member(Resultado,LSRepetidos).
    