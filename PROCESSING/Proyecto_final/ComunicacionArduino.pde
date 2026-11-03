import processing.serial.*;

class ComunicacionArduino {

  private Serial puerto;

  public ComunicacionArduino(PApplet programa, String nombrePuerto) {

    puerto = new Serial(programa, nombrePuerto, 9600);
    puerto.bufferUntil('\n');
  }

  public void enviarMensaje(String mensaje) {
    puerto.write(mensaje + "\n");
  }
}
