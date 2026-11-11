//DEFINIMOS LAS FUNCIONES DE SENSORULTRASONICO

#include <Arduino.h>
#include "SensorUltrasonico.h"
//definimos constructor, que hacemos la herencia de la class sensor
SensorUltrasonico::SensorUltrasonico(int trig, int echo): Sensor("centimetros") {
  pinTrig = trig;
  pinEcho = echo;
}

void SensorUltrasonico::iniciar() {
  pinMode(pinTrig, OUTPUT);
  pinMode(pinEcho, INPUT);
}

void SensorUltrasonico::generarMedicion() {
  digitalWrite(pinTrig, LOW);
  delayMicroseconds(2);

  digitalWrite(pinTrig, HIGH);//MANDA UN PULSO ULTRASONICO
  delayMicroseconds(10);
  digitalWrite(pinTrig, LOW);

  unsigned long duracion = pulseIn(pinEcho, HIGH, 30000UL);//MIDE CUANTO TARDA EN REGRESAR MEDIANTE EL ECHO

  if (duracion == 0) {
    valor = -1;
  } else {
    valor = duracion * 0.0343 / 2.0;//calculamos la distancia de duracion, y lo agregamos en valor
  }
}