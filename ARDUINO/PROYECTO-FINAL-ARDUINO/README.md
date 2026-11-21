# Arduino — Estacionamiento Inteligente RFID

## Descripción

Este programa controla los componentes electrónicos del estacionamiento inteligente mediante una placa Arduino UNO R3.

Se comunica con Processing para recibir las autorizaciones de ingreso y coordinar el funcionamiento del sistema mediante el puerto de comunicacion 6 (COM6).

## Componentes utilizados

- Arduino UNO R3
- Lector RFID RC522
- Servomotor para la barrera
- Dos sensores ultrasónicos
- Pantalla LCD 16x2 con módulo I2C
- LED RGB (utilizamos el rojo y verde)
- Buzzer

## Conexiones principales

| Componente | Pin Arduino |
|---|---|
| RFID SDA/SS | D10 |
| RFID RST | D9 |
| RFID MOSI | D11 |
| RFID MISO | D12 |
| RFID SCK | D13 |
| Servomotor | D4 |
| LED verde | D5 |
| LED rojo | D6 |
| Buzzer | A0 |
| LCD SDA | A4 |
| LCD SCL | A5 |

Los sensores ultrasónicos utilizan pines digitales configurados en el programa.

**Importante:** el lector RFID RC522 debe alimentarse con 3,3 V.

## Programación orientada a objetos

El programa utiliza clases propias para organizar el funcionamiento de los componentes:

- `Led`: control de indicadores luminosos.
- `LectorRFID`: lectura de tarjetas RFID.
- `Barrera`: control del servomotor.
- `SensorUltrasonico`: medición de distancias.
- `PantallaLCD`: visualización de información.

## Funcionamiento

1. Un sensor detecta la presencia de un vehículo.
2. El usuario aproxima su tarjeta RFID.
3. Arduino envía la identificación a Processing.
4. Processing verifica los datos y responde.
5. Si el acceso está autorizado, Arduino abre la barrera y activa el indicador correspondiente.
6. El sensor de paso confirma el movimiento del vehículo.
7. La barrera se cierra según la lógica de control.

## Indicadores sonoros

El buzzer conectado al pin A0 permite distinguir dos situaciones:

- Acceso autorizado: tono agudo.
- Acceso rechazado: tono grave.

La duración del sonido se controla utilizando `millis()`, sin detener el funcionamiento del programa.

## Comunicación serial

Arduino intercambia mensajes con Processing a una velocidad de 9600 baudios.

Entre las respuestas utilizadas se encuentran:

```text
DESDE PROCESSING HACIA ARDUINO
AUTORIZADO:nombre:saldo
ERROR:TARJETA
ERROR:CREDITOS
ERROR:COMPLETO
AUTORIZAR_SALIDA

```

## Calibración del sensor ultrasónico

Se implementó el método numérico de Newton-Raphson para corregir las mediciones de distancia a partir de una función de calibración obtenida experimentalmente.

## Requisitos para ejecutar el codigo en arduino

- Arduino IDE
- Biblioteca SPI
- Biblioteca MFRC522
- Biblioteca Servo
- Bibliotecas correspondientes a la pantalla LCD I2C
- Placa Arduino UNO R3

## Autor

Emanuel Occhiuto — Informática II — UTN FRM — 2026
