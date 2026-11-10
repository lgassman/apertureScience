# Aperture Science

*Aperture Science* es una empresa ficticia del videojuego **Portal**: un enorme complejo de investigación donde se hacen experimentos en **cámaras de pruebas**, salas con desafíos que hay que resolver. El complejo está controlado por **agentes**: inteligencias artificiales, como la famosa **GLaDOS**. Hay muchos agentes en Aperture Science, y cada uno tiene sus propios núcleos.

Un agente no piensa solo. Tiene acoplados varios **núcleos de personalidad**, módulos que modifican su manera de pensar y, con ella, su **capacidad de resolver problemas**. Algunos núcleos lo vuelven más moral, otros más inteligente y otros, directamente, más furioso. Cada cámara exige una cierta **potencia energética** para comenzar a usarse, y cada núcleo la aprovecha a su manera. Además, con el uso, los núcleos cambian.

Como técnico de software en Aperture Science, tu trabajo será implementar el sistema que permita a los agentes conocer su capacidad de resolver problemas y utilizar las cámaras de pruebas.
Por una satisfactoria implementación de los sistemas, se te recompensará con torta.

## Aclaraciones para el Parcial
- El parcial es **individual**. Este es el enunciado de la parte domiciliaria. El código debe estar pusheado en el repositorio a modo de backup
pero la entrega oficial se realiza en papel al resolver la parte presencial
- Se evalúa el polimorfismo, delegación, buenas abstracciones, evitar lógica repetida, guardar vs. calcular, y lanzar excepciones cuando un método no puede cumplir con su responsabilidad.

## 1: Núcleos de personalidad, agentes y cámaras

Una **cámara de pruebas** es una habitación donde se realizan experimentos. De cada cámara se conoce su **dificultad** y la **potencia energética exigible** al momento de comenzar a usarse.

Un **agente** tiene varios **núcleos de personalidad** que utiliza para usar una cámara de pruebas.

Todo núcleo de personalidad aporta a un agente una cierta **capacidad de resolver problemas** (un número) y, al momento de usar una cámara, **exige** una cierta **potencia energética** (otro número).

En todos los escenarios de prueba de este punto se usa la **Cámara 01**, de dificultad 200 y potencia exigible 100.

### 1.1: Núcleo de Moralidad

Un núcleo de moralidad puede estar **normal** o **corrupto**. Todo núcleo de moralidad se crea normal y sin haberse usado nunca.

- **Capacidad de resolver problemas:** si está normal, es 50 de base más 50 por cada vez que se ha usado: `50 * (1 + veces usadas)`. Si está corrupto, solo aporta `40`, sin importar cuántas veces se ha utilizado.
- **Potencia que exige:** si está normal, es un porcentaje de la potencia exigible de la cámara. Si nunca se usó es el 5%, y cada uso hace que exija un 1% menos: `(5 - veces usadas)%`. Si está corrupto, siempre exige el 100% de la potencia exigible de la cámara, sin importar cuántas veces se ha utilizado.

**Nota:** Se espera una solución polimórfica. Las soluciones basadas en booleanos para modelar el estado de corrupción serán castigadas.

#### Requerimientos
- Saber la capacidad de resolver problemas de un núcleo de moralidad.
- Saber cuánta potencia le exige a una cámara un núcleo de moralidad.

#### Escenario de prueba
Un núcleo de moralidad nuevo:
- aporta una capacidad de resolver problemas de **50**: `50 * (1 + 0)`.
- le exige a la **Cámara 01** una potencia de **5**: el 5% de 100.

### 1.2: Núcleo de Inteligencia y Núcleo de Inteligencia Emocional

Un **núcleo de inteligencia** se conoce por dos datos: su **optimización** (un número entre 0 y 1) y su **memoria**.

- **Potencia que exige:** `optimización * memoria`. Es un valor absoluto, no un porcentaje: no depende de la cámara.
- **Velocidad de pensamiento:** es 3 veces la potencia que exige: `3 * optimización * memoria`.
- **Capacidad de resolver problemas:** `velocidad de pensamiento + memoria`.

El **núcleo de inteligencia emocional** es un tipo especial de núcleo de inteligencia:
- Su velocidad de pensamiento es el **doble** de la que tendría un núcleo de inteligencia con los mismos datos.
- Además se conoce su **emocionalidad** (otro número), que le suma o resta capacidad de resolver problemas. Por ejemplo, un núcleo emocional que modele la ira tendrá la emocionalidad en negativo, mientras que otro basado en la intuición la tendrá en positivo.
- Por lo tanto, su capacidad de resolver problemas es `2 * 3 * optimización * memoria + memoria + emocionalidad`.
- La potencia que exige es igual a la de un núcleo de inteligencia: `optimización * memoria`.

**Nota:** es posible que la capacidad de resolver problemas sea negativa, sin que eso se considere un problema. Se espera además una solución que no duplique código.

#### Requerimientos
- Saber la capacidad de resolver problemas de un núcleo de inteligencia y de un núcleo de inteligencia emocional.
- Saber cuánta potencia le exige a una cámara un núcleo de inteligencia y un núcleo de inteligencia emocional.

#### Escenario de prueba
- Un núcleo de inteligencia de optimización 0.5 y memoria 40 le exige a la **Cámara 01** una potencia de **20**: `0.5 * 40`, y aporta una capacidad de resolver problemas de **100**: `3 * 20 + 40`.
- Un núcleo de ira, que es un núcleo de inteligencia emocional de optimización 0.5, memoria 40 y emocionalidad -30, le exige a la **Cámara 01** una potencia de **20** y aporta una capacidad de **130**: `2 * 3 * 20 + 40 - 30`.

### 1.3: Agentes

Un agente tiene una colección de núcleos de personalidad acoplados.
- Su capacidad de resolver problemas es la **suma** de las capacidades de todos sus núcleos.
- La potencia que le exige a una cámara es la **mayor** potencia que exige alguno de sus núcleos a esa cámara.
- Un agente **puede utilizar** una cámara si la dificultad de la cámara es menor o igual que su capacidad de resolver problemas, y la potencia que exige a la cámara es menor o igual a la potencia exigible de la cámara.

#### Requerimientos
- Incorporar un núcleo de personalidad a un agente.
- Saber la capacidad de resolver problemas de un agente.
- Saber la potencia que un agente le exige a una cámara.
- Saber si un agente puede utilizar una cámara.

#### Escenario de prueba
**GLaDOS** es un agente que tiene acoplados el núcleo de moralidad, el núcleo de inteligencia y el núcleo de ira de los ejemplos anteriores.
- Su capacidad de resolver problemas es **280**: `50 + 100 + 130`.
- Le exige a la **Cámara 01** una potencia de **20**: el máximo entre `5`, `20` y `20`.
- Puede utilizar la **Cámara 01**: 200 es menor que 280 y 20 es menor que 100.
- No puede utilizar la **Cámara 02** (dificultad 450 y potencia exigible 100), porque 450 es mayor que 280.
- No puede utilizar la **Cámara 03** (dificultad 100 y potencia exigible 15), porque necesita exigir 20 y la cámara solo admite 15.

## 2: Utilizar cámaras

Cuando un agente **utiliza** una cámara, debe cumplirse que **pueda hacerlo** según lo explicado en el punto anterior. Si no puede, no debe ocurrir ningún cambio.

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
Se usan **GLaDOS** y las **Cámaras 01, 02 y 03** de los puntos anteriores, y una **Cámara 04** de dificultad 300 y potencia exigible 100. Probar la siguiente secuencia:

1. GLaDOS utiliza la **Cámara 01**. Su capacidad de resolver problemas pasa a ser **397**: `100 + 125 + 172`.
2. GLaDOS intenta utilizar la **Cámara 02**. No puede, porque su dificultad es 450. Su capacidad sigue siendo 397.
3. GLaDOS intenta utilizar la **Cámara 03**. No puede, porque ahora exige una potencia de 25 y la cámara solo admite 15. Su capacidad sigue siendo 397.
4. GLaDOS utiliza la **Cámara 04**. Su capacidad pasa a ser **514**: `150 + 150 + 214`.
5. GLaDOS utiliza la **Cámara 01**. Es el tercer uso del núcleo de moralidad, que se corrompe, por lo que la capacidad de GLaDOS pasa a ser **471**: `40 + 175 + 256`. Ahora le exige a la **Cámara 01** una potencia de **100**, el 100% de su potencia exigible.
6. GLaDOS utiliza la **Cámara 01** otra vez. Puede, porque la potencia que exige (100) es igual a la admitida. El núcleo de moralidad vuelve a estar normal y la capacidad de GLaDOS pasa a ser **548**: `50 + 200 + 298`. Ahora le exige a la **Cámara 01** una potencia de **40**.

Verificar que las cámaras que usó GLaDOS son la **Cámara 01** y la **Cámara 04**, y que su historia de uso es: Cámara 01, Cámara 04, Cámara 01, Cámara 01.

## 3: Consultas sobre Aperture Science

La empresa **Aperture Science** tiene una colección de agentes. Los científicos quieren saber:

- Los agentes que pueden utilizar una cámara determinada.
- Si todos los agentes pueden utilizar una cámara determinada.
- Un agente que haya utilizado una cámara determinada (¿qué debería pasar si ninguno la utilizó?).
- Todas las cámaras que utilizó algún agente (sin repetidos).

#### Requerimientos
- Incorporar un agente a la empresa.
- Resolver las cuatro consultas anteriores.

#### Escenario de prueba
Aperture Science tiene a **GLaDOS** (con los tres núcleos del punto 1.3, sin haber utilizado cámaras) y a **Wheatley**, un agente con un único núcleo de inteligencia de optimización 0.8 y memoria 30, es decir, una capacidad de **102** y una potencia exigida de **24**. Hay tres cámaras de potencia exigible 100: la **fácil** (dificultad 90), la **media** (dificultad 200) y la **imposible** (dificultad 500).

Verificar que:
- El único agente que puede utilizar la cámara **media** es GLaDOS, porque la capacidad de Wheatley es 102.
- Todos los agentes pueden utilizar la cámara **fácil**, pero no todos pueden utilizar la **media**.

Luego, GLaDOS utiliza la cámara **media** y la **fácil**, y Wheatley utiliza la **fácil**. Verificar que:
- El agente que utilizó la cámara **media** es GLaDOS.
- No se puede encontrar un agente que haya utilizado la cámara **imposible**.
- Las cámaras que utilizó algún agente son la **media** y la **fácil**.
