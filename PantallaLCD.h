#ifndef PANTALLA_LCD_H
#define PANTALLA_LCD_H

#include <Arduino.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>

class PantallaLCD {

  private:
    LiquidCrystal_I2C lcd;

  public:
    PantallaLCD(byte direccion, byte columnas, byte filas);

    void iniciar();
    void mostrarMensaje(String linea1, String linea2);
    void limpiar();
};

#endif