%comio(Personaje, Bicho)
comio(pumba, vaquitaSanAntonio(gervasia,3)).
comio(pumba, hormiga(federica)).
comio(pumba, hormiga(tuNoEresLaReina)).
comio(pumba, cucaracha(ginger,15,6)).
comio(pumba, cucaracha(erikElRojo,25,70)).
comio(timon, vaquitaSanAntonio(romualda,4)).
comio(timon, cucaracha(gimeno,12,8)).
comio(timon, cucaracha(cucurucha,12,5)).
comio(simba, vaquitaSanAntonio(remeditos,4)).
comio(simba, hormiga(schwartzenegger)).
comio(simba, hormiga(niato)).
comio(simba, hormiga(lula)).
comio(shenzi,hormiga(conCaraDeSimba)).
pesoHormiga(2).
%peso(Personaje, Peso)
peso(pumba, 100).
peso(timon, 50).
peso(simba, 200).
peso(scar, 300).
peso(shenzi, 400).
peso(banzai, 500).

persigue(scar, timon).
persigue(scar, pumba).
persigue(shenzi, simba).
persigue(shenzi, scar).
persigue(banzai, timon).
persigue(scar, mufasa).




/* punto 1 */

jugosita(cucaracha(_,Tamanio,Peso1)):-	comio(_,cucaracha(_,Tamanio,Peso2)),
	Peso1 > Peso2 .
												
hormigofilico(Animal):-
	peso(Animal,_),					
	findall(Hormiga,comio(Animal,hormiga(Hormiga)),Hormigas),
	length(Hormigas,Cant),
	Cant >= 2 .
						
cucarachofobico(Animal):-	
	peso(Animal,_),
	not(comio(Animal,cucaracha(_,_,_))).
							
picarones(Picarones):-
	findall(Animal,esPicaron(Animal),Picarones).

esPicaron(Animal):-	
	peso(Animal,_),
	comio(Animal,Cucaracha),
	jugosita(Cucaracha).
						
esPicaron(Animal):-	
	peso(Animal,_),	
	comio(Animal,vaquitaSanAntonio(remeditos,_)).

esPicaron(pumba).

/* punto 2 */

cuantoEngorda(Personaje,Peso):-
		peso(Personaje,_),
		pesoDeLasPresas(Personaje,PesoPresas),
		pesoDeLosBichos(Personaje,PesoBichos),
	
	Peso is PesoPresas + PesoBichos.
								
pesoDeLasPresas(Personaje,PesoPresas):-	
	findall(Peso,(persigue(Personaje,Presa),pesoPresaYSusBocados(Presa,Peso)),Pesos),
	sumlist(Pesos,PesoPresas).								

										
pesoPresaYSusBocados(Presa,Peso):-
		peso(Presa,PesoPresa),
		pesoDeLasPresas(Presa,PesoPresas),
		pesoDeLosBichos(Presa,PesoBichos),
		Peso is PesoPresa + PesoBichos + PesoPresas.
										
pesoDeLosBichos(Personaje,Peso):-
	findall(PesoBicho,(comio(Personaje,Bicho),pesoBicho(Bicho,PesoBicho)),PesosBichos),
	sumlist(PesosBichos,Peso).
								
pesoBicho(vaquitaSanAntonio(_,PesoBicho),PesoBicho).
pesoBicho(hormiga(_),PesoBicho):-	pesoHormiga(PesoBicho).
pesoBicho(cucaracha(_,_,PesoBicho),PesoBicho).

/* punto 3 */

rey(Rey):-	persigue(_,Rey),
			findall(Perseguidor,persigue(Perseguidor,Rey),Perseguidores),
			length(Perseguidores, 1 ),
			not(persigue(Rey,_)),
			not(comio(Rey,_)).
			