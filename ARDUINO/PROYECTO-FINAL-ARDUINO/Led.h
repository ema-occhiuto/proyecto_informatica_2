
#ifndef LED_H
#define LED_H

class Led{
  private:
  int pin;

  public:
  Led (int pin);
  void iniciar();
  void encender();
  void apagar();
};
#endif