
% Base de conocimientos
materia( algoritmos , 1 ).
materia( analisisI , 1 ).
materia( pdp , 2 ).
materia( proba , 2 ).
materia( sintaxis , 2 ).
nota( nicolas , pdp , 10 ).
nota( nicolas , proba , 7 ).
nota( nicolas , sintaxis , 8 ).
nota( malena , pdp , 6 ).
nota( malena , proba , 2 ).
nota( raul , pdp , 9 ).

nota( mar , pdp , 10 ).
nota( mar , proba , 7 ).
nota( mar , sintaxis , 8 ).
nota( mar , algoritmos , 8 ).
nota( mar , analisisI , 8 ).


% 1)    "Un alumno terminó un año si aprobó todas las materias de ese año"
% Qué alumnos terminaron 2° año

%primera versión

terminoAnio(Alumno,Anio):-
    nota(Alumno,_,_),
    forall(materia(Materia,Anio),(nota(Alumno,Materia,Nota),Nota >= 6)).

%segunda versión
terminoAnio_2(Alumno,Anio):-
    nota(Alumno,_,_),
    forall(materia(Materia,Anio),aprobo(Alumno,Materia,_)).

aprobo(Alumno,Materia,Nota):-
    nota(Alumno,Materia,Nota),
    Nota >= 6.

% Interprete

% terminoAnio_2(Quien,2).  
% Quien = nicolas ;
% Quien = nicolas ;
% Quien = nicolas ;
% false.

% 2)    ¿Qué puedo hacer para que forall pregunte si un alumno aprobó todas las
% materias de un año?
terminoAnio_3(Alumno,Anio):-
    nota(Alumno,_,_),
    materia(_,Anio),
    forall(materia(Materia,Anio),aprobo(Alumno,Materia,_)).



% existe algun alumno que se haya recibido? Es decir que un alumno que
% encontré aprobó todas las materias de todos los años

seRecibio(Alumno):-
    nota(Alumno,_,_),
    forall(materia(Materia,_),aprobo(Alumno,Materia,_)).
