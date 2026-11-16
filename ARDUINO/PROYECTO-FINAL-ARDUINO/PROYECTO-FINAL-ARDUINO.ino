
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

//TIEMPO MAX DE CIERRE DE BARRERA
const unsigned long TIEMPO_CIERRE=3000;//3 segundos

unsigned long tiempoPaso=0;

//TIEMPO QUE MOSTRAMOS EL ERROR POR LCD
const unsigned long TIEMPO_ERROR=3000;
//INSTRANTE EN EL QUE OCURRIO EL ERROR
unsigned long tiempoError=0;

//VARIABLES DE CONFIRMACION
bool vehiculoDetectado=false;
bool esperandoRespuesta=false;
bool esperandoPaso=false;
bool cierrePendiente=false;
bool errorActivo=false;
//------------------------------------------------
//MENSAJE DE PROCESSING
enum EstadoRespuesta{
    SIN_RESPUESTA,
    AUTORIZADO,
    ERROR_TARJETA,
    ERROR_CREDITOS,
    ERROR_COMPLETO
};

//ESTADO ACTUAL DE LA RESPUESTA 
EstadoRespuesta respuestaProcessing=SIN_RESPUESTA;

//DATOS DEL USUARIO AUTORIZADO
String nombreAutorizado="";
int CreditosRestantes=0;
//-------------------------------------------------

void recibirDatosProcessing();

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

    pantalla.mostrarMensaje("Tarjeta ledia", "Espere por favor...");

    Serial.print("UID:");
    Serial.println(uid);

    //ESPERAMOS LA RESPUESTA DE PROCESSING
    esperandoRespuesta=true;
  }

//RECIBIMOS LOS DATOS DE PROCESSING
  recibirDatosProcessing();

//INGRESO AUTORIZADO
if(esperandoRespuesta && respuestaProcessing==AUTORIZADO){


    pantalla.mostrarMensaje(nombreAutorizado, "Creditos:"+String(CreditosRestantes));//MOSTRAMOS POR LCD

    verde.encender();

    barrera.abrir();

    esperandoRespuesta=false;
    esperandoPaso=true;
    
    //LIMPIAMOS LA RESPUESTA
    respuestaProcessing=SIN_RESPUESTA;

}

  //TARJETA NO REGISTRADA
  else if(esperandoRespuesta && respuestaProcessing==ERROR_TARJETA){
  
  //MOSTRAMOS POR LCD
  pantalla.mostrarMensaje("ACCESO DENEGADO", "No registrado");

  rojo.encender();
  verde.apagar();

  tiempoError=millis();
  errorActivo=true;

  //LIMPIAMOS RESPUESTA PROCESSING
  respuestaProcessing=SIN_RESPUESTA;
  esperandoRespuesta=false;
}

  //CREDITOS INSUFICIENTES
  else if(esperandoRespuesta && respuestaProcessing==ERROR_CREDITOS){
 
  pantalla.mostrarMensaje("ACCESO DENEGADO", "Sin credito");

  rojo.encender();
  verde.apagar();

  tiempoError=millis();
  errorActivo=true;

  //LIMPIAMOS RESPUESTA PROCESSING
  respuestaProcessing=SIN_RESPUESTA;
  esperandoRespuesta=false;
}

 //ESTACIONAMIENTO COMPLETO
 else if(esperandoRespuesta && respuestaProcessing==ERROR_COMPLETO){

 pantalla.mostrarMensaje("ESTACIONAMIENTO", "COMPLETO");

 rojo.encender();
 verde.apagar();

 tiempoError=millis();
 errorActivo=true;

 //LIMPIAMOS RESPUESTA PROCESSING
 respuestaProcessing=SIN_RESPUESTA;
 esperandoRespuesta=false;
}


//verificamos si termino el tiempo de error
if(errorActivo && millis()-tiempoError>=TIEMPO_ERROR){

rojo.apagar();

//VOLVEMOS A SOLICITAR LA TARJETA 
pantalla.mostrarMensaje("Acerque su", "tarjeta nuevamente");

errorActivo=false;//FINALIZAMOS EL ESTADO DE ERROR 
}



//BUSCAMOS SEGUNDA CONFIRMACION PARA EL INGRESO DEL VEHICULO
if(esperandoPaso){

sensorPaso.generarMedicion();

float distanciaPaso=sensorPaso.leerMedicion();//guardamos la medicion 

//EL VEHICULO COMEINZA A PASAR
if(distanciaPaso>0 && distanciaPaso<=DISTANCIA_MAX){//detecta el segundo sensor el vehiculo a esa distancia


Serial.println("INGRESO_CONFIRMADO");

//GUARDAMOS CUANDO SE DETECTO EL SEGUNDO SENSOR
tiempoPaso=millis();

esperandoPaso=false;
cierrePendiente=true;
}
}

//ESPERAMOS PARA CERRAR LA BARRERA
if(cierrePendiente && millis()-tiempoPaso>=TIEMPO_CIERRE){

barrera.cerrar();
verde.apagar();

cierrePendiente=false;
vehiculoDetectado=false;

pantalla.mostrarMensaje("Estacionamiento", "Bienvenidos");
}
  delay(200);
}






void recibirDatosProcessing(){
if(Serial.available()>0){

  String mensaje=Serial.readStringUntil('\n');//Recibimos la info que nos llega por puerto serial y la almacenamos

  mensaje.trim();

  if(!esperandoRespuesta){
    return;
  }

  //VERIFICAMOS SI EL INGRESO FUE AUTORIZADO
  if(mensaje.startsWith("AUTORIZADO:")){

    int separador=mensaje.indexOf(':',11);//buscamos el segundo separador,la posicion depende del largo del nombre
    
    //COMPROBAMOS QUE EXISTE EL CARACTER
    if(separador!=1){
    //EXTRAEMOS EL NOMBRE DE USUARIO
    nombreAutorizado=mensaje.substring(11,separador);

    //EXTRAEMOS LOS CREDITOS RESTATNTES
    String saldotexto=mensaje.substring(separador+1);//lo guardamos en una variable local

    CreditosRestantes=saldotexto.toInt();//lo convertimos a entero

    //GUARDAMOS EL ESTADO DE AUTORIZACION
    respuestaProcessing=AUTORIZADO;
    }
  }
  
  //TARJETA NO REGISTRADA
  else if(mensaje=="ERROR:TARJETA"){
    respuestaProcessing=ERROR_TARJETA;
  }

  //CREDITOS INSUFICIENTES
  else if(mensaje=="ERROR:CREDITOS"){
    respuestaProcessing=ERROR_CREDITOS;
  }

  //ESTACIONAMIENTO COMPLETO
  else if(mensaje="ERROR:COMPLETO"){
    respuestaProcessing=ERROR_COMPLETO;
  }
}
}




