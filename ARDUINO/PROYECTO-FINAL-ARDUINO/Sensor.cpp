//DEFINIMOS LAS FUNCIONES DE LA CLASS SENSOR PADRE

#include "Sensor.h"

Sensor::Sensor(String magnitud){//definicion del contstructor
  this->magnitud=magnitud;
  valor=0;
}

float Sensor::leerMedicion(){
  return valor;
}

String Sensor::obtenerMagnitud(){
  return magnitud;
}