% Punto 1: Empleados
% a) Base de conocimiento
contador(roque).
honesto(roque).
honesto(ana).
ambicioso(roque).
ingeniera(ana).
abogada(cecilia).
trabajoAntes(cecilia,utn).
trabajoAntes(roque,utn).

% b) Predicado puedeAndar/2

puedeAndar(contaduria,Empleado):-
    honesto(Empleado).

puedeAndar(ventas,Empleado):-
    ambicioso(Empleado),
    conExperiencia(Empleado).

puedeAndar(ventas,lucia).

conExperiencia(Empleado):-
    trabajoAntes(Empleado,_).

:- begin_tests(tp1_a).

test(un_contador_honesto_puede_trabajar_en_contaduria, nondet):-
        puedeAndar(contaduria,roque),
        puedeAndar(contaduria,ana).

test(una_persona_no_declarada_como_honesta_no_puede_trabajar_en_contaduria):-
        \+ puedeAndar(contaduria,cecilia).

test(los_que_pueden_trabajar_en_ventas):-
        puedeAndar(ventas,roque),
        puedeAndar(ventas,lucia).

test(si_tiene_experiencia_es_porque_trabajo_anteriormente):-
        conExperiencia(roque),
        conExperiencia(cecilia).

:- end_tests(tp1_a).

% Punto 2: Asesinato de Tia Agatha

viveEn(mansion,agatha).
viveEn(mansion,carnicero).
viveEn(mansion,charles).


odia(agatha,Alguien):-
    viveEn(mansion,Alguien),
    Alguien \= carnicero.

odia(charles,Alguien):-
    viveEn(mansion,Alguien),
    not(odia(agatha,Alguien)).

odia(carnicero,Alguien):-
    odia(agatha,Alguien).

esMasRico(Alguien,agatha):-
    viveEn(mansion,Alguien),
    not(odia(carnicero,Alguien)).

asesino(agatha,Asesino):-
    viveEn(mansion,Asesino),
    odia(Asesino,agatha),
    not(esMasRico(Asesino,agatha)).

:- begin_tests(tp1_b).

test(los_odiados_por_agatha):-
    odia(agatha,agatha),
    odia(agatha,charles).

test(los_odiados_por_charles):-
    odia(charles,carnicero).

test(los_odiados_por_el_carnicero):-
    odia(carnicero,agatha),
    odia(carnicero,charles).

test(el_mas_rico_que_agatha):-
    esMasRico(carnicero,agatha).

test(el_asesino_de_agatha):-
    asesino(agatha,agatha).

:- end_tests(tp1_b).
