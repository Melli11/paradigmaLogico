
nacio(juan,fecha(9,7,1994)).
nacio(aye,fecha(26,3,1992)).
nacio(feche,fecha(22,12,1995)).


persona(Persona):-
    nacio(Persona,_).

fecha(Fecha):-
    nacio(_,Fecha).

mes(fecha(_,Mes,_),Mes).
anio(fecha(_,_,Anio),Anio).


% a) si una fecha es antes que otra.
fechaAnterior(Fecha1,Fecha2):-
    nacio(_,Fecha1),
    nacio(_,Fecha2),
    esAnioAnterior(Fecha1,Fecha2),
    esMesAnterior(Fecha1,Fecha2),
    esDiaAnterior(Fecha1,Fecha2).

esAnioAnterior(fecha(_,_,Anio1),fecha(_,_,Anio2)):-
    Anio1 < Anio2.

esMesAnterior(fecha(_,Mes1,_),fecha(_,Mes2,_)):-
    Mes1 < Mes2.

esDiaAnterior(fecha(_,_,Dia1),fecha(_,_,Dia2)):-
    Dia1 < Dia2.

% b) si ya pasó el cumpleaños de alguien en cierta fecha. 

yaPasoSuCumpleanio(Fecha,Persona):-
    nacio(Persona,FechaCumple),
    esMesAnterior(FechaCumple,Fecha),
    esDiaAnterior(FechaCumple,Fecha).

amigoInvisibleDe(feche,juan).
amigoInvisibleDe(aye,juan).
amigoInvisibleDe(feche,aye).
amigoInvisibleDe(juan,aye).
amigoInvisibleDe(juan,feche).
amigoInvisibleDe(aye,feche).


regaloDe(juan,feche,libro(genero(fantasia),autor(terry_pratchet)),2018).
regaloDe(juan,feche,cerveza(quilmes,rubia),2021).
regaloDe(juan,aye,producto(harry_potter),2019).
regaloDe(juan,aye,cerveza(artesanal,roja),2020).
regaloDe(aye,feche,libro(genero(fantasia),autor(terry_pratchet)),2019).
regaloDe(aye,juan,libro(genero(ciencia_ficcion),autor(stanislaw_lem)),2020).
regaloDe(feche,juan,cerveza(artesanal,rubia),2019).
regaloDe(feche,juan,producto(pokemon),2020).
regaloDe(feche,aye,libro(genero(terror),autor(mary_shelley)),2021).

regalos(Regalo):-
    regaloDe(_,_,Regalo,_).

% A quién puede regalar

aQuienPuedeRegalar(Fecha,AmigoInvisible,OtraPersona):-
    % amigoInvisibleDe(UnaPersona,AmigoInvisible),
    noRegaloNada(AmigoInvisible,Fecha),
    noCumplioAnios(Fecha,OtraPersona),
    noRecibioRegalos(OtraPersona,Fecha).


noRecibioRegalos(UnaPersona,Fecha):-
    anio(Fecha,Anio),
    persona(UnaPersona),
    not(regaloDe(_,UnaPersona,_,fecha(_,_,Anio))).

noCumplioAnios(Fecha,UnaPersona):-
    persona(UnaPersona),
    fecha(Fecha),
    not(yaPasoSuCumpleanio(Fecha,UnaPersona)).

noRegaloNada(AmigoInvisible,Fecha):-
    anio(Fecha,Anio),
    persona(AmigoInvisible),
    not(regaloDe(AmigoInvisible,_,_,fecha(_,_,Anio))).

% Buenos regalos
buenRegalo(Regalo,AmigoInvisible,UnaPersona):-
    regaloDe(AmigoInvisible,UnaPersona,Regalo,_),
    leGusta(UnaPersona,Regalo).


leGusta(aye,cerveza(heineken,rubia)).
leGusta(aye,producto(harry_potter)).
leGusta(juan,libro(genero(fantasia),autor(_))).
leGusta(juan,libro(genero(ciencia_ficcion),autor(_))).

leGusta(feche,producto(monster_hunter)).

leGusta(juan,Regalo):- esCaro(Regalo).

leGusta(feche,Regalo):-
    regalos(Regalo),
    losLibrosDeTerry(Regalo),
    not(esCaro(Regalo)).
    
esCaro(libro(genero(ciencia_ficcion),autor(ray_bradbury))).
esCaro(libro(genero(novela),autor(_))).
esCaro(cerveza(artesanal,_)).

losLibrosDeTerry(libro(genero(_),autor(terry_pratchet))).

% Hábil regalador 
% 4. Queremos saber quienes son hábiles regaladores, lo cual se cumple si siempre hicieron 
% buenos regalos y además nunca hicieron 2 regalos parecidos en distintos años.



% habilRegalador(AmigoInvisible):-

%     forall(regalo(Regalo),buenRegalo(Regalo,AmigoInvisible,_))


% hizoRegalosParecidos(Persona):-
%     regaloDe(Persona,OtraPersona,Regalo,Anio),
%     findall(Regalo,regaloDe(Persona,OtraPersona,Regalo,Anio),listaDeRegalos),

% sonRegalosParecidos(cerveza(_,_),cerveza(_,_)).
% sonRegalosParecidos(regalo(libro(genero(Genero),_)),regalo(libro(genero(Genero),_))).
% sonRegalosParecidos(producto(Tematica),producto(Tematica)).

% sonRegalosParecidos(cerveza(Marca,Color),cerveza(Marca,Color)):-
%     regalos(Regalo).

% buenRegalo(Regalo,AmigoInvisible,UnaPersona)

% :- begin_tests(practica).

% test(punto2_a_quien_puede_regalar):-
%     aQuienPuedeRegalar(fecha(05,01,2021))

% test(es_buen_regalo,nondet):-
%         buenRegalo(producto(harry_potter),_,aye).
%         % buenRegalo(cerveza(heineken,rubia),_,aye),
%         % buenRegalo(libro(genero(fantasia),_),_,juan),
%         % buenRegalo(libro(genero(ciencia_ficcion),_),_,juan),
%         % buenRegalo(libro(genero(ciencia_ficcion),autor(ray_bradbury)),_,juan),
%         % buenRegalo(libro(genero(novela),autor(pepito)),_,juan),
%         % buenRegalo(cerveza(artesanal,_),_,juan).

% :- end_tests(practica).

    
