# Processing — Estacionamiento Inteligente RFID

## Descripción

Este programa desarrolla la interfaz gráfica del estacionamiento inteligente.

Permite administrar los usuarios registrados, sus créditos y las cuatro plazas disponibles, además de comunicarse con Arduino mediante el puerto serial.

## Funcionalidades

- Visualización de las cuatro plazas del estacionamiento.
- Registro de usuarios mediante nombre, UID y créditos.
- Consulta de usuarios registrados.
- Carga de créditos.
- Validación de tarjetas RFID.
- Control de ingreso y salida de vehículos.
- Actualización de plazas ocupadas y disponibles.
- Almacenamiento de información en archivos CSV.

## Programación orientada a objetos

El proyecto utiliza clases para organizar sus funcionalidades:

### Usuario

Representa a cada usuario del estacionamiento.

Sus atributos principales son:

- Nombre
- UID de la tarjeta RFID
- Saldo o créditos disponibles

### GestorUsuarios

Administra los usuarios registrados.

Permite:

- Registrar nuevos usuarios.
- Buscar usuarios por UID.
- Cargar créditos.
- Descontar créditos.
- Guardar y recuperar información.

### Estacionamiento

Administra las cuatro plazas disponibles.

Permite:

- Consultar si una plaza está libre.
- Registrar el ingreso de un vehículo.
- Registrar la salida.
- Obtener el número de plazas ocupadas.
- Obtener el número de plazas disponibles.
- Guardar y cargar el estado de las plazas.

## Persistencia de datos

El programa utiliza archivos CSV para conservar información entre ejecuciones.

### usuarios.csv

Almacena la información de los usuarios registrados.

Ejemplo:

```csv
nombre,uid,saldo
Juan,E6BBBC06,5
```

### estacionamiento.csv

Almacena el estado de las plazas.

Ejemplo:

```csv
plaza,uid
1,E6BBBC06
2,LIBRE
3,LIBRE
4,LIBRE
```

El método `guardarPlazas()` actualiza el archivo cuando cambia la ocupación y `cargarPlazas()` recupera la información al iniciar el programa.

## Comunicación con Arduino

Processing utiliza la biblioteca `processing.serial.*` para intercambiar mensajes con Arduino.

Cuando recibe una identificación RFID, verifica:

1. Si la tarjeta pertenece a un usuario registrado.
2. Si el usuario dispone de créditos.
3. Si existen plazas disponibles.

Luego envía una respuesta a Arduino para autorizar o rechazar la operación.

## Requisitos

- Processing
- Biblioteca Serial de Processing
- Arduino conectado mediante puerto USB
- Puerto serial correctamente configurado
- Archivos del proyecto en la misma carpeta del sketch

## Autor

Emanuel Occhiuto — Informática II — UTN FRM — 2026

