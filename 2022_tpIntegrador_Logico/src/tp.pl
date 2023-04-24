
% Punto 1

% Predicados justificacion

% El predicado persona lo utilizo para modelar la existencia de las personas del planeta. 
% El predicado profesion representa aquello en lo que trabaja o desea trabajar
% El predicado habilidades representan en qué son buenos.
% El predicado hobbies son aquellas actividades que le gustan a la persona.

persona(bakunin).
persona(ravachol).
persona(rosaDubovsky).
persona(emmaGoldman).
persona(judithButler).
persona(elisaBachofen).
persona(juanSuriano).
persona(sebastienFaure).

% Profesion
% profesion(Persona,Profesion)
profesion(bakunin,aviacion_militar).
profesion(ravachol,inteligencia_militar).
profesion(rosaDubovsky,recolector_de_basura).
profesion(rosaDubovsky,asesina).
profesion(emmaGoldman,profesora_de_judo).
profesion(emmaGoldman,cineasta).
profesion(judithButler,profesora_de_judo).
profesion(judithButler,inteligencia_militar).
profesion(elisaBachofen,ingeniera_mecanica). %trabajan en un lugar

% Habilidades
% esBuenoEn(Persona,Actividad)
esBuenoEn(bakunin,conductor).
esBuenoEn(ravachol,tiro_al_blanco).
esBuenoEn(rosaDubovsky,construir_puentes).
esBuenoEn(rosaDubovsky,mirar_Peppa_Pig).
esBuenoEn(emmaGoldman,Habilidad):-
    esBuenoEn(judithButler,Habilidad).

esBuenoEn(emmaGoldman,Habilidad):-
    esBuenoEn(elisaBachofen,Habilidad).

esBuenoEn(judithButler,judo).
esBuenoEn(elisaBachofen,armar_bombas).
esBuenoEn(juanSuriano,Habilidad):-
    leGusta(juanSuriano,Habilidad).

%Hobbies
leGusta(ravachol,juegos_de_azar). 
leGusta(ravachol,ajedrez). 
leGusta(ravachol,tiro_al_blanco). 
leGusta(rosaDubovsky,construir_puentes).
leGusta(rosaDubovsky,mirar_Peppa_Pig).
leGusta(rosaDubovsky,fisica_cuantica).

leGusta(emmaGoldman,Gustos):-
    leGusta(judithButler,Gustos).

leGusta(judithButler,judo).
leGusta(judithButler,automovilismo).
leGusta(juanSuriano,judo). %es experto en judo
leGusta(juanSuriano,armar_bombas). %es experto
leGusta(juanSuriano,ring_range). %es experto
leGusta(elisaBachofen,fuego).
leGusta(elisaBachofen,destruccion).


%HistorialCriminal

historialCriminal(bakunin,robo_aeronaves).
historialCriminal(bakunin,fraude).
historialCriminal(bakunin,tenencia_cafeina).
historialCriminal(judithButler,falsificacion_cheques).
historialCriminal(judithButler,fraude).
historialCriminal(ravachol,falsificacion_de_vacunas).
historialCriminal(ravachol,fraude).
historialCriminal(juanSuriano,falsificacion_de_dinero).
historialCriminal(juanSuriano,fraude).


% Punto 2: Viviendas

%vivienda: Representa el conjunto de las viviendas
vivienda(la_severino).
vivienda(comisaria_48).
vivienda(casa_de_papel).
vivienda(casa_de_sol_naciente).
vivienda(casa_de_patricia).


% viveEn("NombreDeLaVivienda","Ocupantes"): viveEn relaciona las viviendas con sus ocupantes
viveEn(la_severino,bakunin).
viveEn(la_severino,elisaBachofen).
viveEn(la_severino,rosaDubovsky).
viveEn(comisaria_48,ravachol).
viveEn(casa_de_papel,emmaGoldman).
viveEn(casa_de_papel,juanSuriano).
viveEn(casa_de_papel,judithButler).
viveEn(casa_de_patricia,sebastienFaure).

% pasadizo(NombreDeVivienda,CantidadDePasadizos)
pasadizo(la_severino,1).
pasadizo(casa_de_papel,2).
pasadizo(casa_de_sol_naciente,1).
pasadizo(comisaria_48,0).
pasadizo(casa_de_patricia,1).

% cuartoSecreto(NombreDeVivienda,Largo,Ancho)
cuartoSecreto(la_severino,4,8).
cuartoSecreto(casa_de_papel,5,3).
cuartoSecreto(casa_de_papel,4,7).


% tunelSecreto(NombreDeVivienda,Longitud,EstadoDeConstruccion).
tunelSecreto(la_severino,8,finalizado).
tunelSecreto(la_severino,5,finalizado).
tunelSecreto(la_severino,1,en_construccion).
tunelSecreto(casa_de_papel,9,finalizado).
tunelSecreto(casa_de_papel,2,finalizado).
tunelSecreto(casa_de_sol_naciente,3,sin_construir).

% bunkers("NombreDeVivienda",perimetro,superficie_interna).
bunkers(casa_de_patricia,2,10).


%Punto 3: Guaridas rebeldes
viviendasConPotencialRebelde(Vivienda):-
    viveEn(Vivienda,Persona_Disidente),
    esDisidente(Persona_Disidente),
    superficieDeVivienda(Vivienda,Area),
    Area > 50.

superficieDeVivienda(Vivienda,Area):-
    vivienda(Vivienda),
    superficieCuartos(Vivienda,Total_Cuartos), %% predicado auxiliar para calcular m2 de los cuartos
    superficieTuneles(Vivienda,Total_Tuneles),%% predicado auxiliar para calcular m2 de los tuneles
    superficiePasadizo(Vivienda,Total_Pasadizo),
    superficieBunkers(Vivienda,Total_Bunkers),
    Area is Total_Cuartos + Total_Tuneles + Total_Pasadizo + Total_Bunkers.


%Predicados Auxiliares para hallar superficies 

superficieCuartos(Vivienda,Metros):-
    vivienda(Vivienda),
    findall(Largo,cuartoSecreto(Vivienda,Largo,Ancho),Largos),
    findall(Ancho,cuartoSecreto(Vivienda,Largo,Ancho),Anchos),
    sum_list(Largos,Largo_Total),
    sum_list(Anchos, Ancho_Total),
    Metros is Largo_Total * Ancho_Total.


superficieTuneles(Vivienda,Metros):-
    vivienda(Vivienda),
    findall(Longitud,tunelSecreto(Vivienda,Longitud,finalizado),Longitudes),
    sum_list(Longitudes,Longitud_Total),
    Metros is Longitud_Total * 2 .

superficiePasadizo(Vivienda,Metros):- pasadizo(Vivienda,Metros).

superficieBunkers(Vivienda,Metros):-
    vivienda(Vivienda),
    findall(Superficie_Interna,bunkers(Vivienda,Superficie_Interna,Perimetro_Acceso), Sup_Internas),
    findall(Perimetro_Acceso,bunkers(Vivienda,Superficie_Interna,Perimetro_Acceso), Per_Accesos),
    sum_list(Sup_Internas,Sup_Internas_Total),
    sum_list(Per_Accesos,Per_Accesos_Total),
    Metros is Sup_Internas_Total + Per_Accesos_Total.


% Punto 4: Aquí no hay quien viva

% 4a)Detectar si en una vivienda no vive nadie.

estaDesocupada(Vivienda):-
    vivienda(Vivienda),
    not(viveEn(Vivienda,_)).

% 4b) Detectar si en una vivienda todos los que viven tienen al menos un gusto en común

tienenGustosEnComun(Vivienda):-
    leGusta(_,Gusto),
    forall(viveEn(Vivienda,Habitante),leGusta(Habitante,Gusto)).

%del conjunto de partida formado por los pares "vivienda-habitante" que representa todas las personas que viven en una vivienda,
% donde la variable libre es Habitante y la condicion será principalmente el gusto.



% Punto 5: Rebelde
% Una persona se considera posible disidente si cumple todos estos requisitos

% 5.1    Tener una habilidad en algo considerado terrorista. Se considera terrorista armar
% bombas, tirar al blanco o mirar Peppa Pig.

esDisidente(UnaPersona):-
    esPotencialTerrorista(UnaPersona), % poseen habilidades consideradas como terroristas
    esAntipatico(UnaPersona), %no tiene gustos registrados o le gusta todo en lo que es bueno.
    esPotencialCriminal(UnaPersona). %tienen más de un registro en su historial criminal o viven junto con alguien que sí lo tiene

esPotencialTerrorista(UnaPersona):-
    esBuenoEn(UnaPersona,armar_bombas).

esPotencialTerrorista(UnaPersona):-
    esBuenoEn(UnaPersona,tiro_al_blanco).

esPotencialTerrorista(UnaPersona):-
    esBuenoEn(UnaPersona,mirar_Peppa_Pig).
 

% 5.2 No tener gustos registrados en el sistema o que le guste todo en lo que es bueno.

esAntipatico(UnaPersona):-
    noTieneGustosRegistrados(UnaPersona).

esAntipatico(UnaPersona):-
    leGustaTodoEnLoQueEsBueno(UnaPersona).

noTieneGustosRegistrados(UnaPersona):-
    persona(UnaPersona),
    not(leGusta(UnaPersona,_)).

leGustaTodoEnLoQueEsBueno(UnaPersona):-
    persona(UnaPersona),
    forall(esBuenoEn(UnaPersona,Actividades),leGusta(UnaPersona,Actividades)).

% 5.3 Tener más de un registro en su historial criminal o vivir junto con alguien que sí lo tenga.

esPotencialCriminal(UnaPersona):-
    tieneAntecedentes(UnaPersona).

esPotencialCriminal(UnaPersona):-
    viveConUnCriminal(UnaPersona).


tieneAntecedentes(UnaPersona):-
    historialCriminal(UnaPersona,_).

viveConUnCriminal(UnaPersona):-
    viveEn(Casa,UnaPersona),
    viveEn(Casa,OtraPersona),
    UnaPersona \= OtraPersona.

% Punto 7: Batallón de rebeldes

batallonDeRebeldes(Personas):-
    persona(UnaPersona),
    not(tieneMasDeUnAntecedente(UnaPersona)).

batallonDeRebeldes(Personas):-
    persona(UnaPersona),
    not(viveConUnCriminal(UnaPersona)).


% Restricciones

% las personas tienen que tener más de un registro en su historial criminal o vivir junto con alguien que sí lo tenga

tieneMasDeUnAntecedente(UnaPersona):-
    persona(UnaPersona),
    findall(Antecedente,historialCriminal(UnaPersona,Antecedente),Listado_Antecendentes),
    length(Listado_Antecendentes,Total_De_Entradas),
    Total_De_Entradas > 1.




% tienen que sumar en total más de 3 habilidades (esto es, incluyendo todas las
% habilidades de las personas que conformen el batallón).

tieneMasDe3Habilidades(UnaPersona):-
    persona(UnaPersona),
    findall(Habilidad,esBuenoEn(UnaPersona,Habilidad),Habilidades),
    length(Habilidades,Total_Habilidades),
    Total_Habilidades > 3.


:- begin_tests(tp).

test(punto1_las_habilidades_de_emma_goldman,nondet):-
    esBuenoEn(emmaGoldman,armar_bombas),
    esBuenoEn(emmaGoldman,judo).

test(punto1_los_gustos_de_emma_goldman,nondet):-
    leGusta(emmaGoldman,automovilismo),
    leGusta(emmaGoldman,judo).

test(punto3a_superficie_actividades_clandestina,nondet):-
    superficieDeVivienda(la_severino,59),
    superficieDeVivienda(comisaria_48,0).

test(punto3b_tienen_Potencial_Rebelde,nondet):-
    viviendasConPotencialRebelde(la_severino),
    viviendasConPotencialRebelde(casa_de_papel).

test(punto4a_aqui_no_hay_quien_viva):-
    estaDesocupada(casa_de_sol_naciente).

test(punto4b_casa_con_gustos_en_comun,nondet):-
    tienenGustosEnComun(casa_de_papel),
    tienenGustosEnComun(comisaria_48).

test(punto5a_son_potenciales_terroristas,nondet):-
    esPotencialTerrorista(elisaBachofen),
    esPotencialTerrorista(juanSuriano),
    esPotencialTerrorista(emmaGoldman),
    esPotencialTerrorista(ravachol),
    esPotencialTerrorista(rosaDubovsky).
    
test(punto5b_punto_los_insipidos,nondet):-
    esAntipatico(bakunin),
    esAntipatico(juanSuriano),
    esAntipatico(judithButler),
    esAntipatico(ravachol),
    esAntipatico(rosaDubovsky),
    esAntipatico(sebastienFaure).

:- end_tests(tp).
