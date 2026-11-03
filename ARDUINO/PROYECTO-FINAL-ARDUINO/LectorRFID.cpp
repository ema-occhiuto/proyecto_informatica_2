#include "LectorRFID.h"

//CONSTRUCTOR
LectorRFID::LectorRFID(byte pinSS, byte pinRST):lector(pinSS,pinRST){
  ultimoUID="";
}

//INICIALIZAR EL LECTOR RFID

void LectorRFID::iniciar(){
  SPI.begin();
  lector.PCD_Init();
}

//DETECTAMOS Y LEEMOS NUEVA TARJETA
bool LectorRFID::hayTarjeta(){

  if (!lector.PICC_IsNewCardPresent()) {
    return false;
  }

  if (!lector.PICC_ReadCardSerial()) {
    return false;
  }

  ultimoUID = "";

 
 // RECORRER LOS BYTES DEL UID
  for (byte i = 0; i < lector.uid.size; i++) {

    if (lector.uid.uidByte[i] < 0x10) {
      ultimoUID += "0";
    }

    ultimoUID += String(lector.uid.uidByte[i], HEX);
  }

  ultimoUID.toUpperCase();

  // FINALIZAR LA LECTURA
  lector.PICC_HaltA();
  lector.PCD_StopCrypto1();

  return true;
}

// OBTENER EL UID DE LA TARJETA
String LectorRFID::obtenerUID() {

  return ultimoUID;
}


