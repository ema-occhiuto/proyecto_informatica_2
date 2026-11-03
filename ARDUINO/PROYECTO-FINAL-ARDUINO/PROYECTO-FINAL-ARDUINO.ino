
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

// CONFIGURACION
const String UID_AUTORIZADO = "E6BBBC06";

const float DISTANCIA_LIMITE = 15.0;

const unsigned long TIEMPO_MAX_ABIERTA = 15000;
const unsigned long TIEMPO_MENSAJE = 2000;

// ESTADOS DEL SISTEMA
enum Estado {
  ESPERANDO_VEHICULO,
  ESPERANDO_TARJETA,
  BARRERA_ABIERTA,
  ACCESO_RECHAZADO
};

Estado estado = ESPERANDO_VEHICULO;

// VARIABLES
unsigned long tiempoApertura = 0;
unsigned long tiempoRechazo = 0;

bool pasoDetectado = false;

// FUNCION PARA DETECTAR VEHICULOS
bool detectarVehiculo(SensorUltrasonico &sensor) {

  sensor.generarMedicion();

  float distancia = sensor.leerMedicion();

  return distancia > 0 &&
         distancia < DISTANCIA_LIMITE;
}

// FUNCION PARA VOLVER AL ESTADO INICIAL
void estadoInicial() {

  barrera.cerrar();

  verde.apagar();
  rojo.encender();

  pasoDetectado = false;

  estado = ESPERANDO_VEHICULO;

  pantalla.mostrarMensaje(
    "Estacionamiento",
    "Acerque vehiculo"
  );
}

void setup() {

  Serial.begin(9600);

  // INICIAR COMPONENTES
  rfid.iniciar();

  rojo.iniciar();
  verde.iniciar();

  barrera.iniciar();

  sensorEntrada.iniciar();
  sensorPaso.iniciar();

  pantalla.iniciar();

  pantalla.mostrarMensaje(
    "Estacionamiento",
    "Iniciando..."
  );

  delay(1500);

  estadoInicial();
}

void loop() {

  switch (estado) {

    // 1. ESPERAR UN VEHICULO
    case ESPERANDO_VEHICULO:

      if (detectarVehiculo(sensorEntrada)) {

        estado = ESPERANDO_TARJETA;

        pantalla.mostrarMensaje(
          "Vehiculo presente",
          "Acerque tarjeta"
        );

        Serial.println("Vehiculo detectado");
      }

      break;

    // 2. ESPERAR TARJETA RFID
    case ESPERANDO_TARJETA:

      if (rfid.hayTarjeta()) {

        String uid = rfid.obtenerUID();

        Serial.print("UID: ");
        Serial.println(uid);

        if (uid == UID_AUTORIZADO) {

          // ACCESO PERMITIDO
          rojo.apagar();
          verde.encender();

          barrera.abrir();

          tiempoApertura = millis();
          pasoDetectado = false;

          estado = BARRERA_ABIERTA;

          pantalla.mostrarMensaje(
            "Acceso permitido",
            "Barrera abierta"
          );

          Serial.println("ACCESO PERMITIDO");

        } else {

          // ACCESO RECHAZADO
          rojo.encender();
          verde.apagar();

          tiempoRechazo = millis();

          estado = ACCESO_RECHAZADO;

          pantalla.mostrarMensaje(
            "Acceso denegado",
            "Tarjeta invalida"
          );

          Serial.println("ACCESO DENEGADO");
        }
      }

      break;

    // 3. BARRERA ABIERTA
    case BARRERA_ABIERTA: {

      bool vehiculoEnPaso = detectarVehiculo(sensorPaso);

      if (vehiculoEnPaso) {
        pasoDetectado = true;
      }

      // EL VEHICULO PASO Y LIBERO EL SENSOR
      if (pasoDetectado && !vehiculoEnPaso) {

        Serial.println("Vehiculo paso la barrera");

        estadoInicial();
      }

      // TIEMPO MAXIMO DE APERTURA
      else if (millis() - tiempoApertura >=
               TIEMPO_MAX_ABIERTA) {

        if (!vehiculoEnPaso) {
          Serial.println("Tiempo de apertura agotado");
          estadoInicial();
        }
      }

      break;
    }

    // 4. ACCESO RECHAZADO
    case ACCESO_RECHAZADO:

      if (millis() - tiempoRechazo >= TIEMPO_MENSAJE) {

        estado = ESPERANDO_TARJETA;

        pantalla.mostrarMensaje(
          "Vehiculo presente",
          "Acerque tarjeta"
        );
      }

      break;
  }

  delay(60);
}

