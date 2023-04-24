:- use_module(begin_tests_con).

anioActual(AnioActual):-
    get_time(TimeStamp),
    stamp_date_time(TimeStamp,
                    date(AnioActual, _, _, _, _, _, _, _, _),
                    'UTC').




traductor(juani,traductorados([literario]),idiomas([ingles,espaniol])).
traductor(juanFDS,traductorados([tecnico([fisica,quimica]),publico]),idiomas([ingles,espaniol])).
traductor(tomi,traductorados([publico]),idiomas([frances,espaniol])).
traductor(emi,traductorados([literario]),idiomas([aleman,espaniol,frances])).

obra(laTempestad,ingles,1611,categoria(literaria,350)).
obra(lasBicisDelSol,espaniol,1992,categoria(literaria,10)).
obra(losMiserables,frances,1862,categoria(literaria,1090)).
obra(lasDosTorres,ingles,1954,categoria(literaria,1090)).
obra(laMontaniaMagica,aleman,1924,categoria(literaria,25)).
obra(constitucionDeLosEstadosUnidos,ingles,1789,categoria(documentosLegales)).
obra(declaracionDeLosDerechosDelHombreyDelCiudadano,frances,1789,categoria(documentosLegales)).
obra(animalesEnExtincion,ingles,2010,categoria(paper,biologia,3)).
obra(polinomiosCuanticos,frances,1990,cateegoria(paper,matematica,8)).
obra(herenciaBasadoEnMixines,ingles,1990,categoria(paper,cienciasDeComputacion,4)).

tradujo(juani,laTempestad,espaniol).
tradujo(juani,lasBicisDelSol,ingles).
tradujo(emi,Libro,Lenguaje):-
    loTradujoEmi(Libro),
    obra(Libro,IdiomaOriginal,_,_),
    traductor(emi,_,idiomas(ListaLenguajesEmi)),
    member(Lenguaje,ListaLenguajesEmi),
    IdiomaOriginal\=Lenguaje.
tradujo(tomi,declaracionDeLosDerechosDelHombreyDelCiudadano,espaniol).
loTradujoEmi(declaracionDeLosDerechosDelHombreyDelCiudadano).
loTradujoEmi(losMiserables).
loTradujoEmi(laMontaniaMagica).

estaDisponibleEnIdioma(Obra,Idioma):-obra(Obra,Idioma,_,_).
estaDisponibleEnIdioma(Obra,Idioma):-
    obra(Obra,_,_,_),
    traductor(Alguien,_,_),
    tradujo(Alguien,Obra,Idioma).

esIdoneoParaUnaObra(Traductor,Obra):-
    traductor(Traductor,traductorados(Traductorados),idiomas(ListaDeIdiomas)),
    obra(Obra,_,_,Categoria),
    estaDisponibleEnIdioma(Obra,Idioma),
    member(Idioma,ListaDeIdiomas),
    member(TipoDeTraductor,Traductorados),
    condicionPorCategoria(Categoria,TipoDeTraductor).

condicionPorCategoria(categoria(documentosLegales),publico).
condicionPorCategoria(categoria(literaria,CantidadPaginas),_):-CantidadPaginas=<10.
condicionPorCategoria(categoria(literaria,CantidadPaginas),literario):-CantidadPaginas>10.
condicionPorCategoria(categoria(paper,Area,_),tecnico(ListaDeEspecializaciones)):-member(Area,ListaDeEspecializaciones).
condicionPorCategoria(categoria(paper,_,Complejidad),tecnico(_)):-Complejidad<5.

fueDescriptoComo(Adjetivo,Traductor):-
    traductor(Traductor,_,_),
    condicionAdjetivo(Adjetivo,Traductor).

condicionAdjetivo(sospechoso,Traductor):-
    tradujo(Traductor,Obra,_),
    not(esIdoneoParaUnaObra(Traductor,Obra)).

condicionAdjetivo(anticuado,Traductor):-
    tradujo(Traductor,_,_),
    forall(tradujo(Traductor,Obra,_), esAntigua(Obra)).

condicionAdjetivo(copion(Copiado),Traductor):-
    tradujo(Traductor,_,_),
    forall(tradujo(Traductor,Obra,_),(tradujo(Copiado,Obra,_),Copiado\=Traductor)).

esAntigua(Obra):-
    obra(Obra,_,Anio,_),
    anioActual(AnioActual),
    AnioActual>=Anio+50.
    
antiguedadObra(Obra,Antiguedad):-
    obra(Obra,_,Anio,_),
    anioActual(AnioActual),
    Antiguedad is AnioActual-Anio.

experienciaPorLibro(Obra,Experiencia):-
    obra(Obra,_,_,_),
    antiguedadObra(Obra,Antiguedad),
    Experiencia is 3 + (Antiguedad/100).

experienciaAcumuladaTraductor(Traductor,ExperienciaAcumulada):-
    traductor(Traductor,_,_),
    findall(Experiencia, (tradujo(Traductor,Obra,_),experienciaPorLibro(Obra,Experiencia)), ListaDeExperiencias),
    sum_list(ListaDeExperiencias,ExperienciaAcumulada).
    

:- begin_tests_con(parcial, []).
test(emi_tradujo_los_derechos_del_hombre_y_del_ciudadano_en_aleman,nondet):-
    tradujo(emi,declaracionDeLosDerechosDelHombreyDelCiudadano,aleman).
test(emi_tradujo_los_derechos_del_hombre_y_del_ciudadano_en_espaniol,nondet):-
    tradujo(emi,declaracionDeLosDerechosDelHombreyDelCiudadano,espaniol).
test(tomi_es_idoneo_para_traducir_los_derechos_del_hombre,nondet):-
    esIdoneoParaUnaObra(tomi,declaracionDeLosDerechosDelHombreyDelCiudadano).
test(juani_es_idoneo_para_traducir_los_miserables,nondet):-
    esIdoneoParaUnaObra(juani,losMiserables).
test(juanFDS_es_idoneo_para_traducir_animales_enExtincion,nondet):-
    esIdoneoParaUnaObra(juanFDS,animalesEnExtincion).
test(juanFDS_es_idoneo_para_traducir_herenciaBasadaEnMixines,nondet):-
    esIdoneoParaUnaObra(juanFDS,herenciaBasadoEnMixines).
test(emi_es_sospechoso_por_traducir_los_derechos_del_hombre,nondet):-
    fueDescriptoComo(sospechoso,emi).
test(tomi_es_anticuado,nondet):-
    fueDescriptoComo(anticuado,tomi).
test(tomi_copio_las_traducciones_de_emi,nondet):-
    fueDescriptoComo(copion(emi),tomi).
test(la_experiencia_acumulada_viene_de_sumar_tres_a_la_experiencia_de_cada_libro_que_tradujo,nondet):-
    experienciaAcumuladaTraductor(juani,10.41),
    experienciaAcumuladaTraductor(emi,27.82),
    experienciaAcumuladaTraductor(juanFDS,0).

:- end_tests(parcial).
