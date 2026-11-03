#ifndef LECTOR_RFID_H
#define LECTOR_RFID_H

#include <Arduino.h>
#include <SPI.h>
#include <MFRC522.h>

class LectorRFID {

  private:
    MFRC522 lector;//creamos objeto de la libreria MFRC522
    String ultimoUID;//Almacenamos el valor registrado del lector

  public:
    LectorRFID(byte pinSS, byte pinRST);//creamos el constructor

    void iniciar();//Inicializamos el lector rfid
    bool hayTarjeta();//comprobamos si hay una tarjeta nueva
    String obtenerUID();
};

#endif