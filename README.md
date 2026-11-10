# Aperture Science

*Aperture Science* es una empresa ficticia del videojuego **Portal**: un enorme complejo de investigación donde se hacen experimentos en **cámaras de pruebas**, salas con desafíos que hay que resolver. El complejo está controlado por **agentes**: inteligencias artificiales, como la famosa **GLaDOS**. Hay muchos agentes en Aperture Science, y cada uno tiene sus propios núcleos.

Un agente no piensa solo. Tiene acoplados varios **núcleos de personalidad**, módulos que modifican su manera de pensar y, con ella, su **capacidad de resolver problemas**. Algunos núcleos lo vuelven más moral, otros más inteligente y otros más emocionales. Cada cámara exige una cierta **potencia energética** para comenzar a usarse, y cada núcleo la aprovecha a su manera. Además, con el uso, los núcleos cambian.

Como técnico de software en Aperture Science, tu trabajo será implementar el sistema que permita a los agentes conocer su capacidad de resolver problemas y utilizar las cámaras de pruebas.

## Aclaraciones para el Parcial
- El parcial es **individual**. Este es el enunciado de la parte domiciliaria. El código debe estar pusheado en el repositorio a modo de backup
pero la entrega oficial se realiza en papel al resolver la parte presencial
- Se evalúa el polimorfismo, delegación, buenas abstracciones, evitar lógica repetida, guardar vs. calcular, y lanzar excepciones cuando un método no puede cumplir con su responsabilidad.

## 1: Núcleos de personalidad, agentes y cámaras

Una **cámara de pruebas** es una habitación donde se realizan experimentos. De cada cámara se conoce su **dificultad**. Además cada cámara ofrece energía a los agentes: La **potencia energética exigible** es la potencia máxima que puede ofrecer esa cámara. Este número se indica para cada cámara.

Un **agente** tiene varios **núcleos de personalidad** que utiliza al usar una cámara de pruebas.

Todo núcleo de personalidad aporta a un agente una cierta **capacidad de resolver problemas** (un número) y, al momento de usar una cámara, exige una cierta **potencia energética** (otro número).


### 1.1: Núcleo de Moralidad

Un núcleo de moralidad puede estar **normal** o **corrupto**. 

- **Capacidad de resolver problemas:** si está normal, es 50 de base más 50 por cada vez que se ha usado: `50 * (1 + veces usadas)`. Si está corrupto, solo aporta `40`, sin importar cuántas veces se ha utilizado.
- **Potencia que exige:** si está normal, es un porcentaje de la potencia exigible de la cámara. Si nunca se usó es el 5%, y cada uso hace que exija un 1% menos: `(5 - veces usadas)%`. Si está corrupto, siempre exige el 100% de la potencia exigible de la cámara, sin importar cuántas veces se ha utilizado.

**Nota:** Se espera una solución polimórfica. Las soluciones basadas en booleanos para modelar el estado de corrupción serán castigadas.

#### Requerimientos
- Saber la capacidad de resolver problemas de un núcleo de moralidad.
- Saber cuánta potencia le exige a una cámara un núcleo de moralidad.

#### Escenario de prueba
La **Cámara 01** tiene dificultad 100 y potencia exigible 160.

Un núcleo de moralidad nuevo, que nunca se usó:
- aporta una capacidad de resolver problemas de **50**: `50 * (1 + 0)`.
- le exige a la **Cámara 01** una potencia de **8**: el 5% de 160.

Si ese mismo núcleo se hubiera usado 2 veces:
- aporta una capacidad de resolver problemas de **150**: `50 * (1 + 2)`.
- le exige a la **Cámara 01** una potencia de **4.8**: el `(5 - 2)%` de 160.

Pero si ese núcleo está corrupto, entonces:
- aporta una capacidad de resolver problemas de **40**, sin importar cuántas veces se usó.
- le exige a la **Cámara 01** una potencia de **160**: el 100% de 160.

### 1.2: Núcleo de Inteligencia y Núcleo de Inteligencia Emocional

De un **núcleo de inteligencia** interesa su **esfuerzo** y su **memoria**. Ambos son números que se indican para cada núcleo de inteligencia y determinan la **velocidad de pensamiento**: `esfuerzo * memoria / 10`.

La **capacidad de resolver problemas** es la suma de la velocidad de pensamiento y la memoria: `velocidad + memoria`.

Mientras que la **potencia que exige** a una cámara es de `30 * esfuerzo`.

El **núcleo de inteligencia emocional** es una especie de núcleo de inteligencia con algunas particularidades:
- Su velocidad de pensamiento es el **doble** de la que tendría un núcleo de inteligencia con los mismos datos.
- Además se conoce su **emocionalidad** (otro número), que le suma o resta capacidad de resolver problemas. Por ejemplo, un núcleo emocional que modele la ira tendrá la emocionalidad en negativo, mientras que otro basado en la intuición la tendrá en positivo.
- Por lo tanto, su **capacidad de resolver problemas** es `2 * ( esfuerzo * memoria / 10)  + memoria + emocionalidad`.
- La potencia que exige es igual a la de un núcleo de inteligencia: `30 * esfuerzo`.

**Nota:** es posible que la capacidad de resolver problemas sea negativa, sin que eso se considere un problema. Se espera además una solución que no duplique código.

#### Requerimientos
- Saber la capacidad de resolver problemas de un núcleo de inteligencia y de un núcleo de inteligencia emocional.
- Saber cuánta potencia le exige a una cámara un núcleo de inteligencia y un núcleo de inteligencia emocional.

#### Escenario de prueba
- El núcleo de inteligencia base tiene esfuerzo 5 y memoria 40. Le exige a la **Cámara 01** una potencia de **150**: `30 * 5`, y aporta una capacidad de resolver problemas de **60**: `5 * 40 / 10 + 40`.
- El núcleo de ira, que es un núcleo de inteligencia emocional de esfuerzo 5, memoria 40 y emocionalidad -30, le exige a la **Cámara 01** una potencia de **150** y aporta una capacidad de **50**: `2 * (5 * 40 / 10) + 40 - 30`.

## 2: Agentes usando cámaras

Un **agente** tiene una colección de núcleos de personalidad acoplados y los utiliza para usar una cámara de pruebas.

Para que un agente pueda **utilizar** una cámara deben cumplirse dos condiciones:
- La **dificultad** de la cámara es menor o igual que la **capacidad de resolver problemas** del agente, que es la suma de las capacidades de todos sus núcleos.
- La **potencia que exige** el agente a la cámara es menor o igual que la potencia exigible de la cámara. El agente exige la mayor de las potencias que exigen sus núcleos a esa cámara.

Si el agente no puede utilizar la cámara, no debe ocurrir ningún cambio.

Si puede, utiliza todos sus núcleos, teniendo estos efectos:
- Si el núcleo de moralidad estaba corrupto, vuelve a estar normal, como si nunca se hubiera usado (el agente corre su propia rutina de rescate).
- A la tercera vez que se usa un núcleo de moralidad normal, se corrompe.
- Un núcleo de inteligencia aumenta su memoria en 10 unidades.
- Un núcleo de inteligencia emocional aumenta su memoria en 10 unidades y además su emocionalidad aumenta en 2.

Además, cada agente recuerda las cámaras que utilizó.

#### Requerimientos
- Que un agente utilice una cámara (teniendo en cuenta las validaciones necesarias y los efectos en sus núcleos).
- Saber todas las cámaras que utilizó un agente (sin repetidos).
- Saber la historia de uso de las cámaras de un agente, en el orden en que las usó (con repetidos).

#### Escenario de prueba
**GLaDOS** es un agente que tiene acoplados el núcleo de moralidad, el núcleo de inteligencia y el núcleo de ira de los ejemplos anteriores. Además de la **Cámara 01**, se usan:
- la **Cámara 02**, de dificultad 300 y potencia exigible 200.
- la **Cámara 03**, de dificultad 100 y potencia exigible 140.
- la **Cámara 04**, de dificultad 140 y potencia exigible 200.

Probar la siguiente secuencia (entre paréntesis, la explicación de cada resultado):

1. GLaDOS intenta utilizar la **Cámara 02**. No puede. (Su capacidad es 160: `50 + 60 + 50`, y la dificultad es 300.)
2. GLaDOS intenta utilizar la **Cámara 03**. No puede. (Exige una potencia de 150, el máximo entre `8`, `150` y `150`, y la cámara solo admite 140.)
3. GLaDOS utiliza la **Cámara 01**. Puede. (La dificultad es 100 y la cámara admite 160.) Su capacidad pasa a ser 247: `100 + 75 + 72`.
4. GLaDOS intenta utilizar la **Cámara 02** otra vez. Sigue sin poder. (300 es mayor que 247.)
5. GLaDOS utiliza la **Cámara 04**. Puede. Su capacidad pasa a ser 334: `150 + 90 + 94`.
6. GLaDOS utiliza la **Cámara 02**. Ahora sí puede, porque 300 no supera 334. Pero es el tercer uso del núcleo de moralidad, que se corrompe, y la capacidad de GLaDOS baja a 261: `40 + 105 + 116`.
7. GLaDOS intenta utilizar la **Cámara 02**. No puede. (La corrupción le bajó la capacidad: 300 es mayor que 261.)
8. GLaDOS utiliza la **Cámara 01**. Puede. (El núcleo de moralidad corrupto exige el 100% de la potencia de la cámara, 160, que es justo lo que admite.) El núcleo de moralidad vuelve a estar normal y la capacidad de GLaDOS pasa a ser 308: `50 + 120 + 138`.
9. GLaDOS utiliza la **Cámara 02**. Puede, porque 300 no supera 308.

Verificar que las cámaras que usó GLaDOS son la **Cámara 01**, la **Cámara 04** y la **Cámara 02**, y que su historia de uso es: Cámara 01, Cámara 04, Cámara 02, Cámara 01, Cámara 02.

## 3: Consultas sobre la empresa

Una **empresa** tiene una colección de agentes. Los científicos necesitan información sobre la empresa.

#### Requerimientos
- Los **núcleos más hábiles**: de cada agente me quedo con el núcleo que le aporte más capacidad para resolver problemas.
- La **cantidad de agentes** que han utilizado alguna vez una cámara.
- Si una cámara es **imposible** para la empresa: es imposible si ningún agente la puede utilizar.

#### Escenario de prueba
**Aperture Science** es una empresa que tiene a **GLaDOS** y a **Wheatley**, un agente con un único núcleo de inteligencia de esfuerzo 2 y memoria 100, es decir, con una capacidad de **120** y una potencia exigida de **60**. Se usan las **Cámaras 01, 02, 03 y 04** de los puntos anteriores.

Verificar que, al inicio:
- Los núcleos más hábiles son el núcleo de inteligencia de GLaDOS (aporta 60, más que los 50 de la moralidad y de la ira) y el único núcleo de Wheatley.
- Ningún agente utilizó una cámara todavía.
- La **Cámara 02** es imposible para la empresa: GLaDOS tiene capacidad 160 y Wheatley 120, y la dificultad es 300. En cambio, la **Cámara 01** y la **Cámara 04** no lo son: GLaDOS puede utilizarlas.

Luego, GLaDOS utiliza la **Cámara 04** y la **Cámara 01**. Verificar que:
- Los núcleos más hábiles ahora son el núcleo de moralidad de GLaDOS (aporta 150, porque se usó 2 veces) y el único núcleo de Wheatley.
- Un agente utilizó alguna cámara.
- La **Cámara 02** ya no es imposible: la capacidad de GLaDOS creció a 334 con el uso.

Por último, Wheatley utiliza la **Cámara 03**. Verificar que ahora son dos los agentes que utilizaron alguna cámara.
