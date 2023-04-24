dentista(pereyra). 
dentista(deLeon). 
dentista(gomez). 

confia(cureta, pereyra).
confia(pereyra, deLeon).             

servicioRealizado(fecha(10, 11, 2010),pereyra,servicio(tratamientoConducto,pacienteObraSocial(karlsson,1231,osde))). 
servicioRealizado(fecha(16, 11, 2010),pereyra,servicio(tratamientoConducto,pacienteClinica(dodino,odontoklin))). 
servicioRealizado(fecha(21, 12, 2010),deLeon,servicio(tratamientoConducto,pacienteObraSocial(karlsson,1231,osde))).

puedeAtenderA(pereyra,pacienteObraSocial(karlsson,1231,osde)). 
puedeAtenderA(pereyra,pacienteParticular(rocchio,24)).
puedeAtenderA(gomez,pacienteParticular(harry,50)).  %%inventado valida el punto 5
puedeAtenderA(deLeon,pacienteClinica(dodino,odontoklin)).

% Punto 1
puedeAtenderA(cureta,pacienteParticular(_,Edad)):-
    between(60,80,Edad). %lo hice inversible.

puedeAtenderA(cureta,pacienteClinica(_,sarlanga)).
puedeAtenderA(patolinger,Paciente):-
    puedeAtenderA(pereyra,Paciente),
    not(puedeAtenderA(deLeon,Paciente)). 
    
puedeAtenderA(saieg,_).




% costo de servicios para cada obra social 

costo(osde,tratamientoConducto,200). 
costo(omint,tratamientoConducto,250). 
% costo de servicios por atención particular 
costo(tratamientoConducto,1200). 
% porcentaje que se cobra a clínicas asociadas 
clinica(odontoklin,80).


% costo(ObraSocial,Servicio,Precio)
% costo(Servicio,Precio). 


% FUNCTORES
% pacienteObraSocial(NombreDelPaciente,NumeroDeLegajo,ObraSocial).
% pacienteParticular(NombreDelPaciente,Edad)
% pacienteClinica(NombreDelPaciente,Clinica)

% Punto 2


precio(pacienteObraSocial(_,_,ObraSocial),Servicio,Precio):-
    costo(ObraSocial,Servicio,Precio).

precio(pacienteParticular(_,Edad),Servicio,PrecioTotal):-
    Edad > 45,
    costo(Servicio,Precio),
    PrecioTotal is Precio + 50.

precio(pacienteParticular(_,Edad),Servicio,Precio):-
    Edad < 45,
    costo(Servicio,Precio).
    
precio(pacienteClinica(_,Clinica),Servicio,PrecioTotal):-
    costo(Servicio,PrecioParticular),
    clinica(Clinica,Descuento),
    PrecioTotal is PrecioParticular * Descuento/100. 

%Punto 3

montoFacturacion(Dentista,Mes,Cuanto):-
    dentista(Dentista),
    findall(PrecioDelServicio, 
    (servicioRealizado(fecha(_,Mes,_),Dentista,servicio(Servicio,Paciente)),precio(Paciente,Servicio,PrecioDelServicio)),
    
    FacturacionTotal),
    sumlist(FacturacionTotal,Cuanto).


%Punto 4

dentistaCool(Dentista):-
    dentista(Dentista),
    forall(puedeAtenderA(Dentista,Paciente),pacienteInteresante(Paciente)).
 
pacienteInteresante(pacienteObraSocial(NombreDelPaciente,NumeroDeLegajo,ObraSocial)):-
    puedeAtenderA(_,pacienteObraSocial(NombreDelPaciente,NumeroDeLegajo,ObraSocial)),
    precio(pacienteObraSocial(NombreDelPaciente,NumeroDeLegajo,ObraSocial),tratamientoConducto,Precio),
    Precio > 1000.

pacienteInteresante(pacienteParticular(NombreDelPaciente,Edad)):-
    dentista(Dentista),
    puedeAtenderA(Dentista,pacienteParticular(NombreDelPaciente,Edad)).


%Punto 5 CONTINUAR


%TRANSITIVIDAD PRACTICAR
atiendeDeUrgencia(Dentista,Paciente):-	dentista(Dentista),
										puedeAtenderA(Dentista,Paciente).

atiendeDeUrgencia(Dentista,Paciente):-	confia(Dentista,Colega),
										atiendeDeUrgencia(Colega,Paciente).

% Punto 6
pacienteAlQueLeVieronLaCara(Paciente):-
    servicioRealizado(_,_,servicio(_,Paciente)), 
    forall(serviciosQueLeRealizaron(Servicios,Paciente),sonServiciosCaros(Paciente,Servicios)).


serviciosQueLeRealizaron(Servicio,Paciente):-
    servicioRealizado(_,_,servicio(Servicio,Paciente)). 


serviciosCaros(osde, [tratamientoConducto, implanteOseo]).

sonServiciosCaros(pacienteObraSocial(_,_,ObraSocial),Servicio):-
    serviciosCaros(ObraSocial,TratamientosCaros),
    member(Servicio, TratamientosCaros).
    
sonServiciosCaros(pacienteParticular(_,_),Servicio):-
    costo(Servicio,Precio),
    Precio > 500.


% % Punto 7
serviciosMalHechos(Dentista,ListadoDeTrabajosMalRealizados):-
servicioRealizado(_,Dentista,_),  
findall(Servicio,distinct(serviciosRelizadosEntreMesesConsecutivos(Dentista,Servicio)),ListadoDeTrabajosMalRealizados).

serviciosRelizadosEntreMesesConsecutivos(Dentista,Tratamiento):-
    servicioRealizado(fecha(_,Mes,_),Dentista,servicio(Tratamiento,_)), %considero al dentista del mes anterior.
    servicioRealizado(fecha(_,OtroMes,_),OtroDentista,servicio(Tratamiento,_)),
    1 is OtroMes - Mes,
    Dentista \= OtroDentista.


:-begin_tests(punto1).

test(punto1_puedeAtenderA,nondet):-
puedeAtenderA(cureta,pacienteParticular(mengano,61)),
puedeAtenderA(cureta,pacienteClinica(fulano,sarlanga)),
puedeAtenderA(patolinger,pacienteObraSocial(karlsson, 1231, osde)),
puedeAtenderA(patolinger,pacienteParticular(rocchio, 24)).
end_tests(punto1).


:-begin_tests(punto2).

test(punto2_puedeAtenderA,nondet):-

precio(pacienteObraSocial(karlsson,1231,osde),tratamientoConducto,200),
precio(pacienteParticular(rocchio,24),tratamientoConducto,1200),
precio(pacienteParticular(harry,50),tratamientoConducto,1250),
precio(pacienteClinica(dodino,odontoklin),tratamientoConducto,960).

end_tests(punto2).


:-begin_tests(punto3).
test(punto3_montoFacturacion,nondet):-

montoFacturacion(pereyra,11,1160).

end_tests(punto3).

:-begin_tests(punto4_a).
test(punto4a_pacienteInteresante,nondet):-

not(pacienteInteresante(pacienteObraSocial(_,_,_))),
pacienteInteresante(pacienteParticular(rocchio, 24)),
pacienteInteresante(pacienteParticular(harry, 50)).
end_tests(punto4_a).

:-begin_tests(punto4).
test(punto4_dentistaCool,nondet):-

dentistaCool(gomez).

end_tests(punto4).


:-begin_tests(punto6).
test(punto6_pacienteAlQueLeVieronLaCara,nondet):-

pacienteAlQueLeVieronLaCara(pacienteObraSocial(karlsson, 1231, osde)).

end_tests(punto6).


:-begin_tests(punto7).
test(punto6_pacienteAlQueLeVieronLaCara,nondet):-

serviciosMalHechos(pereyra,[tratamientoConducto]).
    
end_tests(punto6).
    