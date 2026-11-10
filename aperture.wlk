class NucleoDeMoralidad {
  var condicion = new Normal()

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
  const optimizacion
  var memoria

  method potencia() = optimizacion * memoria

  method potenciaExigida(camara) = self.potencia()

  method velocidadDePensamiento() = 3 * self.potencia()

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

  method incorporar(nucleo) {
    nucleos.add(nucleo)
  }

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

  method historialDeUso() = historial.copy()

  method camarasUsadas() = historial.asSet()
}

object aperture {
  const agentes = #{}

  method incorporar(agente) {
    agentes.add(agente)
  }

  method agentesQuePuedenUtilizar(camara) = agentes.filter({agente => agente.puedeUtilizar(camara)})

  method todosPuedenUtilizar(camara) = agentes.all({agente => agente.puedeUtilizar(camara)})

  method agenteQueUtilizo(camara) =
    agentes.find({agente => agente.camarasUsadas().contains(camara)})

  method camarasUtilizadas() = agentes.flatMap({agente => agente.camarasUsadas()}).asSet()
}
