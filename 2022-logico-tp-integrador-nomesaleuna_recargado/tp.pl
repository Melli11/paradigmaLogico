:- use_module(begin_tests_con).

persona(bakunin).
trabajo(bakunin, aviacionMil).
habilidad(bakunin, conducirAutos).
antecedenteCriminal(bakunin, roboAN).
antecedenteCriminal(bakunin, fraude).
antecedenteCriminal(bakunin, tenenciaCafeina).

persona(ravachol).
trabajo(ravachol, inteligenciaMil).
habilidad(ravachol, tiroAlBlanco).
gusto(ravachol, tiroAlBlanco).
gusto(ravachol, ajedrez).
gusto(ravachol, juegosDeAzar).
antecedenteCriminal(ravachol, falsificacionVacunas).
antecedenteCriminal(ravachol, fraude).

persona(rosaDubovsky).
aspiracion(rosaDubovsky, recolectorDeBasura).
aspiracion(rosaDubovsky, asesinoASueldo).
habilidad(rosaDubovsky, construirPuentes).
habilidad(rosaDubovsky, mirarPeppa).
gusto(rosaDubovsky, mirarPeppa).
gusto(rosaDubovsky, construirPuentes).
gusto(rosaDubovsky, fisicaCuantica).

persona(judithButler).
trabajo(judithButler, profesoraJudo).
trabajo(judithButler, inteligenciaMil).
habilidad(judithButler, judo).
habilidad(judithButler, carrerasAutomovilismo).
gusto(judithButler, judo).
gusto(judithButler, carrerasAutomovilismo).
antecedenteCriminal(judithButler, fraude).
antecedenteCriminal(judithButler, falsificacionCheque).

persona(elisaBachofen).
trabajo(elisaBachofen, ingenieraMecanica).
gusto(elisaBachofen, fuego).
gusto(elisaBachofen, destruccion).
habilidad(elisaBachofen, armarBombas).

trabajo(juanSuriano, Trabajo).
gusto(juanSuriano, judo).
gusto(juanSuriano, armarBombas).
gusto(juanSuriano, ringRaje).
habilidad(juanSuriano, judo).
habilidad(juanSuriano, armarBombas).
habilidad(juanSuriano, ringRaje).

persona(emmaGoldman).
trabajo(emmaGoldman, profesoraJudo).
trabajo(emmaGoldman, cineasta).
habilidad(emmaGoldman, Habilidad):-
    habilidad(judithButler, Habilidad).

habilidad(emmaGoldman, Habilidad):-
    habilidad(elisaBachofen, Habilidad).

gusto(emmaGoldman, Gusto):-
    gusto(judithButler, Gusto).

persona(sebastienFaure).

vivienda(laSeverino, [cuarto(4, 8), pasadizo, tunel(8), tunel(5), tunel(1)]).
viveEn(laSeverino, bakunin).
viveEn(laSeverino, elisaBachofen).
viveEn(laSeverino, rosaDubovsky).

vivienda(comisaria48, []).
viveEn(comisaria48, ravachol).

vivienda(casaDePapel, [cuarto(3,5), cuarto(4,7), tunel(9), tunel(2)]).
viveEn(casaDePapel, emmaGoldman).
viveEn(casaDePapel, juanSuriano).
viveEn(casaDePapel, judithButler).

vivienda(casaDelSolNaciente, [tunelEnConstruccion(3)]).

metrosCuadrados(cuarto(Largo, Ancho), Metros):-
    Metros is Largo*Ancho.

metrosCuadrados(tunel(Largo), Metros):-
    Metros is Largo*2.

metrosCuadrados(pasadizo, Metros):-
    Metros = 1.

metrosCuadrados(tunelEnConstruccion(Largo), Metros):-
    Metros = 0.

metrosCuadrados(bunker(Superficie, Perimetro), Metros):-
    Metros is Superficie+Perimetro.


viveNadie(Vivienda):-
    not(viveEn(Vivienda, _)).

mismoGustosHabitantes(Vivienda):-
    gusto(_, Gusto),
    forall(viveEn(Vivienda, Persona), gusto(Persona, Gusto)).


habilidadTerrorista(Persona):-
    habilidad(Persona, armarBombas).


habilidadTerrorista(Persona):-
    habilidad(Persona, tiroAlBlanco).


habilidadTerrorista(Persona):-
    habilidad(Persona, mirarPeppa).

gustoRebelde(Persona):-
    not(gusto(Persona, _)).

gustoRebelde(Persona):-
    forall(habilidad(Persona, Habilidad), gusto(Persona, Habilidad)).

masDeUnAntecedente(Persona):-
    findall(Antecedente, antecedenteCriminal(Persona, Antecedente), Antecedentes),
    length(Antecedentes, Num),
    Num > 1.

historiaRebelde(Persona):-
    masDeUnAntecedente(Persona).

historiaRebelde(Persona):-
    viveEn(Vivienda, Persona),
    viveEn(Vivienda, OtraPersona),
    masDeUnAntecedente(OtraPersona).

posibleRebelde(Persona):-
    habilidadTerrorista(Persona),
    gustoRebelde(Persona),
    historiaRebelde(Persona).

superficieClandestina(Vivienda, Superficie):-
    vivienda(Vivienda, ListaAmbientes),
    findall(Metros, (member(ListaAmbientes, Ambientes), metrosCuadrados(Ambientes, Metros)), ListaMetros),
    sumlist(ListaMetros, Superficie).
    
guaridaRebelde(Vivienda):-
    viveEn(Vivienda, Persona),
    superficieClandestina(Vivienda, Superficie),
    Superficie>50.
    
% para agregar bunkers se suman dos parametros mas al predicado vivienda, siendo dos listas que representan superficies y perimetros de bunkeres



vivienda(casaDePatricia, [pasadizo, bunker(10,2)]).
viveEn(casaDePatricia, sebastienFaure).



cantidadDeHabilidades(Persona, Cantidad):-
persona(Persona),
    findall(Habilidad, habilidad(Persona, Habilidad), Habilidades),
    length(Habilidades, Cantidad).
    

% historiaRebeldeBool(Persona, Bool):-
%     historiaRebelde(Persona),
%     Bool = 0.

% historiaRebeldeBool(Persona, Bool):-
%     not(historiaRebelde(Persona)),
%     Bool = 1.

% batallon(Batallon):-
%     maplist(cantidadDeHabilidades, Batallon, ListaHabilidades),
%     sumlist(ListaHabilidades, Suma),
%     Suma > 3.
%     maplist(historiaRebeldeBool, Batallon, ListaHistoria),
%     sumlist(ListaHistoria, Suma1),
%     Suma1 = 0.
combs([],[]).

combs([_|T],T2) :-
    combs(T,T2).
combs([H|T],[H|T2]) :-
    combs(T,T2).


batallon(Batallon):-
    findall(Persona, persona(Persona), Personas),
    combs(Personas, Batallon),
    forall(member(Persona, Batallon), historiaRebelde(Persona)),
    findall(Habilidad, (member(Persona, Batallon), habilidad(Persona, Habilidad)), Habilidades),
    length(Habilidades, Len),
    Len > 3.
    


    


findall(Persona, persona(Persona), Personas)



:- begin_tests_con(tpIntegrador, []).

% punto 1
test(habilidades_de_emma_goldman_son_armar_bombas_y_judo):-
    habilidad(emmaGoldman, judo),
    habilidad(emmaGoldman, armarBombas).

test(gustos_de_emma_goldman_son_carreras_automovilisticas_y_judo):-
    gusto(emmaGoldman, judo),
    gusto(emmaGoldman, carrerasAutomovilismo).

%Punto 4

test(no_vive_nadie_en_casa_del_sol_naciente):-
    viveNadie(casaDelSolNaciente).

test(en_la_casa_de_papel_y_en_la_comisaria_48_todas_las_personas_tienen_un_gusto_en_comun):-
    mismoGustosHabitantes(casaDePapel),
    mismoGustosHabitantes(comisaria48).

% Punto 5

test(estas_personas_tienen_habilidades_terroristas):-
    habilidadTerrorista(elisaBachofen),
    habilidadTerrorista(emmaGoldman),
    habilidadTerrorista(ravachol),
    habilidadTerrorista(rosaDubovsky).

test(estas_personas_no_tienen_gustos_registrados_o_les_gusta_todo_lo_que_son_buenos):-
    gustoRebelde(bakunin),
    gustoRebelde(juanSuriano),
    gustoRebelde(judithButler),
    gustoRebelde(ravachol),
    gustoRebelde(rosaDubovsky),
    gustoRebelde(sebastienFaure).

test(estas_personas_tienen_mas_de_un_antecedente_criminal_o_viven_con_una_persona_que_tenga):-
    historiaRebelde(bakunin),
    historiaRebelde(elisaBachofen),
    historiaRebelde(emmaGoldman),
    historiaRebelde(juanSuriano),
    historiaRebelde(judithButler),
    historiaRebelde(ravachol),
    historiaRebelde(rosaDubovsky).

test(son_posibles_disidentes):-
    posibleRebelde(rosaDubovsky),
    posibleRebelde(juanSuriano),
    posibleRebelde(ravachol).

% punto 3

test(la_superficie_destinada_a_actividades_clandestinas_de_la_severino_es_59):-
    superficieClandestina(laSeverino, SuperficieClandestina),
    SuperficieClandestina = 59.

test(la_superficie_destinada_a_actividades_clandestinas_de_la_comisaria_48_es_0):-
    superficieClandestina(comisaria48, SuperficieClandestina),
    SuperficieClandestina = 0.

test(tanto_la_casa_de_papel_como_la_severino_tienen_potencial_rebelde):-
    guaridaRebelde(laSeverino),
    guaridaRebelde(casaDePapel).
% 
%punto 6 

test(la_superficie_clandestina_de_la_casa_de_patricia_tiene_que_ser_13):-
    superficieClandestina(casaDePatricia, Superficie),
    Superficie = 13.


%Punto 7

test(juanSuriano_y_ravachol_son_un_batallon_valido):-
    batallon([juanSuriano, ravachol]).

:- end_tests(tpIntegrador).
