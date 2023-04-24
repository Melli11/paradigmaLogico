%Base de conocimiento: 
% Registro de dragones

% dragon(Nombre_Dragon,Tamanio,Tamanio_Alas,Cantidad_Disparos,Habilidad_Especial)

dragon(charizard_fuego,10,20,15,escupir_fuego).
dragon(chimuelo_acido,1,5,5,escupir_acido).
dragon(diosDragon_acido,999,999,999,escupir_acido).
dragon(dragonDeMetal,9900,9900,9900,cuerpo_de_metal).
dragon(drogon_termico,200,25,75,resistencia_termica).
dragon(drogon_jr_termico,200,50,99,resistencia_termica).
dragon(rhaegal_fuego,200,50,99,escupir_fuego).
dragon(shenLong_levitar,70,0,2,levitar).
dragon(smaug_camuflaje,500,100,25,camuflaje).
dragon(spyro_levitar,5,5,0,levitar).
dragon(dragonVolador,9999,9999,99999,levitar).
dragon(viserion_hielo,200,50,99,lanzar_hielo).


%Registro de las habilidades conocidas y su poder

habilidadEspecial(escupir_acido,20).
habilidadEspecial(cuerpo_de_metal,15).
habilidadEspecial(levitar, 0).
habilidadEspecial(escupir_fuego, 30).
habilidadEspecial(camuflaje, 25).
habilidadEspecial(lanzar_hielo, 40).
habilidadEspecial(resistencia_termica, 30).

%Peligrosidad de un Dragon
% La peligrosidad de un drágon 
% se cálcula como el Tamanio + el poder de la habilidad especial + 3 * la cantidad de disparos.

peligrosidad(Nombre_Dragon,Peligrosidad):-
    dragon(Nombre_Dragon,Tamanio,_,Cantidad_Disparos,Habilidad_Especial),
    habilidadEspecial(Habilidad_Especial,Poder),
    Peligrosidad is Tamanio + Poder + 3 * Cantidad_Disparos.

%Categoria de un Dragon

% Si la peligrosidad es entre 0 y 50 es inofensivo. 
categoria(Nombre_Dragon,inofensivo):-
    peligrosidad(Nombre_Dragon,Peligrosidad),
    Peligrosidad  > 0,
    Peligrosidad  =< 50.

% Si es entre 51 y 100 es amenazante.
categoria(Nombre_Dragon,amenazante):-
    peligrosidad(Nombre_Dragon,Peligrosidad),
    Peligrosidad  > 51,
    Peligrosidad  =< 100.

%  Si es mayor a 100 es peligroso.
categoria(Nombre_Dragon,peligroso):-
    peligrosidad(Nombre_Dragon,Peligrosidad),
    Peligrosidad  > 100.

% puede volar?
% Queremos saber a su vez si un drágon vuela, que se cumple si el tamaño 
% de sus alas es mayor a la mitad del tamaño del drágon o si posee la habilidad levitar.

% dragon(Nombre_Dragon,Tamanio,Tamanio_Alas,Cantidad_Disparos,Habilidad_Especial)
tamanioAlasEsMayorALaMitadDelTamanio(Dragon):-
    dragon(Dragon,Tamanio,Tamanio_Alas,_,_),
    Tamanio_Alas > Tamanio / 2.

puedeVolar(Dragon):-
    dragon(Dragon,_,_,_,_),
    tamanioAlasEsMayorALaMitadDelTamanio(Dragon).

puedeVolar(Dragon):-
    dragon(Dragon,_,_,_,levitar).

% más peligrosos.
% Un drágon es más peligroso si tiene mayor nivel de peligrosidad.
masPeligroso(DragonMasPeligroso,OtroDragon):-
    peligrosidad(DragonMasPeligroso,Peligro_Dragon_Poderoso),
    peligrosidad(OtroDragon,Peligro_Otro_Dragon),
    DragonMasPeligroso \= OtroDragon,
    Peligro_Dragon_Poderoso > Peligro_Otro_Dragon.

% el más peligroso.
elMasPeligrosoDeTodos(UnDragon):- % es verdad que no existe otro dragon mas peligroso que UnDragon
    dragon(UnDragon,_,_,_,_),
    not(masPeligroso(_,UnDragon)).
% Queremos saber cual es el drágon más peligroso que se cumple si no existe otro más peligroso que él.

% rivales
% 2 drágones son rivales si tienen la misma categoria y la misma habilidad especial.

sonRivales(Dragon_A,Dragon_B):-
    dragon(Dragon_A,_,_,_,Misma_Habilidad),
    dragon(Dragon_B,_,_,_,Misma_Habilidad),
    categoria(Dragon_A,Misma_Categoria),
    categoria(Dragon_B,Misma_Categoria),
    Dragon_A \= Dragon_B.

% se puede defender
% Un drágon se puede defender de otro si su habilidad sirve para defenderse contra la del otro:

sePuedeDefender(UnDragon,OtroDragon):-
    dragon(UnDragon,_,_,_,UnaHabilidad),
    dragon(OtroDragon,_,_,_,OtraHabiidad),
    UnDragon \= OtroDragon,
    sirveParaDefenderse(UnaHabilidad,OtraHabiidad).

%sirveParaDefenderse: Es un predicado auxiliar para validar la eficacia de una habilidad vs otra.
% Por el principio de universo cerrado solo considero  las habilidades que prevalecen por 
% sobre otra habilidad.

sirveParaDefenderse(cuerpo_de_metal,escupir_acido).
sirveParaDefenderse(resistencia_termica,escupir_fuego).
sirveParaDefenderse(resistencia_termica,lanzar_hielo).
sirveParaDefenderse(lanzar_hielo,escupir_fuego).
sirveParaDefenderse(escupir_fuego,lanzar_hielo).

sirveParaDefenderse(camuflaje,OtraHabilidad):-
    habilidadEspecial(OtraHabilidad,_).

% Cuerpo de metal sirve contra escupir acido.
% Escupir acido no sirve contra el hielo.
% Resistencia termica sirve contra fuego y hielo.
% El fuego no sirve contra la resistencia termica ni el metal.
% El hielo sirve contra el fuego y viceversa.
% Y el camuflaje sirve contra cualquier otra.

% presas faciles
% Queremos saber finalmente si un drágon es presa facil de otro que se cumple 
% si su peligrosidad es menor y a su vez no se puede defender o si no puede volar.


esPresaFacil(UnDragon,OtroDragon):-
    dragon(UnDragon,_,_,_,_),
    dragon(OtroDragon,_,_,_,_),
    masPeligroso(OtroDragon,UnDragon),
    not(sePuedeDefender(UnDragon,OtroDragon)),
    OtroDragon \= UnDragon.

esPresaFacil(UnDragon,OtroDragon):-
    dragon(UnDragon,_,_,_,_),
    dragon(OtroDragon,_,_,_,_),
    not(puedeVolar(UnDragon)),
    OtroDragon \= UnDragon.

% Ejemplos para probar presaFacil: 

% DragonDeMetal es el dragon mas peligroso de todos los dragones (39615), por lo tanto no es presa facil de nadie.

% 9 ?- esPresaFacil(dragonDeMetal,Q).
% false.

%ShenLong y Spyro son los unicos dragones que pueden levitar, por lo tanto tampoco son presa facil de otro dragon.

% 10 ?- esPresaFacil(shenLong_levitar,_).
% false.

% 11 ?- esPresaFacil(spyro_levitar,_).    
% false.

%


:-  begin_tests(tp2).
test(la_peligrosidad_de_chimi_es_36,nondet):-
        peligrosidad(chimuelo_acido,36).
test(la_peligrosidad_de_smaug_es_600,nondet):-
        peligrosidad(smaug_camuflaje,600).
test(un_dragon_es_inofensivo_si_su_peligrosidad_esta_entre_0_y_50,nondet):-
        categoria(chimuelo_acido,inofensivo),
        categoria(spyro_levitar,inofensivo).
test(un_dragon_es_amenazante_si_su_peligrosidad_esta_entre_51_y_1000,nondet):-
        categoria(charizard_fuego,amenazante),
        categoria(shenLong_levitar,amenazante).
test(un_dragon_es_peligroso_si_su_peligrosidad_es_mayor_a_100,nondet):-
        categoria(diosDragon_acido,peligroso),
        categoria(dragonDeMetal,peligroso),
        categoria(rhaegal_fuego,peligroso),
        categoria(smaug_camuflaje,peligroso),
        categoria(drogon_termico,peligroso),
        categoria(viserion_hielo,peligroso).
test(un_dragon_puede_volar_si_la_mitad_de_su_tam_es_menor_al_tam_de_sus_alas,nondet):-
        puedeVolar(charizard_fuego).
test(un_dragon_es_mas_peligroso_que_otro,nondet):-
        masPeligroso(chimuelo_acido,spyro_levitar),
        masPeligroso(dragonDeMetal,_).
test(un_dragon_es_menos_peligroso_que_otro):-
        \+ masPeligroso(spyro_levitar,_).
test(el_dragon_mas_peligrosos_de_todos):-
        elMasPeligrosoDeTodos(dragonVolador).
test(dos_dragones_son_rivales_si_tienen_misma_categoria_y_misma_habilidad_especial,nondet):-
        sonRivales(drogon_termico,drogon_jr_termico),
        sonRivales(drogon_jr_termico,drogon_termico).
test(se_puede_defender,nondet):-
        sePuedeDefender(charizard_fuego,viserion_hielo), 
        sePuedeDefender(drogon_jr_termico,charizard_fuego), 
        sePuedeDefender(drogon_termico,rhaegal_fuego),
        sePuedeDefender(drogon_termico,viserion_hielo),
        sePuedeDefender(drogon_jr_termico,charizard_fuego), 
        sePuedeDefender(drogon_jr_termico,rhaegal_fuego),
        sePuedeDefender(drogon_jr_termico,viserion_hielo),
        sePuedeDefender(dragonDeMetal,chimuelo_acido), 
        sePuedeDefender(dragonDeMetal,diosDragon_acido),
        sePuedeDefender(smaug_camuflaje,charizard_fuego),
        sePuedeDefender(smaug_camuflaje,chimuelo_acido),
        sePuedeDefender(smaug_camuflaje,dragonDeMetal),
        sePuedeDefender(smaug_camuflaje,diosDragon_acido),
        sePuedeDefender(smaug_camuflaje,drogon_termico),
        sePuedeDefender(smaug_camuflaje,drogon_jr_termico),
        sePuedeDefender(smaug_camuflaje,rhaegal_fuego),
        sePuedeDefender(smaug_camuflaje,spyro_levitar),
        sePuedeDefender(smaug_camuflaje,shenLong_levitar),
        sePuedeDefender(smaug_camuflaje,viserion_hielo),
        sePuedeDefender(viserion_hielo,rhaegal_fuego),
        sePuedeDefender(viserion_hielo,charizard_fuego),
        sePuedeDefender(rhaegal_fuego,viserion_hielo).

test(eficacia_de_una_habilidad_vs_otra,nondet):-
        sirveParaDefenderse(camuflaje,_),
        sirveParaDefenderse(escupir_fuego,lanzar_hielo),
        sirveParaDefenderse(lanzar_hielo,escupir_fuego),
        sirveParaDefenderse(resistencia_termica,escupir_fuego),
        sirveParaDefenderse(resistencia_termica,lanzar_hielo).

test(es_presa_facil_de_otro,nondet):- %restringo el test para los que pueden volar. 
        esPresaFacil(diosDragon_acido,dragonDeMetal), % el acido no defiende del metal y como el dragonDeMetal es mas peligroso, la consulta será V.
        \+ esPresaFacil(dragonVolador,_), % es el dragon mas peligroso de todos y su vez puede volar, entonces no es presa facil de nadie.
        esPresaFacil(dragonDeMetal,dragonVolador). %es el 2do mas peligroso, solo es presa facil de dragonVolador.

:-  end_tests(tp2).

