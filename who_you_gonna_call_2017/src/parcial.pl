herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

tieneHerramienta(egon,aspiradora(200)).
tieneHerramienta(egon,trapeador).
tieneHerramienta(peter,trapeador).
tieneHerramienta(winston,varitaDeNeutrones).
tieneHerramienta(ray,escoba).
tieneHerramienta(ray,pala).

trabajador(Trabajador):-
    tieneHerramienta(Trabajador,_).

trabajador(ray).

tareaPedida(marcos,limpiarBanio,20).
tareaPedida(marcos,limpiarTecho,20).
tareaPedida(marcos,ordenarCuarto,200).
tareaPedida(omar,limpiarTecho,100).
tareaPedida(pepe,cortarPasto,100).

precioPorM2(limpiarBanio,10).
precioPorM2(limpiarTecho,50).
precioPorM2(ordenarCuarto,100).

tarea(Tarea):-
    herramientasRequeridas(Tarea,_).

cliente(Cliente):-
    tareaPedida(Cliente,_,_).


herramienta(Herramienta):-
    herramientasRequeridas(_,Herramientas),
    member(Herramienta,Herramientas).

satisfaceNecesidadDeLaHerramienta(Trabajador,Herramienta):-
    herramienta(Herramienta),
    tieneHerramienta(Trabajador,Herramienta).

satisfaceNecesidadDeLaHerramienta(Trabajador,aspiradora(PotenciaMinimaNecesaria)):-
    tieneHerramienta(Trabajador,aspiradora(PotenciaQueTiene)),
    between(0,PotenciaQueTiene,PotenciaMinimaNecesaria).
    
puedeRealizarUnaTarea(Persona,Tarea):-
    tarea(Tarea),
    tieneHerramienta(Persona,varitaDeNeutrones).


    % herramientasRequeridas(cortarPasto, [bordedadora]).
    % tieneHerramienta(winston,varitaDeNeutrones).


puedeRealizarUnaTarea(Trabajador,Tarea):-
    trabajador(Trabajador),
    forall((herramientasRequeridas(Tarea,HerramientasRequeridas),member(Herramienta,HerramientasRequeridas)),
    satisfaceNecesidadDeLaHerramienta(Trabajador,Herramienta)).

% facturarPorPedido(marcos,total).
facturarPorPedido(Cliente,Total):-
    tareaPedida(Cliente,_,_),
    findall(Precio,facturacionPorTareaPorMetro(Cliente,_,Precio),TotalPresupuesto),
    sumlist(TotalPresupuesto,Total).


facturacionPorTareaPorMetro(Cliente,Tarea,Precio):-
    tareaPedida(Cliente,Tarea,CantidadDeMetrosCuadrados),
    precioPorM2(Tarea,PrecioPorMetro),
    Precio is PrecioPorMetro * CantidadDeMetrosCuadrados.



% - tareaPedida/3: relaciona al cliente, con la tarea pedida y la cantidad de metros
% cuadrados sobre los cuales hay que realizar esa tarea.

% Ejemplo
        % % tareaPedida(marcos,limpiarBanio,20).
        % tareaPedida(marcos,limpiarTecho,20).
        % tareaPedida(marcos,ordenarCuarto,200).
        % tareaPedida(omar,limpiarTecho,100).

% - precio/2: relaciona una tarea con el precio por metro cuadrado que se cobraría al
% cliente.
        % precioPorM2(limpiarBanio,10).
        % precioPorM2(limpiarTecho,50).
        % precioPorM2(ordenarCuarto,100).


aceptaPedido(Trabajador,Cliente):-
    puedeRealizarTodosLasTareas(Trabajador,Cliente),
    estaDispuestoAAceptarPedido(Trabajador,Cliente).

puedeRealizarTodosLasTareas(Trabajador,Cliente):-
    trabajador(Trabajador),
    tareaPedida(Cliente,_,_),
    forall(tareaPedida(Cliente,Tarea,_),puedeRealizarUnaTarea(Trabajador,Tarea)).


tareaCompleja(Tarea):-
        herramientasRequeridas(Tarea, HerramientasRequeridas),
        length(HerramientasRequeridas, TotalHerramientas),
        TotalHerramientas > 2.
    
tareaCompleja(limpiarTecho).


estaDispuestoAAceptarPedido(egon,Cliente):-
    cliente(Cliente).

estaDispuestoAAceptarPedido(ray,Cliente):-
    tareaPedida(Cliente,Tarea,_),
    Tarea \= limpiarTecho.

estaDispuestoAAceptarPedido(winston,Cliente):-
    facturarPorPedido(Cliente,Total),
    Total > 500.

estaDispuestoAAceptarPedido(egon,Cliente):- /*los pedidos estan modelados en base a hechos, para considerar la totalidad de un pedido habrá que usar un forall */
    cliente(Cliente),
    forall(tareaPedida(Cliente,Tarea,_), not(tareaCompleja(Tarea))).
    



:-begin_tests(punto2).

    test(punto2_satisfaceNecesidad,nondet):-
    satisfaceNecesidadDeLaHerramienta(egon,trapeador),
    satisfaceNecesidadDeLaHerramienta(egon,aspiradora(200)),
    not(satisfaceNecesidadDeLaHerramienta(egon,aspiradora(201))),
    satisfaceNecesidadDeLaHerramienta(peter,trapeador).

end_tests(punto2).

:-begin_tests(punto3).
    
    test(punto3_puedeRealizarUnaTarea,nondet):-
    puedeRealizarUnaTarea(winston,ordenarCuarto),
    puedeRealizarUnaTarea(winston,limpiarBanio),
    puedeRealizarUnaTarea(winston,limpiarTecho),
    puedeRealizarUnaTarea(ray,limpiarTecho),
    puedeRealizarUnaTarea(winston,cortarPasto),
    not(puedeRealizarUnaTarea(egon,ordenarCuarto)).

end_tests(punto3).


:-begin_tests(punto4).
    
    test(punto4_puedeRealizarUnaTarea,nondet):-
    facturarPorPedido(marcos,21200),
    facturarPorPedido(omar,5000).

end_tests(punto4).


:-begin_tests(punto5).

test(punto5_aceptaPedido,nondet):-
    aceptaPedido(winston,omar),
    aceptaPedido(winston,marcos),
    not(aceptaPedido(ray,marcos)).
    
end_tests(punto5).
