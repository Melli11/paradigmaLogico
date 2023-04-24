vieneCon( p206 , abs ).
vieneCon( p206 , levantavidrios ).
vieneCon( p206 , direccionAsistida ).
vieneCon( kadisco , abs ).
vieneCon( kadisco , mp3 ).
vieneCon( kadisco , tacometro ).
quiere( carlos , abs ).
quiere( carlos , mp3 ).
quiere( roque , abs ).
quiere( roque , direccionAsistida ).


% agrego Autos
auto( p206 ).
auto( kadisco ).
persona( carlos ).
persona( roque ).

% En este caso debemos resolver si un auto le viene perfecto a una persona,
% donde le viene perfecto = tiene todas las características que la persona quiere.
% esto es lo que nos dan, pero el problema es que este predicado no es inversible.
leVienePerfecto( Auto , Persona ):-
    forall(quiere( Persona , Caracteristica ), vieneCon( Auto , Caracteristica)).
% esto es lo que nos dan, pero el problema es que este predicado no es inversible, porque necesito que tanto el auto como la persona lleguen ligadas al forall
leVienePerfecto( Auto , Persona ):-
    % vieneCon(Auto, _),
    % quiere(Persona, _),
    auto(Auto),
    persona(Persona),
    forall(quiere( Persona , Caracteristica ), vieneCon( Auto , Caracteristica)).