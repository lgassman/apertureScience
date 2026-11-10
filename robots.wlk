class NucleoDeMoralidad {
  var property condicion = new Normal()

  method capacidadDeResolver() = condicion.capacidadDeResolver()

  method potenciaNecesaria(camara) = camara.potenciaDisponible() * condicion.porcentajeDePotencia() / 100

  method usar() {
    condicion.usar(self)
  }

  method corromperse() {
    condicion = corrupto
  }

  method normalizarse() {
    condicion = new Normal()
  }
}

class Normal {
  var vecesUsado = 0

  method capacidadDeResolver() = 50 * (1 + vecesUsado)

  method porcentajeDePotencia() = 5 - vecesUsado

  method usar(nucleo) {
    vecesUsado += 1
    if (vecesUsado == 3) {
      nucleo.corromperse()
    }
  }
}

object corrupto {
  method capacidadDeResolver() = 40

  method porcentajeDePotencia() = 100

  method usar(nucleo) {
    nucleo.normalizarse()
  }
}

class NucleoDeInteligencia {
  const esfuerzo
  var memoria

  method potencia() = 30 * esfuerzo

  method potenciaNecesaria(camara) = self.potencia()

  method velocidadDePensamiento() = esfuerzo * memoria / 10

  method capacidadDeResolver() = self.velocidadDePensamiento() + memoria

  method usar() {
    memoria += 10
  }
}

class NucleoDeInteligenciaEmocional inherits NucleoDeInteligencia {
  var emocionalidad

  override method velocidadDePensamiento() = super() * 2

  override method capacidadDeResolver() = super() + emocionalidad

  override method usar() {
    super()
    emocionalidad += 2
  }
}

class Camara {
  const property dificultad
  const property potenciaDisponible
}

class Robot {
  const nucleos = #{}
  const historial = []

  method capacidadDeResolver() = nucleos.sum({nucleo => nucleo.capacidadDeResolver()})

  method potenciaNecesaria(camara) = nucleos.map({nucleo => nucleo.potenciaNecesaria(camara)}).max()

  method puedeSuperar(camara) =
    camara.dificultad() <= self.capacidadDeResolver() and
    self.potenciaNecesaria(camara) <= camara.potenciaDisponible()

  method validarSuperar(camara) {
    if (not self.puedeSuperar(camara)) {
      self.error("El robot no puede superar la cámara")
    }
  }
  method superar(camara) {
    self.validarSuperar(camara)
    nucleos.forEach({nucleo => nucleo.usar()})
    historial.add(camara)
  }

  method nucleoMasHabil() = nucleos.max({nucleo => nucleo.capacidadDeResolver()})

  method historialDeSuperacion() = historial

  method camarasSuperadas() = historial.asSet()
}

class Empresa {
  const robots = #{}

  method nucleosMasHabiles() = robots.map({robot => robot.nucleoMasHabil()}).asSet()

  method cantidadDeRobotsQueSuperaron(camara) =
    robots.filter({robot => robot.camarasSuperadas().contains(camara)}).size()

  method esImposible(camara) = not robots.any({robot => robot.puedeSuperar(camara)})
}
