# TP-3

## Tareas

- [ ] Aceptar el assignment y clonar el repositorio con el ejercicio
- [ ] Reemplazar nombre y legajo en el archivo README.md

- **Nombre:** Martin Gerez
- **Legajo:** 1416534

## Pre-requisitos

Tener instalado [prolog](https://github.com/pdep-utn/enunciados-miercoles-noche/blob/master/pages/prolog/entorno.md).

## El enunciado: Lenguajes en la historia

Partimos de una base de conocimientos que ya tiene 4 predicados:
- `seCreoEn/2`, que relaciona un lenguaje con el año en el que se creó.
- `influencio/2`, que relaciona dos lenguajes si el primero influenció al segundo.
- `paradigma/2`, que relaciona cada lenguaje con un paradigma al que pertenece.
- `funcionalidad/2`, que relaciona una funcionalidad con un lenguaje que la posee.

El objetivo del TP es implementar predicados para poder responder a las consultas que se explican a continuación, y hacer tests para verificar que se funcionen bien.

Lo que queremos saber es:

1 - Si un lenguaje es **posterior** a otro, que es verdad si se creo en un año mayor.

2 - Si un lenguaje es **híbrido**, que significa que es de más de un paradigma a la vez.

3 - Si dos lenguajes **comparten** un paradigma (y cuál comparten).

4 - Si un lenguaje **creó** un paradigma, que se cumple si para ese paradigma es el más antiguo. Esto debería ser verdad para smalltalk con objetos, lisp con procedural y funcional, prolog con lógico y erlang con actores.

5 -
Si un lenguaje es **icónico**, que es cierto para los que influenciaron al menos un lenguaje, y que además tuvieron gran influencia. Un lenguaje tuvo gran influencia si creó un paradigma o si influenció a todos los lenguajes posteriores con los que comparte algún paradigma.

  Por ejemplo:
  - lisp es icónico porque influenció algunos lenguajes y además fue el primer lenguaje tanto funcional como procedural según nuestra base de conocimientos
  - haskell es icónico porque a pesar de no ser el primer lenguaje funcional influenció a todos los lenguajes funcionales que le siguieron
  - prolog es icónico porque influenció algún lenguaje (erlang) y creó un paradigma (lógico)
  - Por otra parte, erlang **NO** es icónico porque a pesar de haber creado un paradigma (de actores), no influenció a ningún otro lenguaje que tengamos en nuestra base de conocimientos.

6 - Si una funcionalidad es **central** de un paradigma, que se cumple si está presente en todos los lenguajes de ese paradigma. Por ejemplo:
  - envioDeMensajes es central de objetos porque aparece en todos los lenguajes del mismo
  - pero lazyEvaluation no es central de funcional porque no aparece en elm ni en lisp.

7 - Si una funcionalidad es **exclusiva** de un paradigma, que se cumple si solamente lenguajes de ese paradigma que no sean híbridos poseen esa funcionalidad. Por ejemplo: 
  - inversibilidad es exclusiva de lógico porque solo está en prolog.
  - anotaciones no es exclusiva de objetos porque scala, un lenguaje híbrido, la posee.
  - envioDeMensajes no es exclusiva porque está tanto en objetos como en actores.

8 - Si un lenguaje es puro. Esto es verdad cuando no es híbrido y aparte solo tiene funcionalidades centrales de su paradigma y Haskell, que aunque no cumpla esa regla lo contamos como lenguaje puro. Los otros únicos ejemplos de esto son smalltalk, prolog y wollok.

Cuando terminen, creen un issue etiquetando a sus tutores así les llega una notificación y se corrigen y les dejan feedback ahí.
![](https://i.imgur.com/ypeXpBw.gif)
