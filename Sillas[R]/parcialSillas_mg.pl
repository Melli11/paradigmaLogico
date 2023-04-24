
amigo(juan, alberto).
amigo(juan, pedro).
amigo(pedro,mirta).
amigo(alberto, tomas).
amigo(tomas,mirta).

enemigo(mirta,ana).
enemigo(juan,nestor).
enemigo(juan,mirta).


% mesaArmada(Evento,mesa(NumeroDeMesa,[Comensales]))
mesaArmada(navidad2010,mesa(1,[juan,mirta,ana,nestor])).
mesaArmada(navidad2010,mesa(5,[andres,german,ludmila,elias])).
mesaArmada(navidad2010,mesa(8,[nestor,pedro])).

%mesa inventada punto5
mesaArmada(reyes2023,mesa(9,[nestor,mirta])).


% Predicados Auxiliares

sonAmigos(Persona,Amigo):-	amigo(Persona,Amigo).
sonAmigos(Persona,Amigo):-	amigo(Amigo,Persona).

sonEnemigos(Persona,Amigo):-	enemigo(Persona,Amigo).
sonEnemigos(Persona,Amigo):-	enemigo(Amigo,Persona).

comensal(Persona):-
    mesaArmada(_,mesa(_,ListaDeComensales)),
    member(Persona,ListaDeComensales).

mesa(MesasDisponibles):-
    mesaArmada(_,MesasDisponibles).

persona(Persona):-distinct(comensal(Persona)).

evento(Evento):-
    mesaArmada(Evento,_).

fiesta(Fiesta):-distinct(evento(Fiesta)).

%Punto 1

estaSentadaEn(Persona,mesa(NumeroDeMesa,ListaDeComensales)):-
    mesaArmada(_,mesa(NumeroDeMesa,ListaDeComensales)),
    member(Persona,ListaDeComensales).
    

%Punto 2

sePuedeSentar(Persona,Mesa):-
    estaSentadaEn(Amigo,Mesa),
    amigo(Persona,Amigo),
    not(enemigo(Persona,_)).

%Punto 3
% crear mesa ideal
mesaDeCumpleaniero(Persona,mesa(1,GrupoCompleto)):-
    mejoresAmigos(Persona,GrupoCompleto).    

mejoresAmigos(Persona,GrupoCompleto):-
    amigosDe(Persona,ListaDeAmigos),
    append(ListaDeAmigos,[Persona],GrupoCompleto).
    
amigosDe(Persona,ListaDeAmigos):-
    persona(Persona),
    findall(Amigo,amigo(Persona,Amigo),ListaDeAmigos).

%Punto 4

incompatible(Persona,OtraPersona):-
    amigo(Persona,Fulano),
    enemigo(OtraPersona,Fulano).


%Punto 5
% estaSentadaEn(Persona,mesa(NumeroDeMesa,ListaDeComensales)): 
% persona(Persona).
% enemigo(juan,nestor).

laPeorOpcion(Persona,Mesa):-
    mesa(Mesa),
    forall(estaSentadaEn(Enemigo,Mesa),enemigo(Persona,Enemigo)).

%Punto 6

mesasPlanificadas(Fiesta,MesasReservadas):-
    fiesta(Fiesta),
    findall(Mesa,mesaArmada(Fiesta,Mesa),MesasReservadas).


%Punto 7
% mesaArmada(navidad2010,mesa(5,[andres,german,ludmila,elias])).
% enemigo(mirta,ana).

% esViable(ListaDeMesas):-
%     cumplenConElNumeroDeMesas(ListaDeMesas),
%     cumplenConLaCantidadDeComensales(ListaDeMesas),
%     noHayEnemigos(ListaDeMesas).


% cumplenConElNumeroDeMesas(ListaDeMesas):-
%     length(ListaDeMesas,Cantidad),
%     estaOrdenada(Lista,Cantidad).

% estaOrdenada(mesa(NumeroDeMesa,_) | _ ,Cantidad):-
%     NumeroDeMesa =< Cantidad.    


% cumplenConLaCantidadDeComensales([Mesa | _ ]):-
%     cantidadDeComensales(Mesa,Cantidad),
%     Cantidad = 4.

% cantidadDeComensales(Mesa,Cantidad):-
%     mesaArmada(_,mesa(_,ListaDeComensales)),
%     length(ListaDeComensales,Cantidad).
    
% noHayEnemigos([Mesa | _ ]):-
%     estaSentadaEn(Persona,Mesa),
%     estaSentadaEn(OtraPersona,Mesa),
%     not(enemigo(Persona,OtraPersona)).
    
    %   

% sePuedeSentar(Persona,Mesa):-
%     estaSentadaEn(Amigo,Mesa),
%     amigo(Persona,Amigo),
%     not(enemigo(Persona,_)).

:-begin_tests(punto1).
test(punto1_estaSentadaEn,nondet):-

estaSentadaEn(juan,mesa(1,[juan,mirta,ana,nestor])),
estaSentadaEn(mirta,mesa(1,[juan,mirta,ana,nestor])),
estaSentadaEn(nestor,mesa(1,[juan,mirta,ana,nestor])),
estaSentadaEn(nestor,mesa(8,[nestor,pedro])),
not(estaSentadaEn(mirta,mesa(8,[nestor,pedro]))).

end_tests(punto1).


:-begin_tests(punto2).
test(punto2_sePuedeSentar,nondet):-

sePuedeSentar(pedro,mesa(1,[juan,mirta,ana,nestor])), %%porque esta sentado su amigo(mirta) y no tiene enemigos.
not(sePuedeSentar(juan,mesa(1,[juan,mirta,ana,nestor]))). %%porque no hay ningun amigo sentado.


end_tests(punto2).


:-begin_tests(punto3).

test(punto3_mesaDeCumpleaniero,nondet):-

mesaDeCumpleaniero(juan,mesa(1,[alberto,pedro,juan])).

end_tests(punto3).

:-begin_tests(punto4).

test(punto4_incompatible,nondet):-

incompatible(pedro,juan), %%porque pedro es amigo de mirta, y juan es enemigo de mirta
incompatible(tomas,juan). %%porque tomas es amigo de mirta, y juan es enemigo de mirta.

end_tests(punto4).


:-begin_tests(punto5).

test(punto5_laPeorOpcion,nondet):-
laPeorOpcion(juan,mesa(9,[nestor,mirta])).

end_tests(punto5).


:-begin_tests(punto6).

test(punto6_mesasPlanificadas,nondet):-
    mesasPlanificadas(navidad2010,[mesa(1, [juan, mirta, ana, nestor]), mesa(5, [andres, german, ludmila, elias]), mesa(8, [nestor, pedro])]).

end_tests(punto6).


