# Pruebas de robots


En una empresa ficticia se evalúa el desempeño de robots para resolver problemas de lógica.

En una **cámara de pruebas** se prepara un desafío de lógica que el robot deberá resolver. La cámara además ofrece 
energía a cierta potencia para que el robot pueda trabajar.

La capacidad de un robot para resolver un problema y sus requerimientos energéticos serán determinados por los **núcleos de personalidad**
que se le instalen. En efecto, un robot puede tener varios núcleos, cada uno aportando **capacidad de resolver problemas** y necesitando
cierta **potencia energética**.

Este enunciado cubre parte de la lógica de dominio del sistema que registrará como se comportan los robots ante los distintos desafíos que se encuentran 
en las cámaras. De cada cámara va a interesar modelar la **dificultad** del desafío y la **potencia disponible** como números. Es decir, no se pide que el robot resuelva realmente un problema ni que consuma energía real, sólo interesa conocer estas características para que el software final pueda determinar las mejores combinaciones de núcleos de personalidad para cada problema ofrecido en una cámara. 

## Aclaraciones para el Parcial
- El parcial es **individual**. Este es el enunciado de la parte domiciliaria. El código debe estar pusheado en el repositorio a modo de backup
pero la entrega oficial se realiza en papel al resolver la parte presencial
- Se evalúa el polimorfismo, delegación, buenas abstracciones, evitar lógica repetida, guardar vs. calcular, y lanzar excepciones cuando un método no puede cumplir con su responsabilidad.

## 1: Cámaras y núcleos de personalidad

Una **cámara de pruebas** es una habitación donde se realiza un desafío de lógica. De cada cámara se conoce la **dificultad** del desafío. Además cada cámara ofrece energía para que el robot la use. Lo que le puede interesar a un robot es conocer la  **potencia energética disponible** en la cámara. 
Ambas características: **dificultad** y **potencia disponible** son valores numéricos que se conocen para cada cámara.

Un **robot** tiene varios **núcleos de personalidad** con los cuales colabora para resolver el desafío que presenta una cámara.

Todo **núcleo de personalidad** aporta a un robot una cierta **capacidad de resolver problemas** (un número) y la  **potencia energética** que necesita para funcionar adecuadamente (otro número).


### 1.1: Núcleo de Moralidad

Un núcleo de moralidad puede estar **normal** o **corrupto**. 

- **Capacidad de resolver problemas:** si está normal, es 50 de base más 50 por cada vez que se ha usado: `50 * (1 + veces usadas)`. Si está corrupto, solo aporta `40`, sin importar cuántas veces se ha utilizado.
- **Potencia que necesita:** si está normal, es un porcentaje de la potencia disponible en la cámara. Si nunca se usó es el 5%. Cada uso hace que necesite un 1% menos. Por lo tanto la fórmula para cuando está normal es: `(5 - veces usadas) * potencia disponible de la cámara / 100 `. Si está corrupto, siempre necesita el total de la potencia disponible de la cámara, sin importar cuántas veces se ha utilizado.

**Nota:** Se espera una solución polimórfica. Las soluciones basadas en booleanos para modelar el estado de corrupción serán castigadas.

#### Requerimientos
- Saber la capacidad de resolver problemas de un núcleo de moralidad.
- Saber cuánta potencia necesita de una cámara un núcleo de moralidad.

#### Escenario de prueba
La **Cámara 01** tiene dificultad 100 y potencia disponible de 160.

Un núcleo de moralidad nuevo, que nunca se usó:
- aporta una capacidad de resolver problemas de **50**: `50 * (1 + 0)`.
- necesita de la **Cámara 01** una potencia de **8**:  `160 * 5 / 100`.

Si ese mismo núcleo se hubiera usado 2 veces:
- aporta una capacidad de resolver problemas de **150**: `50 * (1 + 2)`.
- necesita de la **Cámara 01** una potencia de **4.8**: `(5 - 2) * 160 / 100`.

Pero si ese núcleo está corrupto, entonces:
- aporta una capacidad de resolver problemas de **40**, sin importar cuántas veces se usó.
- necesita de la **Cámara 01** una potencia de **160**: el 100% de 160.

### 1.2: Núcleo de Inteligencia y Núcleo de Inteligencia Emocional

De un **núcleo de inteligencia** se conoce su **esfuerzo** y su **memoria**. Ambos son números que se indican para cada 
núcleo de inteligencia y determinan la **velocidad de pensamiento**: `esfuerzo * memoria / 10`.

La **capacidad de resolver problemas** es la suma de la velocidad de pensamiento y la memoria: `esfuerzo * memoria / 10 + memoria`.

La **potencia que necesita** de una cámara es de `30 * esfuerzo`.

El **núcleo de inteligencia emocional** es una especie de núcleo de inteligencia con algunas particularidades:
- Su velocidad de pensamiento es el **doble** de la que tendría un núcleo de inteligencia con los mismos datos.
- Además se conoce su **emocionalidad** (otro número), que le suma o resta capacidad de resolver problemas. Por ejemplo, un núcleo emocional que modele la ira tendrá la emocionalidad en negativo, mientras que otro basado en la intuición la tendrá en positivo.
- Por lo tanto, su **capacidad de resolver problemas** es `2 * ( esfuerzo * memoria / 10)  + memoria + emocionalidad`.
- La potencia que necesita es igual a la de un núcleo de inteligencia: `30 * esfuerzo`.

**Nota:** es posible que la capacidad de resolver problemas sea negativa, sin que eso se considere un problema. Se espera además una solución que no duplique código.

#### Requerimientos
- Saber la capacidad de resolver problemas de un núcleo de inteligencia y de un núcleo de inteligencia emocional.
- Saber cuánta potencia necesita de una cámara un núcleo de inteligencia y un núcleo de inteligencia emocional.

#### Escenario de prueba
- El núcleo de inteligencia base tiene esfuerzo 5 y memoria 40. Necesita de la **Cámara 01** una potencia de **150**: `30 * 5`, y aporta una capacidad de resolver problemas de **60**: `5 * 40 / 10 + 40`.
- El núcleo de ira, que es un núcleo de inteligencia emocional de esfuerzo 5, memoria 40 y emocionalidad -30, necesita de la **Cámara 01** una potencia de **150** y aporta una capacidad de **50**: `2 * (5 * 40 / 10) + 40 - 30`.

## 2: Robots superando cámaras

Un **robot** tiene una colección de núcleos de personalidad acoplados y los utiliza para superar el desafío de una cámara de pruebas. 

Para que un robot pueda **superar** una cámara deben cumplirse dos condiciones:
- La **dificultad** del desafío de la cámara es menor o igual a la **capacidad de resolver problemas** del robot, que se calcula como 
 la suma de las capacidades de resolver problemas de todos sus núcleos.
- La **potencia que necesita** el robot de la cámara es menor o igual que la potencia disponible en la misma. La potencia que un robot
necesita es igual a la máxima potencia de las que necesitan sus núcleos.

Si el robot supera el desafío de la cámara, todos sus núcleos se usan y se producen los siguientes efectos:
- Si el núcleo de moralidad estaba corrupto, vuelve a estar normal, como si nunca se hubiera usado.
- A la tercera vez que se usa un núcleo de moralidad normal, se corrompe.
- Un núcleo de inteligencia aumenta su memoria en 10 unidades.
- Un núcleo de inteligencia emocional aumenta su memoria en 10 unidades y además su emocionalidad aumenta en 2.
- Es importante registrar las cámaras que un robot superó.

#### Requerimientos
- Que un robot supere el desafío de una cámara (teniendo en cuenta las validaciones necesarias y los efectos en sus núcleos).
- Saber todas las cámaras que superó un robot (sin repetidos).
- Saber la historia de superación de las cámaras de un robot, en el orden en que las superó (Podría aparecer repetidos si un robot superó el desafío más de una vez).

#### Escenario de prueba
**Dors** es una robot que tiene acoplados el núcleo de moralidad, el núcleo de inteligencia y el núcleo de ira de los ejemplos anteriores. Además de la **Cámara 01**, se usan:
- la **Cámara 02**, de dificultad 300 y potencia disponible de 200.
- la **Cámara 03**, de dificultad 100 y potencia disponible de 140.
- la **Cámara 04**, de dificultad 140 y potencia disponible de 200.

Probar la siguiente secuencia (entre paréntesis, la explicación de cada resultado):

1. Dors intenta superar la **Cámara 02**. No puede. (Su capacidad es 160: `50 + 60 + 50`, y la dificultad es 300.)
2. Dors intenta superar la **Cámara 03**. No puede. (Necesita una potencia de 150, el máximo entre `8`, `150` y `150`, y la cámara solo tiene disponible 140.)
3. Dors supera la **Cámara 01**. Puede. (La dificultad es 100 y la cámara tiene disponible 160.) Su capacidad pasa a ser 247: `100 + 75 + 72`.
4. Dors intenta superar la **Cámara 02** otra vez. Sigue sin poder. (300 es mayor que 247.)
5. Dors supera la **Cámara 04**. Puede. Su capacidad pasa a ser 334: `150 + 90 + 94`.
6. Dors supera la **Cámara 02**. Ahora sí puede, porque 300 no supera 334. Pero es el tercer uso del núcleo de moralidad, que se corrompe al superar la cámara, y la capacidad de Dors baja a 261: `40 + 105 + 116`.
7. Dors intenta superar la **Cámara 02**. No puede. (La corrupción le bajó la capacidad: 300 es mayor que 261.)
8. Dors supera la **Cámara 01**. Puede. (El núcleo de moralidad corrupto necesita el 100% de la potencia de la cámara, 160, que es justo lo que tiene disponible.) El núcleo de moralidad vuelve a estar normal y la capacidad de Dors pasa a ser 308: `50 + 120 + 138`.
9. Dors supera la **Cámara 02**. Puede, porque 300 no supera 308.

Verificar que las cámaras que superó Dors son la **Cámara 01**, la **Cámara 04** y la **Cámara 02**, y que su historia de superación es: **Cámara 01**, **Cámara 04**, **Cámara 02**, **Cámara 01**, **Cámara 02**.

## 3: Consultas sobre la empresa

Una **empresa** tiene una colección de robots, y se necesita resolver ciertas consultas.

#### Requerimientos
- Los **núcleos más hábiles**: de cada robot se selecciona el núcleo que le aporte más capacidad para resolver problemas.
- La **cantidad de robots** que han superado alguna vez una cámara en particular.
- Si una cámara es **imposible** para la empresa: es imposible si ningún robot la puede superar.

#### Escenario de prueba
**Fundación** es una empresa que tiene a **Dors** y a **Daneel**, un robot con un único núcleo de inteligencia de esfuerzo 2 y memoria 100, es decir, con una capacidad de **120** y una potencia necesaria de **60**. Se usan las **Cámaras 01, 02, 03 y 04** de los puntos anteriores.

Verificar que, al inicio:
- Los núcleos más hábiles son el núcleo de inteligencia de Dors (aporta 60, más que los 50 de la moralidad y de la ira) y el único núcleo de Daneel.
- Ningún robot superó la **Cámara 01** todavía.
- La **Cámara 02** es imposible para la empresa: Dors tiene capacidad 160 y Daneel 120, y la dificultad es 300. En cambio, la **Cámara 01** y la **Cámara 04** no lo son: Dors puede superarlas.

Luego, Dors supera la **Cámara 04** y la **Cámara 01**. Verificar que:
- Los núcleos más hábiles ahora son el núcleo de moralidad de Dors (aporta 150, porque se usó 2 veces) y el único núcleo de Daneel.
- Un solo robot (Dors) superó la **Cámara 01** y un solo robot superó la **Cámara 04**, mientras que ninguno superó la **Cámara 03**.
- La **Cámara 02** ya no es imposible: la capacidad de Dors creció a 334 con el uso.

Por último, Daneel supera la **Cámara 01**. Verificar que ahora son dos los robots que superaron la **Cámara 01**, mientras que sigue siendo uno solo el que superó la **Cámara 04**.
