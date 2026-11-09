# Aperture Science
Como técnico de software en Aperture Science, tu trabajo será implementar los sistemas de calibración de las cámaras de pruebas y los núcleos de personalidad de forma que estos puedan ser controlados por el Sistema Operativo en Disco y Forma de Vida Genética (GLaDOS).
Por una satisfactoria implementación de los sistemas, se le recompensará con torta.

## Aclaraciones para el Parcial
- El parcial es **individual** y se entrega **pusheando a este repositorio**.
- No se considerarán commits realizados después de la hora de finalización del examen.
- Asegurate que la versión final esté subida en GitHub.
- Se evalúa el polimorfismo, delegación, buenas abstracciones, evitar lógica repetida, guardar vs. calcular, y lanzar excepciones cuando un método no puede cumplir con su responsabilidad.

## 1: Los Núcleos de Personalidad y su energía.
De los núcleos de personalidad se conoce su **temperatura (°C)** e interesa saber cuántos watts diarios requieren para recargarse:

- Los núcleos **estándar** (Encargados del mantenimiento general de las instalaciones) requieren 25W por cada grado de temperatura: `temperatura * 25`.
- Aquellos núcleos que están **corruptos** requieren como máximo 3000W. A ese valor base se le multiplica su nivel de corrupción (Número entre 0 y 1). Los núcleos más inestables demandan más watts por los picos de energía que tienen. Un nivel de corrupción bajo significa que están más estables y consumen menos watts. La corrupción se indica para cada núcleo corrupto. La fórmula de consumo diario es: `3000 * corrupción`.
- El núcleo **Central** consume 500W si su temperatura supera los 70 °C, y 300W si no.

Cada vez que pasa un día en las instalaciones, los núcleos recargan sus baterías de reserva usando los watts requeridos, y su temperatura aumenta en la cantidad de watts consumidos dividido entre 10000: `watts/10000`. Un núcleo central, al tener un mejor sistema de refrigeración, sólo aumenta su temperatura dividiendo los watts por 50000: `watts/50000`. 

Además, los núcleos corruptos disminuyen su nivel de corrupción en 0.01, pero nunca por debajo de 0.2: `(corrupción - 0.01) ó 0.2`.

### Requerimientos
- Saber los watts diarios que consume un núcleo.
- Que un núcleo consuma sus watts diarios.

### Escenario de prueba:

Núcleos:
  - El **Núcleo de Moralidad** es un Núcleo estándar de temperatura 100°C.
  - El **Núcleo del Espacio** es un núcleo corrupto de temperatura 90°C y 0.5 de corrupción.
  - **GLaDOS** es el Núcleo Central de Temperatura 80°C.

Verificaciones:
 - Los watts diarios que consume el **Núcleo de Moralidad** son **2500** : `100 * 25` y al recargarse queda con **100.25** de temperatura: `100 + 2500 / 10000`.
 - Los watts diarios que consume el **Núcleo del Espacio** son **1500** : `3000 * 0.5` y al recargarse queda con **90.15** de temperatura: `90 + 1500 / 10000` y 0.49 de corrupción `0.5 - 0.01`.
 - Los watts diarios que consume **GLaDOS** son **500** : `80 >= 70` y al recargarse queda con **80.01** de temperatura: `80 + 500 / 50000`
 - El **Núcleo de los Hechos** que es como el **Núcleo del Espacio** pero su corrupción es de: `0.2` y luego de recargar su batería de reserva, sus watts a consumir siguen siendo **600**: `3000 * 0.2` ya que la corrupción no puede bajar de **0.2**.

## 2: Las Cámaras de Pruebas

### 2.1: Suministro Energético

Las cámaras de pruebas son sectores modulares donde se llevan a cabo los experimentos dentro de Aperture Science.

En cada cámara hay un generador con una reserva de **energía** (medida en watts).
Esta cantidad debe ser suficiente para abastecer a todos los núcleos asignados a la cámara cada vez que deban recargar sus baterías (lo hacen una vez al día).
Cuando se recargan, lo hacen todos los núcleos asignados en grupo, y la reserva del generador disminuye en la cantidad consumida por todos ellos (es decir, la sumatoria de los watts diarios demandados por los núcleos de la cámara).
Cuidado. Si la reserva no alcanza para cubrir la demanda total, entonces no se puede realizar la recarga y ningún núcleo debe modificar su estado.

#### Requerimientos
- Recargar todos los núcleos de una cámara de pruebas.
- Abastecer con más watts de energía al generador de la cámara de pruebas.

#### Caso de ejemplo:
La **Cámara 01**, tiene asignados al **Núcleo de Moralidad** y el **Núcleo del Espacio**. 
Tiene una reserva de **7500W** en su generador. Por lo tanto solo puede recargar una única vez a los núcleos asignados, tras la recarga la cantidad de watts queda en **3500W** ya que se deberían restar 4000: `2500 + 1500.` 

**Nota**: Los efectos sobre los núcleos son los mismos que los mencionados en el ejemplo del **punto 1**. 

## 2.2: Riel de Gestión
Los núcleos pueden conectarse al _Riel de gestión_ desde una cámara de pruebas para someterse al escaneo de corrupción.

- Solo los núcleos asignados a esa cámara de pruebas pueden acoplarse a su Riel.
- No puede acoplarse un núcleo que ya esté acoplado, ni desacoplarse uno que no esté acoplado.
- **Protocolo de Resolución de Conflictos:** Para que un núcleo se pueda acoplar al riel, debe haber al menos otro núcleo asignado a la cámara que permanezca desacoplado, ya que el sistema requiere un testigo presencial para validar el diagnóstico de corrupción.

**Nota**: Se puede asumir que un Núcleo nunca está en más de una Cámara a la vez. 

### Requerimientos 

- Que un Núcleo se acople al _Riel de gestión_ desde una Cámara de Pruebas.
- Que un Núcleo se desacople del _Riel de Gestión_ desde una Cámara de Pruebas.
- Saber si un Núcleo de una Cámara de Pruebas está acoplado o no.
- Saber todos los núcleos acoplados de una Cámara de Pruebas.

#### Caso de ejemplo:

Además de la **Cámara 01** usada en el punto anterior, vamos a tener una segunda cámara llamada **Cámara 02**. 
Tiene como núcleos asignados a **GLaDOS** y a un nuevo núcleo estándar llamado **Núcleo de la Curiosidad**, de 82 °C de temperatura.
La reserva de Watts de la **Cámara 02** está en 0.

Probar la siguiente secuencia:

- **GLaDOS** se acopla sin problemas en la **Cámara 02**
- Si intenta volver a acoplarse, no podría hacerlo.
- El **Núcleo de Moralidad** no podría acoplarse en la **Cámara 02** porque no está asignado a esa cámara.
- El **Núcleo de la Curiosidad** no podría acoplarse en la **Cámara 02**, ya que no quedaría ningún núcleo desacoplado como testigo (GLaDOS está acoplada).
- Si el **Núcleo de Curiosidad** intenta desacoplarse en la **Cámara 02** no podría, ya que nunca estuvo acoplado.
- El **Núcleo del Espacio** se acopla sin problemas en la **Cámara 01**.
- El **Núcleo del Espacio** se desacopla sin problemas en la **Cámara 01**.
- El **Núcleo de Moralidad** se acopla sin problemas en la **Cámara 01**.
- Verificar que el único núcleo acoplado de la **Cámara 02** es **GLaDOS**.
- Verificar que sólo el **Núcleo de Moralidad** está acoplado a la **Cámara 01**.


## Aperture Laboratories

Las instalaciones de **Aperture Laboratories** poseen una red de Cámaras de Pruebas bajo la supervisión del Núcleo Central, GLaDOS, los científicos te pidieron que añadas la siguiente información al sistema:

- Los Núcleos Sobrecalentados: el conjunto que se forma por el Núcleo de mayor temperatura de cada Cámara de Pruebas.
- La cantidad de watts diarios necesarios para abastecer todas las Cámaras de Prueba de las instalaciones.
- La Cámara de Pruebas con más núcleos acoplados al Riel de Gestión.

#### Caso de ejemplo:
El complejo **Aperture Laboratories** está compuesto por la **Cámara 01** y **Cámara 02**, con los mismos núcleos asignados de los puntos previos.
Acoplar a **GLaDOS** en la **Cámara 02**.
Acoplar al **Núcleo de Moralidad** en la **Cámara 01**.
Desacoplar a **GLaDOS** en la **Cámara 02**

Verificar que:

 - Los núcleos sobrecalentados de **Aperture Laboratories** son el **Núcleo de Moralidad** y el **Núcleo de la Curiosidad**.
 - Las cantidad diaria de watts que consumen los núcleos del **Complejo** es 6550W. 
 - La **Cámara 01** es la cámara con más acoplados.

