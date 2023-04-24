### Parcial Logico PokemonMG ##

<https://docs.google.com/document/d/1hz2nUgU3lqrG2szCiGJ1bjgCJfLdXaZoYWdnkStcZ14/edit>

¡Hola! ¡Bienvenido al mundo de Pokemon! Mi nombre es Oak. La gente me llama “Profesor Pokemon”.  
Este mundo está habitado por criaturas llamadas Pokemon. Para algunas personas, los Pokemon son mascotas.  
Otras las usan para luchas. Yo... yo me dedico a estudiar a los Pokemon.  
Necesito tu ayuda para avanzar con mis estudios. Actualmente me estoy enfocando en las posibles evoluciones de estos fascinantes seres, y también en las batallas entre entrenadores de Pokemon, y para esto se me ocurrió que podrías ayudarme desarrollando un programa en Prolog que permita analizar las relaciones entre los distintos Pokemon y sus entrenadores.  
Cada Pokemon tiene un tipo que lo caracteriza, y le da ciertos atributos frente a otros tipos de Pokemon, como inmunidad o fortaleza. Además, un Pokemon puede “evolucionar”, es decir, transformarse en otro distinto, si cumple el requisito necesario. La información sobre los Pokemon se encuentra modelada en base a predicados pokemon/3, que relacionan el tipo, la cadena de evolución y las correspondientes condiciones de evolución. Cada evolución de una especie a otra tiene una condición. Por ejemplo, si un “Psyduck”, primero en su cadena de evolución, alcanza un nivel mínimo de 33, primera condición de evolución, entonces puede evolucionar transformándose en un “Golduck”, el elemento inmediato siguiente de la cadena. Algunos, como los “Tyrogue”, pueden tener más de una cadena posible.    

pokemon(tipo, cadena de evolución, condiciones de evolución)  
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
Cada entrenador puede tener varios Pokemon, cada uno de ellos contenido en una pokebola.  
% entrenador(nombre, pokebolas, elemento)  
% pokebola(pokemon, nivel)  
entrenador(ash, [pokebola(snorlax, 55), pokebola(pikachu, 70), pokebola(rattata, 50), pokebola(charmander, 60)], piedra).  
entrenador(misty, [pokebola(staryu, 60), pokebola(psyduck, 34)], medalla).  
entrenador(brock, [pokebola(hitmonchan, 58), pokebola(onix, 60)], piedra).  
entrenador(lance, [pokebola(dragonite, 80), pokebola(aerodactyl, 70)], medalla).    

Tener en cuenta la existencia de los siguientes predicados (no hay necesidad de definirlos):  
*nth1/3 relaciona una posición, una lista y un elemento que ocupa esa posición en esa lista. Es inversible, excepto para la lista.
*list_to_set/2 relaciona una primera lista que puede contener elementos repetidos con una segunda lista con los mismos elementos, pero descartando las repeticiones. Es inversible para el segundo argumento.    
De acuerdo con cómo desarrollen sus predicados, pueden no necesitarlos.    
Por otra parte, si se necesita usar un predicado de un punto N para algún punto posterior M y no logran desarrollar el del punto N, igualmente se puede usar en M y esto NO afecta el punto M.  

NOTA: Todos los predicados deben ser inversibles, a menos que se indique lo contrario.    

Se pide desarrollar los predicados que permitan:    
Relacionar a un Pokemon con su tipo. (Dratini - dragón, Pikachu - eléctrico, etc.)
?- tipo(dratini,Tipo).
Tipo = dragon ;
false

Saber si un entrenador es groso. Un entrenador es groso cuando tiene al menos una pokebola grosa, y una pokebola es grosa si tiene un dragón o tiene un nivel superior a 65. (Lance y Ash son grosos)
?- entrenadorGroso(ash).
true


Relacionar un entrenador con su Pokemon favorito, que es aquel de la pokebola de mayor nivel. (Ash - Pikachu, Misty - Staryu, Brock - Onix, Lance - Dragonite)
?- pokemonFavorito(Entrenador,Pokemon).
Entrenador = ash
Pokemon = pikachu .
true

Relacionar a un entrenador con una de sus pokebolas si el Pokemon dentro de la misma puede evolucionar con ese entrenador. Un Pokemon puede evolucionar si:
llegó al nivel mínimo necesario para evolucionar, (Rattata y Charmander, de Ash, y Psyduck, de Misty)
el entrenador tiene el elemento para que evolucione (Pikachu, de Ash), o bien
es el favorito y la condición para evolucionar es de alegría (no hay ejemplo).
?- puedeEvolucionar(ash,Pokebola).
Pokebola = pokebola(pikachu, 70) ;
Pokebola = pokebola(rattata, 50) ;
Pokebola = pokebola(charmander, 60) ;
false


Saber si un pokemon es aburrido, que es aquel que no evoluciona ni evolucionó para llegar a lo que es (es el único en su cadena de evolución), o bien es de tipo normal. (Snorlax, Rattata, Raticate, Aerodactyl, Onix)
?- pokemonAburrido(snorlax).
	true .

Saber si a un Pokemon de una pokebola le conviene pelear con otro de otra pokebola. Al primero nunca le conviene pelear si el tipo del segundo es inmune contra su tipo. Además, debe cumplirse que el primero es inmune contra el tipo del segundo, o bien es fuerte contra ese tipo, o bien el segundo no es fuerte contra el tipo del primero y el primero tiene mayor nivel que el segundo. La relación es entre dos pokebolas y no requiere ser inversible para ninguno de sus parámetros.
(pokebola(pikachu, 70) - pokebola(psyduck, 34), por ejemplo, porque el eléctrico es fuerte contra el de agua, y también por la diferencia de nivel)
	?- leConvienePelear(pokebola(pikachu,70),pokebola(psyduck,34)).
	true .

Determinar si un entrenador tiene variedad, que es cuando tiene al menos 3 tipos distintos de Pokemon.
(Ash, porque tiene pokemon de 3 tipos (normal, eléctrico y fuego))
	?- tieneVariedad(ash).
	true.

Determinar si un entrenador es fanático de un tipo, que es cuando tiene más de un Pokemon y todos son de ese tipo. (Misty - agua)
?- entrenadorFanatico(Entrenador).
Entrenador = misty ;
false


/*
OPCIONAL (léase: “si está bien, suma... si está mal, no resta”)
Saber en qué Pokemon puede evolucionar otro dentro de una pokebola, por mérito propio. Lo único que se deberá tener en cuenta como necesario es el nivel, por los otras condiciones de evolución, siempre “podría” evolucionar.
La relación es entre 2 pokebolas y no necesita ser inversible para el primer parámetro.
(pokebola(rattata, 50) - pokebola(raticate, 50), 
pokebola(tyrogue, 22) - pokebola(hitmonchan, 22), 
pokebola(tyrogue, 22) - pokebola(hitmonlee, 22),
pokebola(gastly, 30) - pokebola(haunter, 30) / pokebola(gengar, 30)
etc.)
?- podriaSer(pokebola(gastly, 50), Pokebola). --> Pokebola = pokebola(haunter, 50) ; Pokebola =

pokebola(gengar, 50) ; false. (el primero por nivel suficiente, el segundo porque siempre puede)

?- podriaSer(pokebola(gastly, 14), Pokebola). --> false (no tiene nivel suficiente)

