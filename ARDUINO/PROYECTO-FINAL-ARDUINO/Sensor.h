#ifndef SENSOR_H
#define SENSOR_H

#include <Arduino.h>//usamos string de esta biblioteca

class Sensor {//Class padre de sensor
  protected:
    float valor;
    String magnitud;

  public:
    Sensor(String magnitud); 
    float leerMedicion(); 
    String obtenerMagnitud();
};
#endif