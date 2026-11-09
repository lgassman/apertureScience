# Aperture Science

*Aperture Science* es una empresa ficticia del videojuego **Portal**: un enorme complejo de investigación donde se hacen experimentos en **cámaras de pruebas**, salas con desafíos que hay que resolver. Todo el complejo está controlado por **GLaDOS**, una inteligencia artificial.

GLaDOS no piensa sola. Tiene acoplados varios **núcleos de personalidad**, módulos que modifican su manera de pensar y, con ella, su **capacidad de resolver problemas**. Algunos núcleos la vuelven más moral, otros más inteligente y otros, directamente, más furiosa. Usar las cámaras tiene un costo: los núcleos consumen **energía** mientras GLaDOS trabaja y, con el uso, cambian.

Como técnico de software en Aperture Science, tu trabajo será implementar el sistema que permita a GLaDOS conocer su capacidad de resolver problemas y utilizar las cámaras de pruebas.
Por una satisfactoria implementación de los sistemas, se te recompensará con torta.

## Aclaraciones para el Parcial
- El parcial es **individual** y se entrega **pusheando a este repositorio**.
- No se considerarán commits realizados después de la hora de finalización del examen.
- Asegurate que la versión final esté subida en GitHub.
- Se evalúa el polimorfismo, delegación, buenas abstracciones, evitar lógica repetida, guardar vs. calcular, y lanzar excepciones cuando un método no puede cumplir con su responsabilidad.
- **Está prohibido usar booleanos** (ni ningún otro tipo de marca equivalente) para saber si un núcleo está o no corrupto.

## 1: Los Núcleos de Personalidad y la capacidad de resolver problemas

Todo núcleo de personalidad aporta a GLaDOS una cierta **capacidad de resolver problemas** (un número). Además, cada vez que GLaDOS utiliza una cámara, todos sus núcleos son **usados**, y ese uso puede cambiarlos.

### 1.1: Núcleo de Moralidad

- Un núcleo de moralidad aporta una capacidad de resolver problemas de **100**.
- Con el tiempo, un núcleo de moralidad puede corromperse. Un núcleo corrupto ofrece soluciones ilegales y poco factibles, por lo que aporta solamente la mitad de capacidad: **50**.
- Un núcleo de moralidad se corrompe cuando es usado por tercera vez. Una vez corrupto, así queda.

#### Requerimientos
- Saber la capacidad de resolver problemas de un núcleo de moralidad.
- Usar un núcleo de moralidad.

#### Escenario de prueba
Un núcleo de moralidad recién creado aporta **100**. Después de usarlo dos veces, sigue aportando **100**. Al usarlo por tercera vez pasa a aportar **50**, y si se lo vuelve a usar, sigue aportando **50**.

### 1.2: Núcleo de Inteligencia y Núcleo de Ira

Un **núcleo de inteligencia** se conoce por dos factores, la **velocidad de pensamiento** y la **memoria**, y aporta una capacidad de resolver problemas igual a su `velocidad de pensamiento * memoria`.
Cada vez que se lo usa aprende de sus decisiones, por lo que su memoria aumenta en 1.

El **núcleo de ira** es un tipo especial de núcleo de inteligencia:
- Su velocidad de pensamiento es el **doble** de la que tendría un núcleo de inteligencia con los mismos datos.
- Además se conoce su **emocionalidad** (otro número), que le resta capacidad de resolver problemas, porque la furia le impide tomar buenas decisiones: su aporte es el que tendría un núcleo de inteligencia con esa velocidad, menos su emocionalidad.
- En todo lo demás se comporta como un núcleo de inteligencia.

#### Requerimientos
- Saber la capacidad de resolver problemas de un núcleo de inteligencia y de un núcleo de ira.
- Usar un núcleo de inteligencia y un núcleo de ira.

#### Escenario de prueba
- Un núcleo de inteligencia de velocidad 10 y memoria 8 aporta **80**: `10 * 8`. Luego de usarlo aporta **90**: `10 * 9`.
- Un núcleo de ira de velocidad 10, memoria 8 y emocionalidad 100 aporta **60**: `(10 * 2) * 8 - 100`. Luego de usarlo aporta **80**: `(10 * 2) * 9 - 100`.

### 1.3: GLaDOS

GLaDOS tiene una colección de núcleos de personalidad acoplados. Su capacidad de resolver problemas es la suma de las capacidades de todos sus núcleos.

#### Requerimientos
- Incorporar un núcleo de personalidad a GLaDOS.
- Saber la capacidad de resolver problemas de GLaDOS.

#### Escenario de prueba
GLaDOS tiene acoplados un núcleo de moralidad, el núcleo de inteligencia (velocidad 10 y memoria 8) y el núcleo de ira (velocidad 10, memoria 8 y emocionalidad 100) de los ejemplos anteriores. Su capacidad de resolver problemas es **240**: `100 + 80 + 60`.

## 2: Las Cámaras de Pruebas y la energía

Las **cámaras de pruebas** son las salas donde GLaDOS lleva a cabo los experimentos. De cada una se conoce:
- su **nivel** de dificultad (un número) y
- los **segundos** que GLaDOS necesita para utilizarla.

Además, GLaDOS tiene una cantidad de **energía** disponible, y cada núcleo sabe cuánta energía consume **por segundo**:
- Un núcleo de moralidad consume **10** por segundo, o **30** si está corrupto.
- Un núcleo de inteligencia consume tanta energía por segundo como su velocidad de pensamiento.

La energía que consume GLaDOS por segundo es la suma de lo que consume cada uno de sus núcleos.

### Utilizar una cámara

Cuando GLaDOS utiliza una cámara:
- Su energía disminuye en la energía por segundo que consumen sus núcleos multiplicada por los segundos de la cámara.
- Todos sus núcleos son **usados**.

Para poder utilizar una cámara, GLaDOS necesita tener energía suficiente para cubrir ese gasto, y además el nivel de la cámara debe ser **inferior** a su capacidad de resolver problemas.

#### Requerimientos
- Saber cuánta energía consume GLaDOS por segundo.
- Que GLaDOS utilice una cámara de pruebas.

#### Escenario de prueba
GLaDOS tiene **5000** de energía y los tres núcleos del punto anterior. Probar la siguiente secuencia:

1. GLaDOS consume **40** por segundo: `10 + 10 + 20`, porque el núcleo de ira piensa al doble de velocidad.
2. Utiliza una cámara de nivel 200 y 30 segundos. Puede hacerlo: su capacidad es 240 y gasta `40 * 30 = 1200`. Queda con **3800** de energía y su capacidad de resolver problemas pasa a ser **270**: `100 + 90 + 80`.
3. Intenta utilizar una cámara de nivel 300 y 10 segundos. No puede, porque 300 no es inferior a 270. Su energía y su capacidad no cambian.
4. Utiliza una cámara de nivel 250 y 20 segundos. Gasta `40 * 20 = 800`. Queda con **3000** de energía.
5. Utiliza una cámara de nivel 100 y 25 segundos. Gasta `40 * 25 = 1000`. Queda con **2000** de energía. Con este tercer uso el núcleo de moralidad se corrompió: ahora GLaDOS consume **60** por segundo (`30 + 10 + 20`) y su capacidad de resolver problemas es **280**: `50 + 110 + 120`.
6. Intenta utilizar una cámara de nivel 200 y 40 segundos. No puede, porque necesitaría `60 * 40 = 2400` de energía y tiene 2000. Su energía y su capacidad no cambian.
