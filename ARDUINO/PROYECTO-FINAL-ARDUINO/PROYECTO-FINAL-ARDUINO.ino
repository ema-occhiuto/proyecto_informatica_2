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
const unsigned long TIEMPO_CIERRE=2000;//3 segundos

unsigned long tiempoPaso=0;
unsigned long tiempoBuzzer=0;

//TIEMPO QUE MOSTRAMOS EL ERROR POR LCD
const unsigned long TIEMPO_ERROR=3000;
const unsigned long TIEMPO_ERROR_ESTACIONAMIENTO=5000;
//INSTRANTE EN EL QUE OCURRIO EL ERROR
unsigned long tiempoError=0;

//VARIABLES DE CONFIRMACION
bool vehiculoDetectado=false;
bool esperandoRespuesta=false;
bool esperandoPaso=false;
bool cierrePendiente=false;
bool errorActivo=false;
bool errorActivoEstacionamiento=false;
bool esperandoSalida=false;
bool buzzerSonando=false;
//------------------------------------------------
//MENSAJE DE PROCESSING
enum EstadoRespuesta{
    SIN_RESPUESTA,
    AUTORIZADO,
    ERROR_TARJETA,
    ERROR_CREDITOS,
    ERROR_COMPLETO,
    ERROR_ESTACIONADO,
    ERROR_NO_ESTACIONADO,
    AUTORIZAR_SALIDA
};
//ESTADO ACTUAL DE LA RESPUESTA 
EstadoRespuesta respuestaProcessing=SIN_RESPUESTA;

//DATOS DEL USUARIO AUTORIZADO
String nombreAutorizado="";
int CreditosRestantes=0;
int plazaAsignada=0;
//-------------------------------------------------

//ESTADOS DEL ESTACIONAMIENTO
enum EstadoSistema{
    ESPERANDO_VEHICULO,
    ESPERANDO_TARJETA,
    ESPERANDO_RESPUESTA,
    ESPERANDO_PASO,
    CERRANDO_BARRERA,
    MOSTRANDO_ERROR
};
//ESTADO INICIAL DEL SISTEMA
EstadoSistema estadoActual=ESPERANDO_VEHICULO;

//SENTIDO DE CIRCULACION
enum SentidoCirculacion{

  SIN_SENTIDO,
  INGRESO,
  SALIDA
};

//ESTADO DE CIRCULACION INICIAL
SentidoCirculacion sentidoActual=SIN_SENTIDO;


void recibirDatosProcessing();
void sonidoAutorizado();
void sonidoRechazado();

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

//BUZZER
pinMode(A0,OUTPUT);

//ESTADO DE LED
verde.apagar();
rojo.apagar();

pantalla.mostrarMensaje("Estacionamiento", "Bienvenidos");

}

//FUNCION LOOP
void loop(){

//DETECTAMOS LA PRESENCIA DE UN VEHIUCLO
if(estadoActual==ESPERANDO_VEHICULO){

  //GENERAMOS UNA MEDICION CON EL SENSOR DE ENTRADA
  sensorEntrada.generarMedicion();
  float distancia=sensorEntrada.leerMedicion();//Guardamos el dato con la presicion del calculo Newton-Raphson


  //VERIFICAMOS SI HAY UN VEHICULO INGRESANDO
  if(distancia>0 && distancia<=DISTANCIA_MAX){
      
      //ACTUALIZAMOS ESTADO DEL SISTEMA
      sentidoActual=INGRESO;
      estadoActual=ESPERANDO_TARJETA;
      
      //MOSTRAMOS MENSAJE EN LCD
      pantalla.mostrarMensaje("Auto detectado", "Acerque tarjeta");
    }else{

      //MEDIMOS EL SENSOR DE SALIDA
      sensorPaso.generarMedicion();
      float distanicaPaso=sensorPaso.leerMedicion();

      //VERIFICAMOS SI HAY UN VEHICULO SALIENDO
      if(distanciaPaso>0 && distanciaPaso<DISTANCIA_MAX){

        //ACTUALIZAMOS ESTADO DEL SISTEMA
        sentidoActual=SALIDA;
        estadoActual=ESPERANDO_TARJETA;

        pantalla.mostrarMensaje("Auto saliendo", "Acerque su tarjeta");
      }
    }
}


//SI HAY VEHICULO, ESPERAMOS LA TARJETA RFID
if(estadoActual=ESPERANDO_TARJETA && rfid.hayTarjeta()){
    
    String uid=rfid.obtenerUID();

    pantalla.mostrarMensaje("Tarjeta leida", "Espere por favor...");
    
    //VERIFICAMOS EL SENTIDO DE INGRESO
    if(sentidoActual==INGRESO){

    Serial.print("UID_INGRESO:");
    Serial.println(uid);
}else{
  if(sentidoActual==SALIDA){

    Serial.print("UID_SALIDA:");
    Serial.println(uid);
  }
}

//ESPERAMOS LA RESPUESTA DE PROCESSING
estadoActual=ESPERANDO_RESPUESTA;
}


//RECIBIMOS LOS DATOS DE PROCESSING
  recibirDatosProcessing();

//INGRESO AUTORIZADO POR PROCESSING
if(estadoActual==ESPERANDO_RESPUESTA && sentidoActual==INGRESO && respuestaProcessing==AUTORIZADO){

//MOSTRAMOS LOS DATOS EN EL LCD
pantalla.mostrarMensaje(nombreAutorizado,"Plaza: "+String(plazaAsignada));

//CONTROLAMOS LOS LEDS
verde.encender();
rojo.apagar();

//ABRIMOS LA BARRERA
barrera.abrir();

sonidoAutorizado();//activamos el buzzer

//LIMPIAMOS LA RESPUESTA
respuestaProcessing=SIN_RESPUESTA;

//ESPERAMOS LA CONFIRMACION DEL SENSOR
estadoActual=ESPERANDO_PASO;
}

//SALIDA AUTORIZADA POR PROCESSING
if(estadoActual==ESPERANDO_RESPUESTA &&
   sentidoActual==SALIDA &&
   respuestaProcessing==AUTORIZAR_SALIDA){

  //MOSTRAMOS MENSAJE EN EL LCD
  pantalla.mostrarMensaje("Salida autorizada","Puede salir");

  //CONTROLAMOS LOS LED
  verde.encender();
  rojo.apagar();

  //ABRIMOS LA BARRERA
  barrera.abrir();

  //ACTIVAMOS EL BUZZER
  sonidoAutorizado();

  //LIMPIAMOS LA RESPUESTA
  respuestaProcessing=SIN_RESPUESTA;

  //ESPERAMOS LA CONFIRMACION DEL SENSOR
  estadoActual=ESPERANDO_PASO;
}









  //TARJETA NO REGISTRADA
  else if(esperandoRespuesta && respuestaProcessing==ERROR_TARJETA){
  
  //MOSTRAMOS POR LCD
  pantalla.mostrarMensaje("ACCESO DENEGADO", "No registrado");

  rojo.encender();
  verde.apagar();
  sonidoRechazado();

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
  sonidoRechazado();

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
 sonidoRechazado();

 tiempoError=millis();
 errorActivoEstacionamiento=true;

 //LIMPIAMOS RESPUESTA PROCESSING
 respuestaProcessing=SIN_RESPUESTA;
 esperandoRespuesta=false;
}


//verificamos si termino el tiempo de error de creditos y usuario
if(errorActivo && millis()-tiempoError>=TIEMPO_ERROR){

rojo.apagar();

//VOLVEMOS A SOLICITAR LA TARJETA 
pantalla.mostrarMensaje("Acerque su", "tarjeta nuevamente");

errorActivo=false;//FINALIZAMOS EL ESTADO DE ERROR 
}


//VERIFICAMOS SI TERMINO EL TIEMPO ERROR ESTACIONAMIENTO
if(errorActivoEstacionamiento && millis()-tiempoError>=TIEMPO_ERROR_ESTACIONAMIENTO){

  rojo.apagar();

  //Mostramos mensaje de bienvenida
  pantalla.mostrarMensaje("Estacionamiento", "Bienvenidos");

  errorActivoEstacionamiento=false;//FINALIZAMOS EL ESTADO DE EEROR ESTACIONAMIENTO
  vehiculoDetectado=false;
}

//ESPERAMOS QUE EL SENSOR PASO DETECTE LA SALIDA
if(esperandoSalida){
sensorPaso.generarMedicion();

//Almacenamos valor 
float distanciaSalida=sensorPaso.leerMedicion();//Guardamos el dato con la presicion del calculo Newton-Raphson

if(distanciaSalida>0 && distanciaSalida<=DISTANCIA_MAX){

  //ABRIMOS LA BARRERA
  barrera.abrir();
  verde.encender();
  sonidoAutorizado();

  pantalla.mostrarMensaje("Salida completa", "Hasta luego...");

  //CONFIRMAMOS LA SALIDA A PROCESSING
  Serial.println("SALIDA_CONFIRMADA");

  //INICIAMOS EL TEMPORIZADOR DE CIERRE
  tiempoPaso=millis();

  cierrePendiente=true;
  esperandoSalida=false;
}
}


//BUSCAMOS SEGUNDA CONFIRMACION PARA EL INGRESO DEL VEHICULO
if(esperandoPaso){

sensorPaso.generarMedicion();

float distanciaPaso=sensorPaso.leerMedicion();///Guardamos el dato con la presicion del calculo Newton-Raphson

//EL VEHICULO COMEINZA A PASAR
if(distanciaPaso>0 && distanciaPaso<=DISTANCIA_MAX){//detecta el segundo sensor el vehiculo a esa distancia

//CONFIRMAMOS EL INGRESO A PROCESSING
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


//MANEJO DEL TIEMPO DEL BUZZER
if(buzzerSonando && millis()-tiempoBuzzer>=300){

  noTone(A0);
  buzzerSonando=false;
}
  delay(200);
}
//TERMINA LA FUNCION LOOP




void recibirDatosProcessing(){
//INICIAMOS LA COMUNICACION CON EL PUERTO SERIE
if(Serial.available()>0){

  String mensaje=Serial.readStringUntil('\n');//Recibimos la info que nos llega por puerto serial y la almacenamos

  mensaje.trim();

  //VERIFICAMOS QUE ESTEMOS ESPERANDO UNA RESPUESTA
  if(estadoActual!=ESPERANDO_RESPUESTA){
    return;
  }

  //INGRESO AUTORIZADO
  if(mensaje.startsWith("AUTORIZADO:")){

    int separador1=mensaje.indexOf(':',11)//buscamos el segundo separador despues del separador autorizado(depende el nombre de usuario)
    int separador2=mensaje.indexOf(':',separador1+11);//buscamos el tercer separador(":")

    //VERIFICAMOS QUE EXISTAN LOS SEPARADORES
    if(separador1!=-1 && separador2!=-1){

    //EXTRAEMOS EL NOMBRE DE USUARIO
    nombreAutorizado=mensaje.substring(11,separador1);

    //EXTRAEMOS LOS CREDITOS RESTANTES 
    CreditosRestantes=mensaje.substring(separador1+1,separador2).toInt();//con el toInt convertimos el string a un numero int
    
    //EXTRAEMOS LA PLAZA ASIGNADA
    plazaAsignada=mensaje.substring(separador2+1).toInt();

    //ACTUALIZAMOS RESPUESTA
    respuestaProcessing=AUTORIZADO;

    }
  }

 //SALIDA AUTORIZADA
 else if(mensaje=="AUTORIZAR_SALIDA"){
  respuestaProcessing=AUTORIZAR_SALIDA;
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
 else if(mensaje=="ERROR:COMPLETO"){
  respuestaProcessing=ERROR_COMPLETO;
}

 //USUARIO YA ESTACIONADO
 else if(mensaje=="ERROR:ESTACIONADO"){
  respuestaProcessing=ERROR_ESTACIONADO;
}

 //USUARIO NO ESTACIONADO
 else if(mensaje=="ERROR:NO_ESTACIONADO"){
  respuestaProcessing=ERROR_NO_ESTACIONADO;
}
}
}
 

 

//FUNCIONES PARA EL MANEJO DEL BUZZER
void sonidoAutorizado(){
  tone(A0,1500);
  tiempoBuzzer=millis();
  buzzerSonando=true;
}

void sonidoRechazado(){
  tone(A0,400);
  tiempoBuzzer=millis();
  buzzerSonando=true;
}
