class NucleoDeMoralidad {
  var condicion = new CondicionNormal()

  method capacidadDeResolver() = condicion.capacidadDeResolver()

  method consumoPorSegundo() = condicion.consumoPorSegundo()

  method usar() {
    condicion.usar(self)
  }

  method corromperse() {
    condicion = corrupto
  }
}

class CondicionNormal {
  var usos = 0

  method capacidadDeResolver() = 100

  method consumoPorSegundo() = 10

  method usar(nucleo) {
    usos += 1
    if (usos == 3) {
      nucleo.corromperse()
    }
  }
}

object corrupto {
  method capacidadDeResolver() = 50

  method consumoPorSegundo() = 30

  method usar(nucleo) {}
}

class NucleoDeInteligencia {
  const velocidad
  var memoria

  method velocidadDePensamiento() = velocidad

  method memoria() = memoria

  method capacidadDeResolver() = self.velocidadDePensamiento() * self.memoria()

  method consumoPorSegundo() = self.velocidadDePensamiento()

  method usar() {
    memoria += 1
  }
}

class NucleoDeIra inherits NucleoDeInteligencia {
  const emocionalidad

  override method velocidadDePensamiento() = super() * 2

  override method capacidadDeResolver() = super() - emocionalidad
}

class Camara {
  const property nivel
  const property duracion
}

class GLaDOS {
  const nucleos = #{}
  var property energia

  method incorporar(nucleo) {
    nucleos.add(nucleo)
  }

  method capacidadDeResolver() = nucleos.sum({nucleo => nucleo.capacidadDeResolver()})

  method consumoPorSegundo() = nucleos.sum({nucleo => nucleo.consumoPorSegundo()})

  method energiaNecesariaPara(camara) = self.consumoPorSegundo() * camara.duracion()

  method puedeUtilizar(camara) =
    camara.nivel() < self.capacidadDeResolver() and self.energiaNecesariaPara(camara) <= energia

  method utilizar(camara) {
    if (not self.puedeUtilizar(camara)) {
      self.error("GLaDOS no puede utilizar la cámara")
    }
    energia -= self.energiaNecesariaPara(camara)
    nucleos.forEach({nucleo => nucleo.usar()})
  }
}
