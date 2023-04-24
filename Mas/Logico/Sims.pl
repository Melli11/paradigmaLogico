% los intereses de cada sim
intereses(cholo,[deportes,musica,computacion,sociedad]).
intereses(lara,[moda, musica,economia,animales]).
intereses(flor,[moda,computacion]).

% la personalidad de los Sims en los distintos aspectos
% viene dada por su signo
personalidadPorSigno(aries,pulcritud,5).
personalidadPorSigno(aries,extroversion,7).
personalidadPorSigno(aries,actividad,4).
personalidadPorSigno(aries,animoLudico,5).
personalidadPorSigno(aries,cordialidad,4).

personalidadPorSigno(cancer,pulcritud,2).
personalidadPorSigno(cancer,extroversion,2).
personalidadPorSigno(cancer,actividad,2).
personalidadPorSigno(cancer,animoLudico,2).
personalidadPorSigno(cancer,cordialidad,2).

personalidadPorSigno(leo,pulcritud,7).
personalidadPorSigno(leo,extroversion,7).
personalidadPorSigno(leo,actividad,4).
personalidadPorSigno(leo,animoLudico,5).
personalidadPorSigno(leo,cordialidad,3).

signoSim(cholo,cancer).
signoSim(lara,aries).
signoSim(flor,leo).

% para cada Sim se maneja su nivel de distintos estados
% nivelSim relaciona sim, estado y nivel
nivelSim(cholo,energia,6).
nivelSim(cholo,diversion,9).
nivelSim(cholo,sociedad,7).
nivelSim(cholo,hambre,3).
nivelSim(cholo,banio,3).

nivelSim(lara,energia,9).
nivelSim(lara,diversion,4).
nivelSim(lara,sociedad,9).
nivelSim(lara,hambre,9).
nivelSim(lara,banio,9).

nivelSim(flor,hambre,2).
nivelSim(flor,energia,6).
nivelSim(flor,banio,2).
nivelSim(flor,sociedad,1).
nivelSim(flor,diversion,1).
%    y el banio (... el sim se hace encima).
seAutoAtiende(sociedad).
seAutoAtiende(banio).

% el efecto que tienen los accesorios que pueden usar
% los sims sobre sus estados
efecto(sillon,suma(energia,4)).
efecto(cama,asigna(energia,9)).
efecto(tele,duplica(diversion)).
efecto(tarea,asigna(diversion,3)).
efecto(silla,asigna(energia,3)).
efecto(computadora,suma(diversion,5)).


noCongenian(Sim1,Sim2):-
    existeSim(Sim1),
    existeSim(Sim2),
    not(puedenHablarDe(futuro,Sim1,Sim2)).
noCongenian(Sim1,Sim2):-
    existeSim(Sim1),
    existeSim(Sim2),

    not(puedenHablarDe(cocina,Sim1,Sim2)).
noCongenian(Sim1,Sim2):-
    existeSim(Sim1),
    existeSim(Sim2),

    not(puedenHablarDe(_,Sim1,Sim2)).

existeSim(Sim):-
    signoSim(Sim,_).

puedenHablarDe(cocina,S1,S2):-
    nivelSim(S1,hambre,H1),
    nivelSim(S2,hambre,H2),
    H1<8,H2<8.
puedenHablarDe(futuro,S1,S2):-
    nivelSim(S1,energia,E1),
    nivelSim(S2,energia,E2),
    E1>12,E2>12.
puedenHablarDe(Algo,S1,S2):-
    intereses(S1,Ints1),
    intereses(S2,Ints2),
    member(Algo,Ints1),
    member(Algo,Ints2).

seLlevanBien(S1,S2):-
    existeSim(S1),existeSim(S2),
    findall(Nivel,nivelSim(S1,_,Nivel),Niveles1),
    findall(Nivel,nivelSim(S2,_,Nivel),Niveles2),
    restarBanio(Niveles1,NsinB,S1),
    restarBanio(Niveles2,NsinB,S2).

restarBanio(ListaCon,ListaSin,Sim):-
    nivelSim(Sim,banio,Nivel),
    sum_list(ListaCon,C),
    ListaSin is C-Nivel.

esPar(X):- 0 is X mod 2.

existeEstado(Estado):-
    nivelSim(_,Estado,_).

necesitaAtencion(Estado,Nivel):-
    existeEstado(Estado),
    not(seAutoAtiende(Estado)),
    Nivel<9.
necesitaAtencion(hambre,Nivel):-
    esPar(Nivel).

deBuenHumor(Sim):-
    existeSim(Sim),
    forall(nivelSim(Sim,Estado,Nivel),not(necesitaAtencion(Estado,Nivel))).

compartenPesares(Sim1,Sim2,E):-
    estaComplicado(Sim1,E),
    estaComplicado(Sim2,E).

estaComplicado(Sim,Estado):-
    nivelSim(Sim,Estado,Nivel),
    necesitaAtencion(Estado,Nivel).

esSociable(Sim):-
    signoSim(Sim,Signo),
    personalidadPorSigno(Signo,extroversion,C),
    C>6.

compatible(S1,S2):-
    signoSim(S1,Signo1),
    signoSim(S2,Signo2),
    findall(Nivel,(personalidadPorSigno(Signo1,_,Nivel),
                   personalidadPorSigno(Signo2,_,Nivel)),
            Niveles),
    length(Niveles,C),
    C>3.

puedenSerAmigos(S1,S2):-
    esSociable(S1),
    esSociable(S2).

puedenSerAmigos(S1,S2):-
    compatible(S1,S2).

puedenSerAmigos(S1,S2):-
    seLlevanBien(S1,S2),
    deBuenHumor(S1),deBuenHumor(S2).


afecta(Accesorio,Estado):-
    efecto(Accesorio,suma(Estado,_)).
afecta(Accesorio,Estado):-
    efecto(Accesorio,asigna(Estado,_)).
afecta(Accesorio,Estado):-
    efecto(Accesorio,duplica(Estado)).

aplicar(Estado,Accesorio,Ni,Nf):-
    efecto(Accesorio,suma(Estado,C)),
    Nf is Ni+C.

aplicar(Estado,Accesorio,_,Nf):-
    efecto(Accesorio,asigna(Estado,Nf)).

aplicar(Estado,Accesorio,Ni,Nf):-
    efecto(Accesorio,duplica(Estado)),
    Nf is Ni*2.

leVieneBien(Sim,Accesorio):-
    afecta(Accesorio,Estado),
    estaComplicado(Sim,Estado),
    nivelSim(Sim,Estado,Ni),
    aplicar(Estado,Accesorio,Ni,Nf),
    not(necesitaAtencion(Estado,Nf)).


