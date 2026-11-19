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

  unsigned long duracion = pulseIn(pinEcho, HIGH, 30000UL);//MIDE CUANTO TIEMPO TARDA EN REGRESAR EL SONIDO MEDIANTE EL ECHO(ULTRASEGUNDOS)

  if (duracion == 0) {
    valor = -1;
  } else {
     
   // Calculamos la distancia en centimetros
    float distancia = duracion * 0.0343 / 2.0;

   //--------------------------------------
   //Calculo por el metodo de Newton-Raphson
   //--------------------------------------

    // Aproximacion inicial
    float x = distancia;

    // Metodo de Newton-Raphson
    for (int i = 0; i < 10; i++) {

      // Funcion obtenida de nuestras mediciones
      float f = 0.9274 * x + 0.002817 * x * x - distancia;

      // Derivada de la funcion
      float derivada = 0.9274 + 0.005634 * x;

      // Calculamos una nueva aproximacion
      x = x - f / derivada;
    }

    // Guardamos la distancia corregida
    valor = x;
    //----------------------------------------------------
  }
}