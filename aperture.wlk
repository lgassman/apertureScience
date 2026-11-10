class NucleoDeMoralidad {
  var property condicion = new Normal()

  method capacidadDeResolver() = condicion.capacidadDeResolver()

  method potenciaExigida(camara) = camara.potenciaExigible() * condicion.porcentajeDePotencia() / 100

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

  method potenciaExigida(camara) = self.potencia()

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
  const property potenciaExigible
}

class Agente {
  const nucleos = #{}
  const historial = []

  method capacidadDeResolver() = nucleos.sum({nucleo => nucleo.capacidadDeResolver()})

  method potenciaExigida(camara) = nucleos.map({nucleo => nucleo.potenciaExigida(camara)}).max()

  method puedeUtilizar(camara) =
    camara.dificultad() <= self.capacidadDeResolver() and
    self.potenciaExigida(camara) <= camara.potenciaExigible()

  method utilizar(camara) {
    if (not self.puedeUtilizar(camara)) {
      self.error("El agente no puede utilizar la cámara")
    }
    nucleos.forEach({nucleo => nucleo.usar()})
    historial.add(camara)
  }

  method nucleoMasHabil() = nucleos.max({nucleo => nucleo.capacidadDeResolver()})

  method historialDeUso() = historial.copy()

  method camarasUsadas() = historial.asSet()
}

class Empresa {
  const agentes = #{}

  method nucleosMasHabiles() = agentes.map({agente => agente.nucleoMasHabil()}).asSet()

  method cantidadDeAgentesQueUtilizaronCamaras() =
    agentes.filter({agente => not agente.camarasUsadas().isEmpty()}).size()

  method esImposible(camara) = not agentes.any({agente => agente.puedeUtilizar(camara)})
}
