dentista(pereyra).
dentista(deLeon).
puedeAtenderA(pereyra,pacienteObraSocial(karlsson, 1231, osde)).
puedeAtenderA(pereyra,pacienteParticular(rocchio, 24)).
puedeAtenderA(deLeon, pacienteClinica(dodino,odontoklin)).
% costo de servicios para cada obra social
costo(osde, tratamientoConducto, 200).
costo(omint, tratamientoConducto, 250).
% costo de servicios por atenci�n particular
costo(tratamientoConducto, 1200).
% porcentaje que se cobra a cl�nicas asociadas
clinica(odontoklin, 80).

/* servicioRealizado(fecha, dentista, servicio(servicio, functor paciente)) */
servicioRealizado(fecha(10, 11, 2010), pereyra, servicio(tratamientoConducto, pacienteObraSocial(karlsson, 1231, osde))).
servicioRealizado(fecha(16, 11, 2010), pereyra, servicio(tratamientoConducto, pacienteClinica(dodino, odontoklin))).
servicioRealizado(fecha(21, 12, 2010), deLeon, servicio(tratamientoConducto, pacienteObraSocial(karlsson, 1231, osde))).

confia(pereyra, deLeon).
confia(cureta, pereyra).


/* punto 1 */

puedeAtenderA(cureta,pacienteParticular(_,Edad)):-	Edad > 60 .
puedeAtenderA(cureta,pacienteClinica(_,sarlanga)).
puedeAtenderA(patolinger,Paciente):-	puedeAtenderA(pereyra,Paciente).
puedeAtenderA(patolinger,Paciente):-	puedeAtenderA(deLeon,Paciente).
puedeAtenderA(saieg,Paciente):-	puedeAtenderA(_,Paciente).

/* punto 2 */

precio(pacienteObraSocial(_,_,ObraSocial),Servicio,Precio):-
							costo(ObraSocial,Servicio,Precio).

precio(pacienteParticular(_,Edad),Servicio,Precio):-costo(Servicio,Costo),
													Edad > 45 ,
													Adicional is 50 ,
													Precio is Costo+Adicional.
precio(pacienteParticular(_,Edad),Servicio,Precio):-	costo(Servicio,Costo),
													Edad =< 45 ,
													Adicional is 0 ,
													Precio is Costo+Adicional.													
precio(pacienteClinica(_,Clinica),Servicio,Precio):-	clinica(Clinica,Porcentaje),
													costo(Servicio,Costo),
													Precio is (Costo * (Porcentaje/100)) .
													
/* punto 3 */

montoFacturacion(Medico,Mes,Cuanto):-	dentista(Medico),
										findall(Precio,precioPorServicioRealizado(Medico,Mes,Precio),Precios),
										sumlist(Precios,Cuanto).
										
precioPorServicioRealizado(Medico,Mes,Precio):-	servicioRealizado(fecha(_,Mes,_),Medico,servicio(Servicio,Paciente)),
												precio(Paciente,Servicio,Precio).
/* punto 4 */

dentistaCool(Dentista):-	dentista(Dentista),
							forall(servicioRealizado(_,Dentista,servicio(Servicio,Paciente)),esPacienteInteresante(Paciente,Servicio)).

esPacienteInteresante(pacienteObraSocial(_,_,ObraSocial),Servicio):-	costo(ObraSocial,Servicio,Precio),
																			Precio > 1000 .
																			
esPacienteInteresante(pacienteParticular(_,_),_).

/* punto 5 */

atiendeDeUrgencia(Dentista,Paciente):-	dentista(Dentista),
										puedeAtenderA(Dentista,Paciente).
atiendeDeUrgencia(Dentista,Paciente):-	confia(Dentista,Colega),
										atiendeDeUrgencia(Colega,Paciente).

/* punto 6 */

pacienteAlQueLeVieronLaCara(pacienteObraSocial(Paciente,_,ObraSocial)):-	puedeAtenderA(_,pacienteObraSocial(Paciente,_,ObraSocial)),
																			findall(Servicio,servicioRealizado(_,_,servicio(Servicio,pacienteObraSocial(Paciente,_,ObraSocial))),Servicios),
																			serviciosCaros(ObraSocial,Servicios).

serviciosCaros(ObraSocial,[tratamientoConducto,implanteOseo]).

pacienteAlQueLeVieronLaCara(pacienteParticular(Paciente,_)):-	
			puedeAtenderA(_,pacienteParticular(Paciente,_)),
			forall(servicioRealizado(_,_servicio(Servicio,pacienteParticular(Paciente,_))),esServicioCaro(Servicio)).

esServicioCaro(Servicio):-	costo(Servicio,Costo),
							Costo > 500 .

/* punto 7 */

serviciosMalHechos(Dentista,Servicios):-	dentista(Dentista),
											findall(Servicio,servicioMalHecho(Dentista,Servicio),Servicios).
											
servicioMalHecho(Dentista,Servicio):-	servicioRealizado(fecha(_,Mes1,_),Dentista,servicio(Servicio,_)),
										Mes2 is Mes1 + 1,
										servicioRealizado(fecha(_,Mes2,_),_,servicio(Servicio,_)).