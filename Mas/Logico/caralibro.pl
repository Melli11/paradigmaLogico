
usuario(fer).
usuario(gabi).
usuario(leo).
usuario(flor).
usuario(lucho).
usuario(lucu).

viveEn(fer, direccion(argentina, liniers)).
viveEn(gabi, direccion(argentina, liniers,1407)).
viveEn(leo, direccion(argentina, liniers)).
viveEn(flor,direccion(argentina,liniers)).
viveEn(lucho,direccion(argentina,liniers,1408)).

nacimiento(flor,anios(20)).
nacimiento(lucho,fecha(1,10,1994)).
nacimiento(fer, anios(27)).
nacimiento(gabi, fecha(30,09,1982)).
nacimiento(leo,anios(27)).

tieneAmigo(leo, gaston).
tieneAmigo(leo, gabi).
tieneAmigo(gabi, leo).
tieneAmigo(gabi,fer).
tieneAmigo(fer, gabi).
tieneAmigo(fer,lucho).
tieneAmigo(flor,lucho).
tieneAmigo(lucho,flor).
tieneAmigo(lucho,fer).


hoy(fecha(2,10,2008)).

grupo(ayudantesParadigmas).
grupo(invento).

integra(ayudantesParadigmas, leo).
integra(ayudantesParadigmas, gabi).
integra(ayudantesParadigmas, fer).
integra(invento,flor).
integra(invento,lucho).
integra(invento,fer).

sonAmigos(P1,P2):-
    usuario(P1),usuario(P2),
    tieneAmigo(P1,P2),
    tieneAmigo(P2,P1).

amigosQueCumplenEsteMes(P1,Lista):-
    findall(P2,
            (hoy(fecha(_,Mes,_)),
             sonAmigos(P1,P2),
             nacimiento(P2,fecha(_,Mes,_))),
            Lista).

talVezConozcas(P1,P2):-
    dondeVive(P1,D),
    dondeVive(P2,D),
    P1\=P2.
talVezConozcas(P1,P2):-
    sonAmigos(P1,P3),
    sonAmigos(P2,P3),
    P1\=P2.
talVezConozcas(P1,P2):-
    P1\=P2,
    integra(Grupo,P1),
    integra(Grupo,P2),
    grupo(Grupo).

dondeVive(P1,Donde):-
    viveEn(P1,direccion(_,Donde)).

dondeVive(P1,Donde):-
    viveEn(P1,direccion(_,Donde,_)).

esPopular(Persona):-
    usuario(Persona),
    integra(Grupo,Persona),
    forall(mismoGrupo(Persona,P2,Grupo),
            sonAmigos(Persona,P2)).

mismoGrupo(P1,P2,Grupo):-
    P1\=P2,
    grupo(Grupo),
    integra(Grupo,P1),
    integra(Grupo,P2).

estanConectados(P1,P2):-
    sonAmigos(P1,P2).

estanConectados(P1,P2):-
     tieneAmigo(P1,X),
     sonAmigos(P1,X),
     estanConectados(X,P2).
