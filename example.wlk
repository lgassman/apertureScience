class NucleoPersonalidad {
 var property temperatura
 var acoplado = false

 method estaAcoplado() = acoplado

 method acoplar() {
   if (acoplado) {
     self.error("El núcleo ya está acoplado")
   }
   acoplado = true
 }

 method desacoplar() {
   if (not acoplado) {
     self.error("El núcleo no está acoplado")
   }
   acoplado = false
 }

 method energiaRecarga(){
   return 25 * temperatura
 }

 method recargar() {
    temperatura = temperatura + self.energiaRecarga() / self.divisorTemperatura()
 }

 method divisorTemperatura() {
  return 10000
 }
}


class Corrupto inherits NucleoPersonalidad{
  var property corrupcion

  override method energiaRecarga() {
    return 3000 * corrupcion
  }
  override method recargar() {
    super()
    corrupcion = (corrupcion - 0.01).max(0.2)
  }

}

class Central inherits NucleoPersonalidad {

  override method energiaRecarga() {
    return if (temperatura > 70) 500 else 300 
  }

 override method divisorTemperatura() {
  return 50000
 }

} 

class CamaraDePrueba {

  var property carga 
  const nucleos

  method abastecer() {
    self.validarAbastecer()
    carga -= self.consumo()
    nucleos.forEach {nucleo => nucleo.recargar() } 
  }
  method validarAbastecer() {
    if (not self.puedeAbastecer() ) {
      self.error("No se puede recargar")
    } 
  }
  method puedeAbastecer() {
    return self.consumo() <= carga
  }
  method consumo() {
    return nucleos.sum({nucleo => nucleo.energiaRecarga()})
  }
  method recargar(energia) {
    carga += energia
  }

  method nucleoMasCaliente() {
    return nucleos.max({nucleo => nucleo.temperatura()})
  }

  method acoplar(nucleo) {
    self.validarAsignado(nucleo)
    self.validarTestigo(nucleo)
    nucleo.acoplar()
  }

  method desacoplar(nucleo) {
    self.validarAsignado(nucleo)
    nucleo.desacoplar()
  }

  method validarAsignado(nucleo) {
    if (not nucleos.contains(nucleo)) {
      self.error("El núcleo no está asignado a la cámara")
    }
  }

  method validarTestigo(nucleo) {
    if (not self.hayTestigoPara(nucleo)) {
      self.error("No hay otro núcleo desacoplado que sirva de testigo")
    }
  }

  method hayTestigoPara(nucleo) {
    return nucleos.any({otro => otro != nucleo and not otro.estaAcoplado()})
  }

  method estaAcoplado(nucleo) {
    self.validarAsignado(nucleo)
    return nucleo.estaAcoplado()
  }

  method nucleosAcoplados() {
    return nucleos.filter({nucleo => nucleo.estaAcoplado()})
  }

  method cantidadAcoplados() {
    return self.nucleosAcoplados().size()
  }
}

object apertureLaboratories {
  const camaras = #{}

  method agregarCamara(camara) {
    camaras.add(camara)
  }

  method nucleosSobrecalentados() {
    return camaras.map({camara => camara.nucleoMasCaliente()}).asSet()
  }

  method consumoDiario() {
    return camaras.sum({camara => camara.consumo()})
  }

  method camaraConMasAcoplados() {
    return camaras.max({camara => camara.cantidadAcoplados()})
  }
}
