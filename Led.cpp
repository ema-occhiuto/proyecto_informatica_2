#include <Arduino.h>
#include "Led.h"

Led::Led(int pin){//constructor de led
this->pin=pin;
}

void Led::iniciar(){
  pinMode(pin,OUTPUT);
}

void Led::encender(){
  digitalWrite(pin,HIGH);
}

void Led::apagar(){
  digitalWrite(pin,LOW);
}