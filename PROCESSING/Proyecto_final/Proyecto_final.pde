import processing.serial.*;

//OBJETOS DE NUESTRAS CLASES
ComunicacionArduino comunicacion;
Estacionamiento estacionamiento;
GestorUsuarios gestor;


//PLAZA SELECCIONADA CON EL MOUSE
int plazaSeleccionada=0;

// ULTIMO UID RECIBIDO DESDE ARDUINO
String uidRecibido = "";

// DATOS DEL INGRESO PENDIENTE DEL USUARIO AUTORIZADO
String uidPendiente = "";
int plazaPendiente = 0;
boolean ingresoPendiente = false;

//DATOS DEL EGRESO PENDIENTE DEL USUARIO ESTACIONADO
int plazaSalidaPendiente=0;
boolean salidaPendiente=false;



// COLORES
color fondo = color(22, 34, 54);
color panel = color(37, 54, 78);
color verde = color(60, 200, 130);
color rojo = color(230, 80, 80);
color blanco = color(255);






void setup() {
size(1000,650);


//CREAMOS LOS OBJETOS 
comunicacion=new ComunicacionArduino(this,"COM6");//Aca ya iniciamos comunicacion con arduino
gestor=new GestorUsuarios("usuarios.csv");
estacionamiento=new Estacionamiento(4);

//CARGAMOS LOS USUARIOS GUARDADOS
gestor.cargarUsuarios();
}

void draw() {
  
  background(fondo);//Se encarga de pintar el fondo de la ventana

  // TITULO
  fill(blanco);
  textSize(28);//Tamano del texto, en 28 pixeles
  textAlign(LEFT);
  text("ESTACIONAMIENTO RFID", 40, 55);//se encarga de dibujar el texto en la pantalla

  textSize(14);
  fill(180);
  text("Sistema de control de acceso", 40, 80);

  // DIBUJAMOS LAS PLAZAS
  dibujarPlazas();

  // MOSTRAMOS LOS CONTADORES
  mostrarContadores();
  
  //MOSTRAMOS LOS BOTONES DE INGRESO Y SALIDA
  dibujarBotones();
}


// DIBUJAR LAS CUATRO PLAZAS
void dibujarPlazas() {

  for (int i = 0; i < 4; i++) {

    int x = 40 + i * 240;
    int y = 130;
    
    int numeroPlaza=i+1;

    //RESALTAR LA PLAZA SELECCIONADA
    if(plazaSeleccionada==numeroPlaza){
      stroke(verde);
      strokeWeight(4);
    }else{
      noStroke();
    }
    
    // FONDO DE CADA PLAZA
    fill(panel);
    rect(x, y, 215, 170, 12);
    noStroke();

    // NUMERO DE PLAZA
    fill(blanco);
    textSize(20);
    textAlign(CENTER);
    text("PLAZA " + numeroPlaza, x + 107, y + 40);

    // VERIFICAMOS SI ESTA LIBRE
    if (estacionamiento.plazaLibre(numeroPlaza)) {//Si esta libre entra en el if

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

  text(estacionamiento.obtenerCapacidadMaxima(), 190, 430);//CAPACIDAD
  text(estacionamiento.obtenerOcupados(), 500, 430);//OCUPADOS
  text(estacionamiento.obtenerDisponibles(), 810, 430);//DISPONIBLES
}



//DIBUJAR BOTONES DE INGRESO Y SALIDA
void dibujarBotones(){
  
  //BOTON DE INGRESO
  fill(verde);
  rect(200,510,250,65,12);//dibuja el rectangulo
  
  fill(blanco);
  textAlign(CENTER);
  textSize(20);
  text("INGRESO",325,550);
  
  //BOTON DE SALIDA
  fill(rojo);
  rect(550,510,250,65,12);
  
   fill(blanco);
  text("SALIDA", 675, 550);
}




//FUNCION DE MOUSSE
void mousePressed() {

  // SELECCIONAR UNA PLAZA
  for (int i = 0; i < 4; i++) {//Aca es para ver que plaza seleccionamos

    int x = 40 + i * 240;
    int y = 130;

    if (mouseX >= x && mouseX <= x + 215 &&
        mouseY >= y && mouseY <= y + 170) {

      plazaSeleccionada = i + 1;//ESTE MODIFICA EL VALOR DE LA PLAZA SELECCIONADA

      println("Plaza seleccionada: " + plazaSeleccionada);
      return;
    }
  }

  // BOTON INGRESO,puede saber que boton tocamos, si el de ingreso o salida
  if (mouseX >= 200 && mouseX <= 450 &&
      mouseY >= 510 && mouseY <= 575) {

      ejecutarBoton(1);
  }

  // BOTON SALIDA
  if (mouseX >= 550 && mouseX <= 800 &&
      mouseY >= 510 && mouseY <= 575) {

     ejecutarBoton(2);
  }
}



void ejecutarBoton(int boton){
  switch(boton){
    
    case 1:
    probarIngreso();
    break;
    
    case 2:
    probarSalida();
    break;
    
    case 3:
    println("Registrar nuevo usuario");
    break;
    
    case 4:
    println("Cargar creditos");
    break;
    
    default:
    println("Boton no reconocido");
    break;
  }
}




//FUNCIONES DE PRUEBA

// PROBAR INGRESO
void probarIngreso() {

  if (plazaSeleccionada == 0) {
    println("Primero selecciona una plaza");
    return;
  }

  String uidPrueba = "PRUEBA" + millis();//ESTO LE ENVIAMOS COMO MENSAJE

  if (estacionamiento.registrarIngreso(
      plazaSeleccionada, uidPrueba)) {

    println("Ingreso registrado en plaza " + plazaSeleccionada);

  } else {

    println("No se pudo registrar el ingreso");
  }
}


// PROBAR SALIDA
void probarSalida() {

  if (plazaSeleccionada == 0) {
    println("Primero selecciona una plaza");
    return;
  }

  if (estacionamiento.registrarSalida(plazaSeleccionada)) {

    println("Salida registrada de plaza " + plazaSeleccionada);

  } else {

    println("No se pudo registrar la salida");
  }
}




// RECIBIR DATOS DESDE ARDUINO
void serialEvent(Serial puerto) {

  String mensaje = puerto.readStringUntil('\n');//texto recibidio desde arduino que le pasamos como argumento 

  if (mensaje != null) {
    comunicacion.recibirMensaje(mensaje);//enviamos la informacion a nuestra clase comunicacion
    procesarMensaje(mensaje);
  }
}



// PROCESAR MENSAJES RECIBIDOS DESDE ARDUINO
void procesarMensaje(String mensaje) {
   //ENVIO DE UID

  if (mensaje.startsWith("UID:")) {//esta funcion se encarga que los primeros caracteres que envia arduino coincidan con el mismo
  
  //EXTRAEMOS EL UID
 uidRecibido=mensaje.substring(4).trim();//GUARDA LA DIRECCION UID.Aplicamos trim() para que borre el salto de linea
 
  println("UID recibido:"+uidRecibido);
  }
  
  //ENVIO DE INGRESO CONFIRMADO DESDE ARDUINO
  if(mensaje.equals("INGRESO_CONFIRMADO")){
    confirmarIngreso();//ESTA FUNCION CONFIRMA EL INGRESO DEL USUARIO
    
   //ENVIO DE EGRESO CONFIRMADO DESDE ARDUINO
   if(mensaje.equals("EGRESO_CONFIRMADO"));
   confirmarSalida();
  }
}


//AUTORIZAR INGRESO AL ESTACIONAMIENTO
void autorizarIngreso(){
  
  //VERIFICAMOS QUE SE HAYA SELECCIONADO UNA PLAZA
  if(plazaSeleccionada==0){
    println("Primero seleccione una plaza");
    return;
  }
  
  // VERIFICAMOS SI YA HAY UN INGRESO PENDIENTE
if (ingresoPendiente) {
  println("Ya existe un ingreso pendiente");
  return;
}
  
  //VERIFICAMOS QUE TENGAMOS UN UID
  if(uidRecibido.isEmpty()){
    println("No se recibio ninguna tarjeta");
    return;
  }
    
    //BUSCAMOS EL USUARIO EN LA LISTA ENLAZADA
  Usuario usuario=gestor.buscarUsuario(uidRecibido);//declaramos variable tipo usuario
  
  //VERIFICAMOS SI EL USUARIO ESTA REGISTRADO
  if(usuario==null){
    println("Tarjeta no registrada...");
    //ENVIAMOS MENSAJE A ARDUINO
    comunicacion.enviarMensaje("ERROR:TARJETA");
    return;
  }
    
    //VERIFICAMOS SI TIENE CREDITOS
    if(usuario.obtenerSaldo()<=0){
      println("Usuario sin credito");
      comunicacion.enviarMensaje("ERROR:CREDITOS");
      return;
    }
    
    
    //VERIFICAMOS SI HAY LUGAR EN EL ESTACIONAMIENTO
    if(!estacionamiento.hayLugar()){
      println("Estacionamiento completo");
      comunicacion.enviarMensaje("ERROR:COMPLETO");
      return;
    }
    
    //VERIFICAMOS SI SE SELECCIONO UNA PLAZA LIBRE
    if(plazaSeleccionada==0||!estacionamiento.plazaLibre(plazaSeleccionada)){
      println("Seleccione una plaza libre");
      return;
    }
    
    //TODAS LAS CONDICIONES SE CUMPLIERON
    println("Ingreso autorizado:"+usuario.obtenerNombre());
    
    //GUARDAMOS LOS DATOS DEL INGRESO PENDIENTE,esperando confirmacion del segundo sensor
    uidPendiente=uidRecibido;
    plazaPendiente=plazaSeleccionada;
    ingresoPendiente=true;
    
    //ENVIAMOS LA AUTORIZACION Y EL NOMBRE A ARDUINO
    comunicacion.enviarMensaje("AUTORIZADO"+usuario.obtenerNombre());
    
    println("Esperando la confrimacion del segundo sensor");
   
}

//AUTORIZAMOS EGRESO DEL ESTACIONAMIENTO
void autorizarSalida(){
  
  //VERIFICAMOS QUE SE HAYA SELECCIONADO UNA PLAZA
  if(plazaSeleccionada==0){
    println("Primero seleccione una plaza");
    return;
  }
  
  //VERIFICAMOS QUE NO HAYA OTRA SALIDA PENDIENTE
  if(salidaPendiente){
    println("Ya existe una salida pendiente");
    return;
  }
    
  //VERIFICAMOS QUE LA PLAZA ESTE OCUPADA 
  if(estacionamiento.plazaLibre(plazaSeleccionada)){
    println("La plaza seleccionada ya esta libre");
    return;
  }
  
  //GUARDAMOS LA SALIDA PENDIENTE
  plazaSalidaPendiente=plazaSeleccionada;
  salidaPendiente=true;
  
  //ENVIAMOS LA AUTPRIZACION A ARDUINO
  comunicacion.enviarMensaje("AUTORIZAR_SALIDA");
  
  println("Salida autorizada. Esperando confirmacion del arduino");
}
 
  
  

//CONFIRMAMOS INGRESO AL ESTACIONAMIENTO
void confirmarIngreso(){
  
  //VERIFICAMOS SI EXISTE UN INGRESO PENDIENTE
if (!ingresoPendiente) {
  println("No hay ningun ingreso pendiente");
  return;
}

//REGISTRAMOS EL VEHICULO EN LA PLAZA
boolean registrado=estacionamiento.registrarIngreso(plazaPendiente,uidPendiente);

if(!registrado){
  println("Error al registrar el vehiculo");
  return;
}

//BUSCAMOS AL USUARIO AUTORIZADO
Usuario usuario=gestor.buscarUsuario(uidPendiente);

if(usuario==null){
  println("Usuario pendiente no enocntrado");
  
  //REVERTIMOS EL REGISTRO
  estacionamiento.registrarSalida(plazaPendiente);
  return;
}

//DESCONTAMOS UN CREDITO
boolean descontado=usuario.descontarIngreso();

if(!descontado){
  println("Error al descontar credito");
  
  //REVERTIMOS EL REGISTRO
  estacionamiento.registrarSalida(plazaPendiente);
  return;
}

//GUARDAMOS EL SALDO ACTUALIZADO
gestor.guardarUsuarios();

  println("Ingreso confirmado");
  println("Usuario: " + usuario.obtenerNombre());
  println("Plaza: " + plazaPendiente);
  println("Saldo restante: " + usuario.obtenerSaldo());

  // LIMPIAMOS LAS VARIABLES PENDIENTES
  uidPendiente = "";
  plazaPendiente = 0;
  ingresoPendiente = false;
  uidRecibido = "";
}





// CERRAR CONEXION
void dispose() {

  if (comunicacion != null) {
    comunicacion.desconectar();
  }
}
