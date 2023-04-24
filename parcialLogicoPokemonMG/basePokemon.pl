% pokemon(tipo, cadena de evolución, condiciones de evolución)
pokemon(dragon, [dratini, dragonair, dragonite], [nivel(30), nivel(55)]).
pokemon(electrico, [pichu, pikachu, raichu], [alegria, piedra]).
pokemon(fuego, [charmander, charmeleon, charizard], [nivel(16), nivel(36)]).
pokemon(pelea, [tyrogue, hitmonchan], [nivel(20)]).
pokemon(pelea, [tyrogue, hitmonlee], [nivel(20)]).
pokemon(normal, [snorlax], []).
pokemon(normal, [rattata, raticate], [nivel(20)]).
pokemon(agua, [staryu, starmie], [piedra]).
pokemon(agua, [psyduck, golduck], [nivel(33)]).
pokemon(tierra, [sandshrew, sandslash], [nivel(22)]).
pokemon(roca, [aerodactyl], []).
pokemon(roca, [onix], []). 
pokemon(fantasma, [gastly, haunter, gengar], [nivel(25), intercambio]).

% inmune(tipo inmune, tipo contrario)
inmune(tierra, electrico).
inmune(fantasma, pelea).
inmune(fantasma, normal).
inmune(normal, fantasma).

% fuerteContra(tipo fuerte, tipo contrario)
fuerteContra(pelea, normal).
fuerteContra(pelea, roca).
fuerteContra(electrico, agua).
fuerteContra(fantasma, fantasma).
fuerteContra(tierra, roca).
fuerteContra(roca, normal).
fuerteContra(agua, fuego).

%%Cada entrenador puede tener varios Pokemon, cada uno de ellos contenido en una pokebola.
% entrenador(nombre, pokebolas, elemento)
% pokebola(pokemon, nivel)


entrenador(ash, [pokebola(snorlax, 55), pokebola(pikachu, 70), pokebola(rattata, 50), pokebola(charmander, 60)], piedra).
entrenador(misty, [pokebola(staryu, 60), pokebola(psyduck, 34)], medalla).
entrenador(brock, [pokebola(hitmonchan, 58), pokebola(onix, 60)], piedra).
entrenador(lance, [pokebola(dragonite, 80), pokebola(aerodactyl, 70)], medalla).



%%NOTA: Todos los predicados deben ser inversibles, a menos que se indique lo contrario.

/*  Se pide desarrollar los predicados que permitan:
1.  Relacionar a un Pokemon con su tipo. (Dratini - dragón, Pikachu - eléctrico, etc.)
?- tipo(dratini,Tipo).
Tipo = dragon ;
false
*/

tipo(Pokemon,Tipo):-
    pokemon(Tipo,Evoluciones,_),
    member(Pokemon, Evoluciones). %si usamos nth no es necesario member 
    

/*
2.  Saber si un entrenador es groso. Un entrenador es groso cuando tiene al menos una pokebola grosa, y una pokebola es grosa si tiene un dragón o tiene un pokemon nivel superior a 65. (Lance y Ash son grosos)
?- entrenadorGroso(ash).
true
*/

/*
RECORDANDO 

Cada entrenador puede tener varios Pokemon, cada uno de ellos contenido en una pokebola.
 entrenador(nombre, pokebolas, elemento)

entrenador(ash, [pokebola(snorlax, 55), pokebola(pikachu, 70), pokebola(rattata, 50), pokebola(charmander, 60)], piedra).
entrenador(misty, [pokebola(staryu, 60), pokebola(psyduck, 34)], medalla).
entrenador(brock, [pokebola(hitmonchan, 58), pokebola(onix, 60)], piedra).
entrenador(lance, [pokebola(dragonite, 80), pokebola(aerodactyl, 70)], medalla).

*/
entrenadorGroso(Entrenador):-
    entrenador(Entrenador,Pokebolas, _ ), %%predicado generador de entranadores, no me interesa el 3er parametro
    member(Pokebola, Pokebolas), %%predicado generador de pokebolas, con member accedo a un elemento de la lista de pokebolas
    tienePokebolaGrosa(Pokebola).

tienePokebolaGrosa(pokebola(Pokemon,_)):- %%pasa como parametro el functor, para decir que estoy refiriendome a un pokemon que está dentro de una pokebola, y dentro de esta parte  de la regla solo discrimino el tipo dragon 
    tipo(Pokemon,dragon). %% con el predicado tipo logro el fin

tienePokebolaGrosa(pokebola( _ , Nivel)):- %%pasa como parametro el functor, para decir que estoy refiriendome a un pokemon que está dentro de una pokebola, y completo la regla considerando solo el nivel y realizo la acotación 
    Nivel > 65.


/*
3.  Relacionar un entrenador con su Pokemon favorito, que es aquel de la pokebola de mayor nivel. (Ash - Pikachu, Misty - Staryu, Brock - Onix, Lance - Dragonite)
?- pokemonFavorito(Entrenador,Pokemon).
Entrenador = ash
Pokemon = pikachu .
true
*/

%%hay mas de 1 forma de hacerlo
pokemonFavorito(Entrenador, Pokemon):-
    entrenador(Entrenador, Pokebolas, _), %%predicado generador de entranadores,     member(Pokebola, Pokebolas),
    member(pokebola(Pokemon, Nivel), Pokebolas), %%predicado generador de pokebolas
    not((member(pokebola(_, OtroNivel), Pokebolas), OtroNivel > Nivel)). %%no hay otro de mayor nivel, chequear  

/*
4.  Relacionar a un entrenador con una de sus pokebolas si el Pokemon dentro de la misma
 puede evolucionar con ese entrenador. Un Pokemon puede evolucionar si:
llegó al nivel mínimo necesario para evolucionar, (Rattata y Charmander, de Ash, y Psyduck, de Misty)
el entrenador tiene el elemento para que evolucione (Pikachu, de Ash), o bien
es el favorito y la condición para evolucionar es de alegría (no hay ejemplo).
?- puedeEvolucionar(ash,Pokebola).
Pokebola = pokebola(pikachu, 70) ;
Pokebola = pokebola(rattata, 50) ;
Pokebola = pokebola(charmander, 60) ;
false
*/

puedeEvolucionar(Entrenador,Pokebola):-
    entrenador(Entrenador, Pokebolas, _), %%predicado generador de entranadores,     member(Pokebola, Pokebolas),
    member(pokebola(Pokemon, Nivel), Pokebolas), %%predicado generador de pokebolas
    llegoAlNivelMinimo(, , ).

/*
puedeEvolucionar(Entrenador,Pokebola):-
    entrenador(,,Elemento).
*/
/*
puedeEvolucionar(Entrenador,Pokebola):-
    pokemonFavorito(),
    entrenador(Entrenador, _ ,alegria),
*/

/*
5.  Saber si un pokemon es aburrido, que es aquel que no evoluciona ni evolucionó para llegar a lo que es (es el único en su cadena de evolución), o bien es de tipo normal. (Snorlax, Rattata, Raticate, Aerodactyl, Onix)
?- pokemonAburrido(snorlax).
	true .
*/

/*
6.  Saber si a un Pokemon de una pokebola le conviene pelear con otro de otra pokebola. Al primero nunca le conviene pelear si el tipo del segundo es inmune contra su tipo. Además, debe cumplirse que el primero es inmune contra el tipo del segundo, o bien es fuerte contra ese tipo, o bien el segundo no es fuerte contra el tipo del primero y el primero tiene mayor nivel que el segundo. La relación es entre dos pokebolas y no requiere ser inversible para ninguno de sus parámetros.
(pokebola(pikachu, 70) - pokebola(psyduck, 34), por ejemplo, porque el eléctrico es fuerte contra el de agua, y también por la diferencia de nivel)
	?- leConvienePelear(pokebola(pikachu,70),pokebola(psyduck,34)).
	true .
*/

/*
7.  Determinar si un entrenador tiene variedad, que es cuando tiene al menos 3 tipos distintos de Pokemon.
(Ash, porque tiene pokemon de 3 tipos (normal, eléctrico y fuego))
	?- tieneVariedad(ash).
	true.
*/

/*
8.  Determinar si un entrenador es fanático de un tipo, que es cuando tiene más de un Pokemon y todos son de ese tipo. (Misty - agua)
?- entrenadorFanatico(Entrenador).
Entrenador = misty ;
false
*/

/*
9.  OPCIONAL (léase: “si está bien, suma... si está mal, no resta”)
Saber en qué Pokemon puede evolucionar otro dentro de una pokebola, por mérito propio.
Lo único que se deberá tener en cuenta como necesario es el nivel, por los otras condiciones de evolución, siempre “podría” evolucionar.
La relación es entre 2 pokebolas y no necesita ser inversible para el primer parámetro.


(pokebola(rattata, 50) - pokebola(raticate, 50), 
pokebola(tyrogue, 22) - pokebola(hitmonchan, 22), 
pokebola(tyrogue, 22) - pokebola(hitmonlee, 22),
pokebola(gastly, 30) - pokebola(haunter, 30) / pokebola(gengar, 30)
etc.)
?- podriaSer(pokebola(gastly, 50), Pokebola). --> Pokebola = pokebola(haunter, 50) ; Pokebola =

pokebola(gengar, 50) ; false. (el primero por nivel suficiente, el segundo porque siempre puede)

?- podriaSer(pokebola(gastly, 14), Pokebola). --> false (no tiene nivel suficiente)
*/


/*TEST*/
:- begin_tests(pokemon).
test(tipoDeUnPokemon):-
    tipo(dragonite,dragon).
test(entrenadorGroso):-
    entrenadorGroso(lance).

:-end_tests(pokemon).

