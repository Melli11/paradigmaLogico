# TP-2

## Tareas

- [ ] Aceptar el assignment y clonar el repositorio con el ejercicio
- [ ] Reemplazar nombre y legajo en el archivo README.md

- **Nombre:** Martin Gerez
- **Legajo:** 1416534

## Pre-requisitos

Tener instalado [prolog](https://github.com/pdep-utn/enunciados-miercoles-noche/blob/master/pages/prolog/entorno.md).

## El enunciado: Dragones 8: El cuaderno de Patapez

Patapez como amante de los drágones desde pequeño fue armando un cuaderno donde ir clasificando drágon por drágon en distintas categorias: Inofensivo, amenazante y peligroso.
Para clasificarlo calcula un número de peligrosidad dependiendo de ciertos atributos del drágon que esta observando: fuera del nombre (que sirve para identificarlo) las cosas mas interesantes son el **tamaño, el tamaño de las alas, la cantidad de disparos y una potencial habilidad especial.**

Cada habilidad especial tiene un puntaje relacionado:
- escupir acido, 20.
- levitar, 0.
- escupir fuego, 30.
- camuflaje, 25.
- lanzar hielo, 40.
- resistencia termica, 30.

## Peligrosidad

La **peligrosidad** de un drágon se cálcula como el Tamanio + el poder de la habilidad especial + 3 * la cantidad de disparos.

## Categoria
Si la peligrosidad es entre 0 y 50 es **inofensivo**.
Si es entre 51 y 100 es **amenazante**.
Si es mayor a 100 es **peligroso**.

## puede volar?
Queremos saber a su vez si un drágon vuela que se cumple si el tamaño de sus alas es mayor a la mitad del tamaño del drágon o si posee la habilidad levitar.

## más peligrosos.
Un drágon es más peligroso si tiene mayor nivel de peligrosidad.

## el más peligroso.
Queremos saber cual es el drágon más peligroso que se cumple si no existe otro más peligroso que él.

## rivales
2 drágones son rivales si tienen la misma **categoria** y la misma **habilidad especial**.

## se puede defender 
Un **drágon** se puede defender de otro si su habilidad  sirven para defenderse contra la del otro:
- Cuerpo de metal sirve contra escupir acido.
- Escupir acido no sirve contra el hielo.
- Resistencia termica sirve contra fuego y hielo.
- El fuego no sirve contra la resistencia termica ni el metal.
- El hielo sirve contra el fuego y viceversa.
- Y el camuflaje sirve contra cualquier otra.

## presas faciles
Queremos saber finalmente si un **drágon es presa facil** de otro que se cumple si su peligrosidad es menor y a su vez no se puede defender o si no puede volar.
## Que hacer cuando terminan el TP

Cuando terminen, creen un issue etiquetando a sus tutores así les llega una notificación y se corrigen y les dejan feedback ahí.
![](https://i.imgur.com/ypeXpBw.gif)
