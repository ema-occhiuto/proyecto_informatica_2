#ifndef SENSOR_ULTRASONICO_H
#define SENSOR_ULTRASONICO_H

#include "Sensor.h"//libreria de class sensor padre

class SensorUltrasonico:public Sensor{//Herencia del class sensor

  private:
  int pinTrig;//OUTPUT,emite las ondas de sonido
  int pinEcho;//INPUT,este recibe las ondas de sonido

  public:
    SensorUltrasonico(int trig,int echo);//constructor del sensorultrasonico
    void iniciar();
    void generarMedicion();
};
#endif
  
  
