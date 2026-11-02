#include "PantallaLCD.h"

// CONSTRUCTOR
PantallaLCD::PantallaLCD(byte direccion, byte columnas, byte filas)
  : lcd(direccion, columnas, filas) {
}

// INICIAR LCD
void PantallaLCD::iniciar() {
  lcd.init();
  lcd.backlight();
  lcd.clear();
}

// MOSTRAR MENSAJE
void PantallaLCD::mostrarMensaje(String linea1, String linea2) {

  lcd.clear();

  lcd.setCursor(0, 0);
  lcd.print(linea1.substring(0, 16));

  lcd.setCursor(0, 1);
  lcd.print(linea2.substring(0, 16));
}

// LIMPIAR PANTALLA
void PantallaLCD::limpiar() {
  lcd.clear();
}