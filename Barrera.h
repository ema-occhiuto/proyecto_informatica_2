#ifndef BARRERA_H
#define BARRERA_H

#include <Arduino.h>
#include <Servo.h>//Libreria extra para el manejo del servo motor

class Barrera{
 
 private:
 Servo servo;//creamos el objeto servo
 byte pin;
 int anguloCerrado;//posicion de la barrera cerrada
 int anguloAbierto;//posicion de la barrera abierta
 bool abierta;//nos entrega true si es cierto, false si es falso

 public:
 Barrera(byte pin,int anguloCerrado,int anguloAbierto);//CONSTRUCTOR

 void iniciar();
 void abrir();
 void cerrar();
 bool estaAbierta();

};

#endif





