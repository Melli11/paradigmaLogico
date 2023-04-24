seCreoEn(lisp, 1958).% procedural y funcional
seCreoEn(prolog, 1972). %logico
seCreoEn(smalltalk, 1980).%objetos
seCreoEn(erlang, 1986).% actores
seCreoEn(haskell, 1990).
seCreoEn(java, 1995).
seCreoEn(javascript, 1996).
seCreoEn(scala, 2004).
seCreoEn(elm, 2012).
seCreoEn(wollok, 2015).

influencio(smalltalk, java).
influencio(smalltalk, scala).
influencio(smalltalk, javascript).
influencio(smalltalk, erlang).
influencio(smalltalk, wollok).
influencio(haskell, scala).
influencio(haskell, erlang).
influencio(haskell, elm).
influencio(java, scala).
influencio(java, wollok).
influencio(scala, wollok).
influencio(lisp, smalltalk).
influencio(lisp, haskell).
influencio(lisp, javascript).
influencio(lisp, scala).
influencio(lisp, erlang).
influencio(prolog, erlang).

paradigma(java, objetos).
paradigma(javascript, objetos).
paradigma(smalltalk, objetos).
paradigma(scala, objetos).
paradigma(wollok, objetos).
paradigma(lisp, funcional).
paradigma(erlang, funcional).
paradigma(haskell, funcional).
paradigma(scala, funcional).
paradigma(elm, funcional).
paradigma(lisp, procedural).
paradigma(erlang, deActores).
paradigma(prolog, logico).

funcionalidad(ordenSuperior, scala).
funcionalidad(ordenSuperior, erlang).
funcionalidad(ordenSuperior, haskell).
funcionalidad(ordenSuperior, lisp).
funcionalidad(ordenSuperior, elm).
funcionalidad(ordenSuperior, prolog).
funcionalidad(envioDeMensajes, smalltalk).
funcionalidad(envioDeMensajes, java).
funcionalidad(envioDeMensajes, wollok).
funcionalidad(envioDeMensajes, erlang).
funcionalidad(envioDeMensajes, javascript).
funcionalidad(envioDeMensajes, scala).
funcionalidad(inmutabilidad, haskell).
funcionalidad(inmutabilidad, elm).
funcionalidad(inversibilidad, prolog).
funcionalidad(lazyEvaluation, haskell).
funcionalidad(patternMatching, haskell).
funcionalidad(patternMatching, prolog).
funcionalidad(anotaciones, java).
funcionalidad(anotaciones, scala).
funcionalidad(desestructuracion, erlang).
funcionalidad(desestructuracion, javascript).

esPosterior(LenguajeA,LenguajeB):-
    seCreoEn(LenguajeA,Anio_LenguajeA),
    seCreoEn(LenguajeB,Anio_LenguajeB),
    Anio_LenguajeA > Anio_LenguajeB.

esHibrido(Lenguaje):-
    paradigma(Lenguaje,TipoDeParadigma_A),
    paradigma(Lenguaje,TipoDeParadigma_B),
    TipoDeParadigma_B \= TipoDeParadigma_A.

compartenParadigma(LenguajeA,LenguajeB,Paradigma):-
    paradigma(LenguajeA,Paradigma),
    paradigma(LenguajeB,Paradigma),
    LenguajeB \= LenguajeA.

creoUnParadigma(Lenguaje,Paradigma):-
    elMasAntiguo(Lenguaje,Paradigma).

elMasAntiguo(LenguajeA,Paradigma):- %no existe otro lenguaje con x paradigma que sea mas antiguo que ese Lenguaje.
    paradigma(LenguajeA,Paradigma), 
    forall(compartenParadigma(LenguajeA,LenguajeB,Paradigma),not(esPosterior(LenguajeA,LenguajeB))). % dados dos lenguajes A y B , si comparten el mismo paradigma , no existe un lenguajeB que sea posterior (mas antiguo) que el lenguajeA.
    

esIconico(Lenguaje):-
    influencio(Lenguaje,_),
    tuvoGranInfluencia(Lenguaje).
    
tuvoGranInfluencia(Lenguaje):-
    creoUnParadigma(Lenguaje,_).
    
% Un lenguaje tuvo gran influencia si creó un paradigma
%  o si influenció a todos los lenguajes posteriores con los que comparte algún paradigma.

tuvoGranInfluencia(Lenguaje_A):-
    paradigma(Lenguaje_A,Paradigma),
    forall((influencio(Lenguaje_A,Lenguaje_B),esPosterior(Lenguaje_A,Lenguaje_B)),compartenParadigma(Lenguaje_A,Lenguaje_B,Paradigma)).         
    
% 6 - Si una funcionalidad es central de un paradigma,
% que se cumple si está presente en todos los lenguajes de ese paradigma. Por ejemplo:

% 
% estaPresenteEnElParadigma(Funcionalidad,Paradigma):-
%     paradigma(Lenguaje, Paradigma),
%     funcionalidad(Funcionalidad, Lenguaje).


% 7 - Si una funcionalidad es exclusiva de un paradigma, que se cumple si 
% para todos los lenguajes de ese paradigma que no sean híbridos poseen esa funcionalidad. Por ejemplo:

esExclusiva(Funcionalidad,Paradigma):-
    funcionalidad(Funcionalidad,_),
    paradigma(Lenguaje,_),
    forall((paradigma(Lenguaje,Paradigma)),funcionalidad(Funcionalidad,Lenguaje)).
    not(esHibrido(Lenguaje)).

%sacar el no es hibrido del forall y dejarlo afuera.

% inversibilidad es exclusiva de lógico porque solo está en prolog.
% anotaciones no es exclusiva de objetos porque scala, un lenguaje híbrido, la posee.
% envioDeMensajes no es exclusiva porque está tanto en objetos como en actores.

:- begin_tests(tp3).

test(un_lenguaje_es_posterior_a_otro_porque_se_creo_en_un_fecha_posterior):-
    esPosterior(prolog,lisp).

test(un_lenguaje_es_hibrido_porque_pertenece_a_mas_de_un_paradigma_a_la_vez,nondet):-
    esHibrido(scala),
    esHibrido(lisp),
    esHibrido(erlang).

test(dos_lenguajes_que_comparten_paradigma):-
    compartenParadigma(smalltalk,javascript,objetos),
    compartenParadigma(javascript,smalltalk,objetos).

test(el_lenguaje_creo_un_paradigma,nondet):-
    creoUnParadigma(smalltalk,objetos),
    creoUnParadigma(lisp,procedural),
    creoUnParadigma(lisp,funcional),
    creoUnParadigma(prolog,logico),
    creoUnParadigma(erlang,deActores).

% test(la_funcionalidad_es_central,nondet):-
%     esCentral(envioDeMensajes,objetos),
%     esCentral(envioDeMensajes,funcional),
%     esCentral(inversibilidad,logico),
%     esCentral(desestructuracion,deActores),
%     \+esCentral(lazyEvaluation,funcional).

test(es_un_lenguaje_iconico,nondet):-
    esIconico(lisp),
    esIconico(haskell),
    esIconico(prolog),
    \+esIconico(erlang).

test(la_funcionalidad_es_exclusiva_del_lenguaje):-
    esExclusiva(inversibilidad,prolog),
    \+esExclusiva(envioDeMensajes,_),
    \+esExclusiva(anotaciones,objetos).

:- end_tests(tp3).
