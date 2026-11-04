
import processing.serial.*;

class ComunicacionArduino {

  // ATRIBUTOS PRIVADOS
  private Serial puerto;
  private String ultimoMensaje;
  private boolean conectado;

  // CONSTRUCTOR
  public ComunicacionArduino(PApplet programa, String nombrePuerto) {

    ultimoMensaje = "";
    conectado = false;

    try {
      puerto = new Serial(programa, nombrePuerto, 9600);

      puerto.clear();
      puerto.bufferUntil('\n');

      conectado = true;

      println("Arduino conectado en: " + nombrePuerto);

    } catch (Exception e) {

      puerto = null;
      println("Error al conectar Arduino: " + e.getMessage());
    }
  }

  // ENVIAR MENSAJE A ARDUINO
  public void enviarMensaje(String mensaje) {

    if (conectado && mensaje != null) {

      puerto.write(mensaje + "\n");

      println("Enviado a Arduino: " + mensaje);
    }
  }

  // RECIBIR MENSAJE DESDE ARDUINO
  public void recibirMensaje(String mensajeArduino) {

    if (mensajeArduino!=null) {

      ultimoMensaje = mensajeArduino.trim();

      println("Recibido de Arduino: " + ultimoMensaje);
    }
  }

  // OBTENER EL ULTIMO MENSAJE
  public String obtenerUltimoMensaje() {

    return ultimoMensaje;
  }

  // VERIFICAR CONEXION
  public boolean estaConectado() {

    return conectado;
  }

  // CERRAR CONEXION
  public void desconectar() {

    if (puerto != null) {

      puerto.stop();
      puerto = null;
      conectado = false;

      println("Arduino desconectado");
    }
  }
}
