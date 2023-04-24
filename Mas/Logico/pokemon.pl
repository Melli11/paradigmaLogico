pokemon(dragon,[dratini,dragonair,dragonite],[nivel(30),nivel(55)]).
pokemon(electrico,[pichu, pikachu, raichu],[alegria,piedra]).
pokemon(fuego,[charmander,charmeleon,charizar],[nivel(16),nivel(36)]).
pokemon(pelea,[tyrogen,hitmonchan],[nivel(20)]).
pokemon(pelea,[tyrogen,hitmonlee],[nivel(20)]).
pokemon(normal,[snorlax],[]).
pokemon(normal,[rattata,raticate],[nivel(20)]).
pokemon(agua,[staryu,starmie],[piedra]).
pokemon(agua,[psyduck,golduck],[nivel(33)]).
pokemon(tierra,[sandshrew,sandslash],[nivel(22)]).
pokemon(roca,[aerodactyl],[]).
pokemon(roca,[onix],[]).
pokemon(fantasma,[gastly,haunter,gengar],[nivel(25),intercambio]).


inmune(tierra,electrico).
inmune(fantasma,pelea).
inmune(fantasma,normal).
inmune(normal,fantasma).

fuerteContra(pelea,normal).
fuerteContra(pelea,roca).
fuerteContra(electrico,agua).
fuerteContra(fantasma,fantasma).
fuerteContra(tierra,roca).
fuerteContra(roca,normal).
fuerteContra(agua,fuego).


entrenador(ash,[pokebola(snorlax,55),pokebola(pikachu,70),pokebola(rattata,50),pokebola(charmander,60)],piedra).
entrenador(loly,[pokebola(snorlax,55),pokebola(gengar,70),pokebola(rattata,50),pokebola(charmander,60)],piedra).

entrenador(lance,[pokebola(dragonite,80),pokebola(aerodactyl,70)],medalla).
entrenador(brock, [pokebola(hitmonchan,58),pokebola(onix,60)],piedra).
entrenador(misty,[pokebola(staryu,60),pokebola(psyduck,34)],medalla).
entrenador(flor,[pokebola(charizard,60),pokebola(charmander,34)],medalla).



tipo(Pokemon,Tipo):-
    pokemon(Tipo,Lista,_),
    member(Pokemon,Lista).

entrenadorGroso(Entrenador):-
    entrenador(Entrenador,Pokes,_),
    hayGrosa(Pokes).

esGrosa(pokebola(_,Nivel)):-
    Nivel>65.

esGrosa(pokebola(Pk,_)):-
        tipo(Pk,dragon).

hayGrosa([_|Ps]):-
    hayGrosa(Ps).

hayGrosa([P|_]):-
    esGrosa(P).

pokemonFavorito(Entrenador, Poke):-
    pokebolaDe(Entrenador,pokebola(Poke,Nivel)),
    forall(pokebolaDe(Entrenador,pokebola(_,OtroNivel)),Nivel>=OtroNivel).

pokebolaDe(Entrenador,Pokebola):-
    entrenador(Entrenador,Pks,_),
    member(Pokebola,Pks).

puedeEvolucionar(Entrenador,pokebola(Pokemon,Nivel)):-
    pokebolaDe(Entrenador,pokebola(Pokemon,Nivel)),
    condicionDeEvolucion(pokebola(Pokemon,Nivel),Condicion),
    cumpleCondicion(Condicion,pokebola(Pokemon,Nivel),Entrenador).

condicionDeEvolucion(pokebola(P,_),C):-
    pokemon(_,Evoluciones,Condiciones),
    nth1(Pos,Evoluciones,P),
    nth1(Pos,Condiciones,C).


%nth1(Pos,Lista,Elemento).
%forall todas las condiciones existentes => se cumpleCondicion

%cumpleCondicion(Condicion,pokemon)

cumpleCondicion(nivel(N),pokebola(_,Nivel),_):-
                   Nivel>=N.

cumpleCondicion(Objeto,_,Entrenador):-
    entrenador(Entrenador,_,Objeto).

cumpleCondicion(alegria,pokebola(P,_),Entrenador):-
   pokemonFavorito(Entrenador,P).

pokemonAburrido(Pokemon):-
    pokemon(_,Lista,_),
    member(Pokemon,Lista),
    length(Lista,L),
    L=<1.

pokemonAburrido(Pokemon):-
    pokemon(normal,Ps,_),
    member(Pokemon,Ps).


convienePelear(pokebola(P1,_),pokebola(P2,_)):-
    not(esInmune(P2,P1)),
    esInmune(P1,P2).

convienePelear(pokebola(P1,_),pokebola(P2,_)):-
    not(esInmune(P2,P1)),
    esFuerte(P1,P2).

convienePelear(pokebola(P1,N1),pokebola(P2,N2)):-
   not(esInmune(P2,P1)), not(esFuerte(P2,P1)),
  N2<N1.

esInmune(P1,P2):-
    tipo(P1,T1),
    tipo(P2,T2),
    inmune(T1,T2).

esFuerte(P1,P2):-
    tipo(P1,T1),
    tipo(P2,T2),
    fuerteContra(T1,T2).

sacarDePokebola(pokebola(P,_),P).

tieneVariedad(Entrenador):-
    entrenador(Entrenador,_,_),
     findall(Tipo,
             (entrenador(Entrenador,Pokes,_),member(P,Pokes),sacarDePokebola(P,Pk),tipo(Pk,Tipo)),
             Tipos),
     list_to_set(Tipos,Tipos2),
     length(Tipos2,N),
     N>=3.

fanatico(Entrenador):-
      entrenador(Entrenador,_,_),
    findall(Tipo,
            (entrenador(Entrenador,Pks,_),member(P,Pks),sacarDePokebola(P,Pk),tipo(Pk,Tipo)),
             Tipos),
    list_to_set(Tipos,Tipos2),
    length(Tipos2,1).
