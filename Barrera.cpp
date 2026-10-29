#include "Barrera.h"

//CONSTRUCTOR

Barrera::Barrera(byte pin,int anguloCerrado,int anguloAbierto){
  this->pin=pin;
  this->anguloCerrado=anguloCerrado;
  this->anguloAbierto=anguloAbierto;

  abierta=false;
}

//iniciamos el servo motor

void Barrera::iniciar(){
servo.attach(pin);
cerrar();
}

//Abrir barrera
void Barrera::abrir(){
  servo.write(anguloAbierto);
  abierta=true;
}

//cerrar barrera
void Barrera::cerrar(){
  servo.write(anguloCerrado);
  abierta=false;
}

//Consultar el estado
bool Barrera::estaAbierta(){
  return abierta;
}

