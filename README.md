# Estacionamiento Inteligente con RFID

## Descripción del proyecto

Este proyecto corresponde al trabajo final de la materia **Informática II**, de la carrera Ingeniería Electrónica de la Universidad Tecnológica Nacional, Facultad Regional Mendoza.

Consiste en un sistema de estacionamiento inteligente con capacidad para **4 vehículos**, que utiliza Arduino UNO para controlar los componentes electrónicos y Processing para administrar los usuarios mediante una interfaz gráfica.

## Funcionamiento general

El sistema permite controlar el ingreso y la salida de vehículos mediante tarjetas RFID.

- Detecta vehículos mediante sensores ultrasónicos.
- Identifica las tarjetas mediante un lector RFID RC522.
- Verifica la autorización y los créditos disponibles de cada usuario en la aplicacion Processing.
- Controla una barrera mediante un servomotor.
- Utiliza indicadores LED y un buzzer para informar el resultado de la autorización.
- Muestra información en una pantalla LCD.
- Permite visualizar las plazas disponibles y ocupadas desde Processing.
- Guarda información de usuarios y del estado de las plazas en archivos CSV.

## Tecnologías utilizadas

- Arduino UNO R3
- Lenguaje C++
- Processing
- Comunicación serial
- Archivos CSV
- Git y GitHub

## Organización del repositorio

```text
proyecto_informatica_2/
├── ARDUINO/
│   └── PROYECTO-FINAL-ARDUINO/
├── PROCESSING/
│   └── Proyecto_final/
└── README.md
```

Cada carpeta contiene el código correspondiente y su documentación.

## Comunicación Arduino–Processing

Arduino se encarga de los sensores y actuadores, mientras que Processing administra los usuarios, sus créditos y las plazas del estacionamiento.

Ambos programas intercambian información mediante comunicación serial.

## Autor

Emanuel Occhiuto

Ingeniería Electrónica — UTN Facultad Regional Mendoza

Materia: Informática II — 2026

