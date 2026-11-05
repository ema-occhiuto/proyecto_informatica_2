import processing.serial.*;

//OBJETOS DE NUESTRAS CLASES
ComunicacionArduino comunicacion;
Estacionamiento estacionamiento;
GestorUsuarios gestor;

//PLAZA SELECCIONADA CON EL MOUSE
int plazaSeleccionada=0;


// COLORES
color fondo = color(22, 34, 54);
color panel = color(37, 54, 78);
color verde = color(60, 200, 130);
color rojo = color(230, 80, 80);
color blanco = color(255);


void setup() {
size(1000,650);


//CREAMOS LOS OBJETOS 
comunicacion=new ComunicacionArduino(this,"COM6");
gestor=new GestorUsuarios("usuarios.csv");
estacionamiento=new Estacionamiento(4);

//CARGAMOS LOS USUARIOS GUARDADOS
gestor.cargarUsuarios();
}

void draw() {
  
  background(fondo);

  // TITULO
  fill(blanco);
  textSize(28);
  textAlign(LEFT);
  text("ESTACIONAMIENTO RFID", 40, 55);

  textSize(14);
  fill(180);
  text("Sistema de control de acceso", 40, 80);

  // DIBUJAMOS LAS PLAZAS
  dibujarPlazas();

  // MOSTRAMOS LOS CONTADORES
  mostrarContadores();
}


// DIBUJAR LAS CUATRO PLAZAS
void dibujarPlazas() {

  for (int i = 0; i < 4; i++) {

    int x = 40 + i * 240;
    int y = 130;

    // FONDO DE CADA PLAZA
    fill(panel);
    rect(x, y, 215, 170, 12);

    // NUMERO DE PLAZA
    fill(blanco);
    textSize(20);
    textAlign(CENTER);
    text("PLAZA " + (i + 1), x + 107, y + 40);

    // VERIFICAMOS SI ESTA LIBRE
    if (estacionamiento.plazaLibre(i + 1)) {//Si esta libre entra en el if

      fill(verde);
      text("LIBRE", x + 107, y + 105);

    } else {

      fill(rojo);
      text("OCUPADA", x + 107, y + 105);
    }
  }
}


// MOSTRAR CONTADORES
void mostrarContadores() {

  fill(panel);
  rect(40, 340, 920, 130, 12);

  fill(blanco);
  textAlign(CENTER);
  textSize(18);

  text("CAPACIDAD", 190, 380);
  text("OCUPADAS", 500, 380);
  text("DISPONIBLES", 810, 380);

  textSize(32);

  text(estacionamiento.obtenerCapacidadMaxima(), 190, 430);
  text(estacionamiento.obtenerOcupados(), 500, 430);
  text(estacionamiento.obtenerDisponibles(), 810, 430);
}


// RECIBIR DATOS DESDE ARDUINO
void serialEvent(Serial puerto) {

  String mensaje = puerto.readStringUntil('\n');

  if (mensaje != null) {
    comunicacion.recibirMensaje(mensaje);
  }
}


// CERRAR CONEXION
void dispose() {

  if (comunicacion != null) {
    comunicacion.desconectar();
  }
}
