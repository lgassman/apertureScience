class NucleoPersonalidad {
 var property temperatura
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




   
}
