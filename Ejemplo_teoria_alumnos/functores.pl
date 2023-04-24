
% vende(Articulo,Precio)
%libro(Titulo,Autor,Genero,Editorial)
vende(libro(elReplandor,stephenKing,terror,debolsillo),2300).
vende(libro(mort,terrPratchett,aventura,plazaJanes),1300).
vende(libro(harryPotter3,jkRowling,ficcion,salamandra),2500).
vende(libro(harryPotter3,jkRowling,ficcion,plazaJanes),2500). %otra editorial
vende(libro(laEsquinaDelInfinito,laRenga,autobiografia,ledesma),2500). %otra editorial

% cd(Titulo,Autor,Genero,CantidadDeDiscos,CantidadDeTemas)
vende(cd(differentClass,pulp,pop,2,24),1450).
vende(cd(bloodOnTheTracks,bobDylan,folk,1,12),2500).
vende(cd(laEsquinaDelInfinito,laRenga,rock,10,10),1500).
vende(cd(truenotierra,laRenga,rock,9,12),1300).


% vende(pelicula(Titulo,Director,Genero))

% Punto 0) tematico: Se cumple para un autor si todo lo que se vende es de él.

tematico(Autor):-
    autor(_,Autor),
    forall(vende(Articulo,_),autor(Articulo,Autor)).

%Relaciona un articulo con su autor
autor(libro(_,Autor,_,_),Autor):- %predicado auxiliar semi inversible, para obtener los autores de los articulos en venta.
    vende(libro(_,Autor,_,_),_).

autor(cd(_,Autor,_,_,_),Autor):- %predicado auxiliar semi inversible
    vende(cd(_,Autor,_,_,_),_).



% Punto1) libroMasCaro(Articulo): Se cumple para un articulo si es el libro de mayor precio.

libroMasCaro(Articulo):-
    filtrarPorLibroyPrecio(Articulo,Precio),
    not((filtrarPorLibroyPrecio(OtroArticulo,OtroPrecio),Articulo\=OtroArticulo,OtroPrecio >Precio)).

filtrarPorLibroyPrecio(libro(Titulo,Autor,Genero,Editorial),Precio):- 
    vende(libro(Titulo,Autor,Genero,Editorial),Precio).

%otra forma de resolverlo

libroMasCaro_2(libro(Titulo,Autor,Genero,Editorial)):-
    vende(libro(Titulo,Autor,Genero,Editorial),UnPrecio), %% en el generador coloco el predicado que hace inversible a la consulta y que ademas tiene preponderancia el precio
    forall(vende(libro(_,_,_,_),OtroPrecio),OtroPrecio =< UnPrecio). %% el functor libro llega con todas las variables "libres"


:-begin_tests(functores).
    test(libro_mascaro,nondet):-
        libroMasCaro(libro(harryPotter3,jkRowling,ficcion,salamandra)).

:- end_tests(functores).


% Punto2)  curiosidad/1: Se cumple para un articulo si es lo unico que hay a la venta de su autor.

curiosidad(Articulo):-
    vende(Articulo,_),
    autor(Articulo,Autor),
    not((vende(OtroArticulo,_),autor(OtroArticulo,Autor), Articulo \= OtroArticulo)).

curiosidad_2(Articulo):-
    autor(Articulo,_),
    forall(autor(_,Autor),(not((autor(OtroArticulo,Autor))),OtroArticulo\= Articulo)).

:-begin_tests(functores).
    test(curiosidad,nondet):-
        not(curiosidad(cd(laEsquinaDelInfinito,laRenga,rock,10,10))),
        not(curiosidad(cd(truenotierra,laRenga,rock,9,12))).

:- end_tests(functores).


% Punto3)  sePrestaAConfusion/1: Se cumple para un titulo si pertenece a mas de un articulo o dicho de otra manera si dos o mas articulos diferentes tienen el mismo titulo.

sePrestaAConfusion(Titulo):-
    titulo(Articulo,Titulo),
    titulo(OtroArticulo,Titulo),
    Articulo \= OtroArticulo.

%Relaciona un articulo con su titulo

titulo(libro(Titulo,_,_,_),Titulo):- %predicado auxiliar semi inversible, para obtener los titulos de los articulos en venta.
    vende(libro(Titulo,_,_,_),_).

titulo(cd(Titulo,_,_,_,_),Titulo):- %predicado auxiliar semi inversible,para obtener los titulos de los articulos en venta.
    vende(cd(Titulo,_,_,_,_),_).

:-begin_tests(functores).
test(sePrestaAConfusion,nondet):-
        sePrestaAConfusion(laEsquinaDelInfinito). %porque es un titulo que se repite tanto para un cd como para un libro.
:- end_tests(functores).

% Punto 4) mixto/1: Se cumple para los autores de mas de un tipo de articulo.

mixto(Autor):-
    autor(Articulo,Autor),
    autor(OtroArticulo,Autor),
     Articulo \= OtroArticulo.

mixto_2(Autor):- % otra alternativa para discriminar el articulo dentro del predicado.
    autor(cd(_,_,_,_,_),Autor),
    autor(libro(_,_,_,_),Autor).

:-begin_tests(functores).
test(mixto,nondet):-
        mixto(laRenga). %porque es un autor que tiene en su autoria tanto un libro como un cd.
:- end_tests(functores).


% Punto 5) Agregar soporte para vender peliculas de con titulo director y genero.

% vende(pelicula(Titulo,Director,Genero))

titulo(pelicula(Titulo,_,_,_),Titulo):-
    vende(pelicula(Titulo,_,_),Titulo).