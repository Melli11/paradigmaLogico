% animal(Nombre, Clase, Medio).
animal(ballena, mamifero, acuatico).
animal(tiburon, pez, acuatico).
animal(lemur, mamifero, terrestre).
animal(golondrina, ave, aereo).
animal(tarantula, insecto, terrestre).
animal(lechuza, ave, aereo).
animal(orangutan, mamifero, terrestre).
animal(tucan, ave, aereo).
animal(puma, mamifero, terrestre).
animal(abeja, insecto, aereo).
animal(leon, mamifero, terrestre).
animal(lagartija, reptil, terrestre).

% tiene(Quien,Animal,Cuantos)
tiene(nico, ballena, 3).
tiene(nico, lemur, 2).
tiene(maiu, lemur, 1).
tiene(maiu, tarantula, 1).
tiene(maiu, tucan, 1).
tiene(maiu, leon, 2).
tiene(juanDS, golondrina, 1).
tiene(juanDS, lechuza, 1).
tiene(juanDS, puma, 1).
tiene(juanDS, lagartija, 1).
tiene(juanR, tiburon, 2).
tiene(nico, golondrina, 1).
tiene(juanR, orangutan, 1).
tiene(feche, tiburon, 1).

tiene(maxi,ballena,  1).
tiene(maxi,tiburon,  2).
tiene(maxi,lemur, 3).
tiene(maxi,golondrina, 2).
tiene(maxi,tarantula,2).
tiene(maxi,lechuza, 1).
tiene(maxi,orangutan, 2).
tiene(maxi,tucan, 1).
tiene(maxi,puma, 3).
tiene(maxi,abeja, 1).
tiene(maxi,leon, 2).
tiene(maxi,lagartija,10).


animalDificil(Animal):-  %es cierto que no existe ninguna persona que tenga a ese animal.
    animal(Animal,_,_),
    not(tiene(_,Animal,_)).

animalDificil(Animal):- %no existe otra persona que tenga mas de 1 de ese animal == como mucho hay una persona que tiene solo 1.
    tiene(Persona_1,Animal,1),
    not((tiene(Persona_2,Animal,_),Persona_1\=Persona_2)).



% Personas
leGusta_2(maiu,Animal):-
    animal(Animal,Clase,_),
    Clase \= insecto .

leGusta_2(maiu,abeja).

leGusta_2(nico,Animal):-
    animal(Animal,_,terrestre),
    not(animal(lemur,_,_)).


%leGusta(Persona,Animal)
leGusta(nico,Animal):- %a nico le gustan todos los animales terrestre excepto el lemur
    animal(Animal,_,terrestre),
    Animal \= lemur.




%a nico solo le gusta el Lemur, pero con not y complicada
% leGusta(nico,Animal):-
%     animal(Animal,_,terrestre),
%     not((animal(Animal,_,terrestre),Animal\= lemur)).

% Preguntar nico le gusta 


leGusta(maiu, Animal):-
    animal(Animal,_,_),
    not(animal(Animal,insecto,_)).

leGusta(maiu,abeja).

leGusta(juanDS,Animal):-
    animal(Animal,_,acuatico),
    animal(Animal,aves,_).

leGusta(juanR,Animal):-
    tiene(juanR,Animal,_).

leGusta(feche,lechuza).

tieneParaIntercambiar(Animal,Persona):- % aquellos que tiene la persona y no le gustan
    tiene(Persona,Animal,_),
    not(leGusta(Persona,Animal)).

tieneParaIntercambiar(Animal,Persona):- %  % aquellos que tiene la persona o que tenga mas de uno.
    tiene(Persona,Animal,Cantidad),
    Cantidad > 1.
    
tieneParaIntercambiar(Animal,juanR):-
    tiene(juanDS,Animal,_).

tieneParaOfrecerle(Persona_A,Persona_B):-
    tieneParaIntercambiar(Animal,Persona_A), %la primera persona tiene para intercambiar
    leGusta(Persona_B,Animal),
    not(tiene(Persona_B,Animal,_)).

puedenNegociar(Persona_A,Persona_B):-
    tieneParaOfrecerle(Persona_A,Persona_B),
    tieneParaOfrecerle(Persona_B,Persona_A).

% estaTriste(Persona):- % una persona está triste si de todos los animales que tiene, solo tiene animales que NO le gustan
%     tiene(Persona,_,_),
%     forall(tiene(Persona,Animal,_),not(leGusta(Persona,Animal))).

% equivalencia con not
estaTriste(Persona):- % una persona está triste si de todos los animales que tiene NO le gusta ninguno de los que tiene.
    tiene(Persona,_,_),
    not((tiene(Persona,Animal,_),(leGusta(Persona,Animal)))).


% diferencia con esta algoTriste: una persona está algo triste si tiene algun animal que no le gusta.

estaParcialmenteTriste(Persona):- % sea una persona que de todos los animales que tiene, hay algun animal que NO le gusta
    tiene(Persona,Animal,_),
    not(leGusta(Persona,Animal)).

% estaFeliz(Persona):-    %una persona está feliz si de todos los animales que tiene , le gustan todos ellos. 
%     tiene(Persona,_,_),
%     forall(tiene(Persona,Animal,_),leGusta(Persona,Animal)).

% equivalencia forall con not, la regla es escribir de manera identica los predicados y sus variables empleadas
                                % de manera que quede transformado a algo asi: not((p(x),not(q(x)))), es decir que hay que negar la misma expresión al principio
                                % y en el 2do argumento es decir en el consecuente.
estaFeliz(Persona):-  % esta feliz si NO tiene animales que NO le gustan.
    tiene(Persona,_,_),
    not((tiene(Persona,Animal,_),not(leGusta(Persona,Animal)))).

tieneTodosDe(Persona, ClaseOMedio):-
    tiene(Persona, _, _),
    esDeClaseOMedio(_, ClaseOMedio),
    forall(tiene(Persona, Animal, _), esDeClaseOMedio(Animal, ClaseOMedio)).

esDeClaseOMedio(Animal, Clase):-
    animal(Animal, Clase, _).
esDeClaseOMedio(Animal, Medio):-
    animal(Animal, _, Medio).


completoLaColeccion(Persona):-
    tiene(Persona,_,_),
    forall(animal(Animal, _, _ ),tiene(Persona,Animal,_)).

manejaElMercado(Persona_A):- %una persona maneja el mercado si del conjunto de los que tiene, a la vez tiene para ofrecerles a todos los demas
    tiene(Persona_A,_,_),
    forall(tiene(Persona_B,_,_),tieneParaOfrecerle(Persona_A,Persona_B)).

% manejaElMercado(Persona):-
%     tiene(Persona, _, _),
%     forall((tiene(OtraPersona, _, _), Persona \= OtraPersona),
%            tieneParaOfrecerle(Persona, OtraPersona)).

%una persona maneja el mercado si no existe nadie a quien no pueda ofrecerle

% manejaElMercado(Persona_A):-
% tiene(Persona_A,_,_),
% not((tiene(Persona_B,_,_),not(tieneParaOfrecerle(Persona_A,Persona_B)))).

% delQueMasTiene(Persona,Animal):-
%     tiene(Persona,Animal,Cantidad),
%     forall(tiene(Persona,Animal,Cantidad),,).

delQueMasTiene(Persona, Animal):-
    tiene(Persona, Animal, Cantidad), %defino el dominio, fijando el valor de una persona con una cierta cantidad de animales como referencia
    forall((tiene(Persona, OtroAnimal, Cantidad2), Animal \= OtroAnimal), % Se debe cumplir que para todo un conjunto de una persona que posea animales diferentes al valor fijado,
            Cantidad > Cantidad2).        %  esa persona no tenga una cantidad mayor a la cantidad de la persona de referencia 

%Es cierto que todos los animales que le gustan a juanR los tiene juanR?

leGustanTodosSiLosTiene(juanR):- % al no estar presente el generador  las consultas son existenciales
forall(leGusta(juanR,Animal),tiene(juanR,Animal,_)).

% Predicados auxiliares
% tiene(Quien,Animal,Cuantos)
%leGusta(Persona,Animal)

%Es cierto que todos los animales  le gustan a juanR ?
leGustanTodos(juanR):- % al no estar presente el generador  las consultas son existenciales
forall(animal(Animal,_,_),leGusta(juanR,Animal)).

% Predicados auxiliares
% animal(Animal, Clase, Medio).

%quien tiene todos sus animales del medio acuatico?

tieneTodosAcuaticos(Persona):-
    tiene(Persona,_,_),
    forall(tiene(Persona,Animal,_),animal(Animal, _ , acuatico)).

% Predicados auxiliares
% animal(Animal, Clase, Medio).
% tiene(Persona,Animal,Cuantos)

%quien colecciono todos los animales del medio acuatico?

coleccionoTodosLosAcuaticos(Persona):-
    tiene(Persona,_,_),
    forall(animal(Animal, _, acuatico ),tiene(Persona,Animal,_)).
