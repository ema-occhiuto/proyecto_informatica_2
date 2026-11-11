
#include <Arduino.h>

#include "LectorRFID.h"
#include "Led.h"
#include "Barrera.h"
#include "SensorUltrasonico.h"
#include "PantallaLCD.h"

// OBJETOS
LectorRFID rfid(10, 9);
Led rojo(6);
Led verde(5);
Barrera barrera(4, 0, 90);
SensorUltrasonico sensorEntrada(2, 3);
SensorUltrasonico sensorPaso(7, 8);
PantallaLCD pantalla(0x27, 16, 2);

// DISTANCIA MAXIMA PARA DETECTAR UN VEHICULO
const float DISTANCIA_MAX = 10.0;

//VARIABLES DE CONFIRMACION
bool vehiculoDetectado=false;
bool esperandoRespuesta=false;
bool esperandoPaso=false;

void setup(){
//INICIAMOS LA COMUNICACION SERIAL
Serial.begin(9600);

//INICIAMOS LOS COMPONENTES
rfid.iniciar();
rojo.iniciar();
verde.iniciar();
barrera.iniciar();
sensorEntrada.iniciar();
sensorPaso.iniciar();
pantalla.iniciar();

//ESTADO DE LED
verde.apagar();
rojo.apagar();

pantalla.mostrarMensaje("Estacionamiento", "Bienvenidos");

}


void loop(){
  //GENERAMOS UNA MEDICION
  sensorEntrada.generarMedicion();

  float distancia=sensorEntrada.leerMedicion();

  if(distancia>0 && distancia<=DISTANCIA_MAX){
    if(!vehiculoDetectado){

      vehiculoDetectado=true;

      Serial.println("Vehiculo detectado");
      Serial.println("Acerque su tarjeta RFID");
      
      //MOSTRAMOS MENSAJE EN LCD
      pantalla.mostrarMensaje("Auto detectado", "Acerque tarjeta");
    }
  }

 
  //SI HAY VEHICULO, ESPERAMOS LA TARJETA
  if(vehiculoDetectado && rfid.hayTarjeta()){
    
    String uid=rfid.obtenerUID();

    pantalla.mostrarMensaje("Tarjeta ledia","Espere por favor...");

    Serial.print("UID:");
    Serial.println(uid);

    //ESPERAMOS LA RESPUESTA DE PROCESSING
    esperandoRespuesta=true;
  }

//RECIBIMOS INFORMACION DESDE PROCESSING
if(Serial.available()>0){

  String mensaje=Serial.readStringUntil('\n');//Recibimos la info que nos llega por puerto serial y la almacenamos

  mensaje.trim();

//VERIFICAMOS SI EL INGRESO FUE AUTORIZADO
if(esperandoRespuesta && mensaje.startsWith("AUTORIZADO:")){
//EXTRAEMOS EL NOMBRE DE USUARIO
  String nombre=mensaje.substring(11);//substring omite las 11 palabras de autorizado

    pantalla.mostrarMensaje("Bienvenido",nombre);

    verde.encender();

    barrera.abrir();

    esperandoRespuesta=false;
    esperandoPaso=true;
  }
}

//BUSCAMOS SEGUNDA CONFIRMACION PARA EL INGRESO DEL VEHICULO
if(esperandoPaso){

sensorPaso.generarMedicion();

float distanciaPaso=sensorPaso.leerMedicion();//guardamos la medicion 

if(distanciaPaso>0 && distanciaPaso<=DISTANCIA_MAX){//detecta el segundo sensor el vehiculo a esa distancia

Serial.println("INGRESO_CONFIRMADO");

esperandoPaso=false;

barrera.cerrar();//CERRAMOS BARRERA

}

}
  delay(200);
}
