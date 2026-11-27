import processing.serial.*;

//OBJETOS DE NUESTRAS CLASES
ComunicacionArduino comunicacion;
Estacionamiento estacionamiento;
GestorUsuarios gestor;



// ULTIMO UID RECIBIDO DESDE ARDUINO
String uidRecibido = "";

// DATOS DEL INGRESO PENDIENTE DEL USUARIO AUTORIZADO
String uidPendiente = "";
int plazaPendiente = 0;
boolean ingresoPendiente = false;

//DATOS DEL EGRESO PENDIENTE DEL USUARIO ESTACIONADO
int plazaSalidaPendiente=0;
boolean salidaPendiente=false;

//BOTON REGISTRO USUARIO
boolean mostrandoRegistro=false;
//BOTON CREDITOS
boolean mostrandoCargaCreditos=false;

// DATOS DEL FORMULARIO
String nombreRegistro = "";
String uidRegistro = "";
String creditosRegistro = "";

//DATOS DE CARGA DE CREDITOS
String uidCargarCreditos="";
String nombreCargarCreditos="";
String creditosCargar="";

// CAMPO SELECCIONADO
int campoActivo = 0;

//UID ADMINISTRATIVO
String uidAdministrativo="";




// COLORES
color fondo = color(22, 34, 54);
color panel = color(37, 54, 78);
color verde = color(60, 200, 130);
color rojo = color(230, 80, 80);
color blanco = color(255);
color azul=color(50,120,220);

//ESTADO DEL SISTEMA ACTUAL
String mensajeEstado="Esperando vehiculo...";
String detalleEstado="Sistema disponible";
color colorEstado=verde;









void setup() {
size(1000,750);


//CREAMOS LOS OBJETOS 
comunicacion=new ComunicacionArduino(this,"COM6");//Aca ya iniciamos comunicacion con arduino
gestor=new GestorUsuarios("usuarios.csv");
estacionamiento=new Estacionamiento(4);

//CARGAMOS LOS USUARIOS GUARDADOS
gestor.cargarUsuarios();

//CARGAMOS LAS PLAZAS
estacionamiento.cargarPlazas();
}


void draw() {
  
  background(fondo);//Se encarga de pintar el fondo de la ventana
  
  //VENTANA DE REGISTROS DE USUARIOS
  if(mostrandoRegistro){
    dibujarFormularioRegistro();
  }else{
    if(mostrandoCargaCreditos){
      dibujarFormularioCreditos();
    } else{

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
  
  //MOSTRAMOS LOS BOTONES ADMINISTRATIVOSD
  dibujarBotones();
  
  dibujarEstadoSistema();
    }
  }
}


// DIBUJAR LAS CUATRO PLAZAS
void dibujarPlazas() {

  for (int i = 0; i < 4; i++) {

    int x = 40 + i * 240;
    int y = 130;
    
    int numeroPlaza=i+1;

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


//DIBUJAR EL ESTADO DEL SISTEMA
void dibujarEstadoSistema(){
  
 //FONDO DEL PANEL
 fill(panel);
 rect(40,490,920,100,12);
 
 //TITULO
 fill(180);
 textAlign(LEFT);
 textSize(14);
 text("ESTADO DEL SISTEMA",60,515);
 
 //CIRCULO LUMINOSO
 fill(colorEstado);
 ellipse(68,540,14,14);
 
 //MENSAJE PRINCIPAL
 textSize(22);
 text(mensajeEstado,85,547);
 
 //DETALLE DEL MENSAJE
 fill(blanco);
 textSize(16);
 text(detalleEstado,60,574);
}
  
//ACTUALIZAR EL ESTADO DEL SISTEMA
void actualizarEstado(String mensaje,String detalle,color estado){
  mensajeEstado=mensaje;
  detalleEstado=detalle;
  colorEstado=estado;
}
  



//DIBUJAR BOTONES DE REGISTRAR USUARIO,CREDITOS
void dibujarBotones(){
  
  //BOTON DE REGISTRAR USUARIOS
  fill(azul);
  rect(200,610,250,65,12);
  
  fill(blanco);
  textAlign(CENTER);
  textSize(20);
  text("REGISTRAR USUARIO",325,650);
  
  //BOTON DE CREDITOS
  fill(azul);
  rect(550,610,250,65,12);
  
  fill(blanco);
  textAlign(CENTER);
  textSize(20);
  text("CARGAR CREDITOS",675,650);
}



//DIBUJAR FORMULARIO DE REGISTRO
void dibujarFormularioRegistro(){
  //FONDO DEL FORMULARIO
  fill(panel);
  rect(200,100,600,530,12);
  
  //TITULO 
  fill(blanco);
  textAlign(CENTER);
  textSize(26);
  text("REGISTRAR USUARIO",500,160);
  
  
  //CAMPO NOMBRE
  textAlign(LEFT);
  textSize(18);
  text("Nombre y apellido:",270,230);
  
  //RECTANGULO BLANCO
  rect(270, 245, 460, 45, 8);
  //ESCRIBIMOS DENTRO DEL RECTANGULO NOMBRE
  fill(0);
  textAlign(LEFT);
  textSize(18);
  text(nombreRegistro, 280, 275);
  
  
  //CAMPO UID
  fill(blanco);
  text("UID:",270,330);
  
  //RECTANGULO BLANCO
   rect(270, 345, 460, 45, 8);
   //COMPLETAR CAMPO UID
   fill(0);
   textAlign(LEFT);
   textSize(18);
   text(uidRegistro, 280, 375);
   
    //CAMPO CREDITOS
   fill(blanco);
   text("Creditos iniciales:",270,430);
   
   //RECTANGULO BLANCO
    rect(270, 445, 460, 45, 8);
    //COMPLETAR CAMPO CREDITOS
    fill(0);
    textAlign(LEFT);
    textSize(18);
    text(creditosRegistro, 280, 475);
    
    //BOTON GUARDAR
    fill(verde);
    rect(380, 535, 240, 55, 10);
    
    fill(blanco);
    textAlign(CENTER);
    textSize(20);
    text("GUARDAR",500,570);
}



void dibujarFormularioCreditos(){
  //PANEL PRINCIPAL
  fill(panel);
  rect(200,100,600,580,12);
  
  //TITULO
  fill(blanco);
  textAlign(CENTER);
  textSize(26);
  text("CARGAR CREDITOS",500,160);
  
  
  //UID DEL USUARIO
  textAlign(LEFT);
  textSize(18);
  fill(blanco);
  text("UID:",270,230);
  
  //RECTANGULO BLANCO
  fill(blanco);
  rect(270,245,460,45,8);
  //COMPLETAR CAMPO DE UID
  fill(0);
  textAlign(LEFT);
  textSize(18);
  text(uidCargarCreditos,280,275);
  
  
  //NOMBRE DEL USUARIO
  fill(blanco);
  text("Nombre y apellido:",270,330);
  
  //RECTANGULO BLANCO
  rect(270,345,460,45,8);
  //COMPLETAR CAMPO NOMBRE
  fill(0);
  textAlign(LEFT);
  textSize(18);
  text(nombreCargarCreditos,280,375);
  
  //CANTIDAD DE CREDITOS
  fill(blanco);
  text("Creditos a cargar",270,430);
  
  //RECTANGULO BLANCO
  rect(270,445,460,45,8);
  // MOSTRAMOS LOS CREDITOS INGRESADOS
  fill(0);
  textAlign(LEFT);
  textSize(18);
  text(creditosCargar, 280, 475);
  
  
  //BOTON CARGAR
  fill(verde);
  rect(380,535,240,55,10);
  
  fill(blanco);
  textAlign(CENTER);
  textSize(20);
  text("CARGAR",500,570);
  
  
  //BOTON VOLVER
  fill(rojo);
  rect(380,610,240,55,10);
  
  fill(blanco);
  textAlign(CENTER);
  textSize(20);
  text("VOLVER",500,645);
}
  
  
  
  
  

  
  


//FUNCION DE MOUSSE
void mousePressed() {
  
  //VENTANA DE REGISTRO DE USUARIOS 
  if(mostrandoRegistro){
      // SELECCIONAR CAMPO NOMBRE
  if (mouseX >= 270 && mouseX <= 730 &&
      mouseY >= 245 && mouseY <= 290) {

    campoActivo = 1;//Estas vaiables globales las usamos en la funcion keypressed
    return;
  }

  // SELECCIONAR CAMPO UID
  if (mouseX >= 270 && mouseX <= 730 &&
      mouseY >= 345 && mouseY <= 390) {

    campoActivo = 2;
    return;
  }

  // SELECCIONAR CAMPO CREDITOS
  if (mouseX >= 270 && mouseX <= 730 &&
      mouseY >= 445 && mouseY <= 490) {

    campoActivo = 3;
    return;
  }
  
  //SELECCIONAR BOTON GUARDAR
  if(mouseX>=380 && mouseX<=620 &&
  mouseY>=535 && mouseY<=590){
    ejecutarBoton(4);
    return;
  }

  campoActivo = 0;
  return;
  }
else{
  //VENTANA DE CARGA CREDITOS
  if(mostrandoCargaCreditos){
    
    //SELECCIONAR CAMPO CREDITOS
    if(mouseX>=270 && mouseX<=730 &&
    mouseY>=445 && mouseY<=490){
      campoActivo=4;
      return;
    }
     //BOTON DE CARGAR CREDITOS
  if(mouseX>=380 && mouseX<=620 &&
  mouseY>=535 && mouseY<=590){
    ejecutarBoton(6);
    return;
  }
  
  //BOTON DE VOLVER
  if(mouseX>=380 && mouseX<=620 &&
  mouseY>=610 && mouseY<=665)
  {
    ejecutarBoton(7);
    return;
  }
    campoActivo=0;
    return;
    
 
  }
  
else{
  //BOTON DE REGISTRAR USUARIOS
  if(mouseX>=200 && mouseX<=450 &&
  mouseY>=610 && mouseY<=675){
    ejecutarBoton(3);
    return;
  }
  
  //BOTON DE CREDITOS
  if(mouseX>=550 && mouseX<=800 &&
  mouseY>=610 && mouseY<=675){
    ejecutarBoton(5);
    return;
 }
}
}
}



//FUNCION DE TECLADO
void keyPressed(){
  if((!mostrandoRegistro && !mostrandoCargaCreditos)||campoActivo==0){
    return;
  }
  
  //BORRAR CARACTERES CON BACKSPACE
  if(key==BACKSPACE){
    
    //ACA ENTRAMOS A ESTE IF SI ESTAMOS POSICIONADOS EN EL RECTANGULO NOMBRE(CAMPO NOMBRE)
    if(campoActivo==1&&nombreRegistro.length()>0){
      nombreRegistro=nombreRegistro.substring(0,nombreRegistro.length()-1);//BORRAMOS UN CARACTER 
    }
    
    //CAMPO UID
    if(campoActivo==2&&uidRegistro.length()>0){
      uidRegistro=uidRegistro.substring(0,uidRegistro.length()-1);
    }
    
    //CAMPO CREDITOS
    if(campoActivo==3&&creditosRegistro.length()>0){
      creditosRegistro=creditosRegistro.substring(0,creditosRegistro.length()-1);
    }
    
    //CAMPO CREDITOS(VENTANA CARGAR CREDITOS)
    if(campoActivo==4&&creditosCargar.length()>0){
      creditosCargar=creditosCargar.substring(0,creditosCargar.length()-1);
    }
    
    return;
  }
  
  //IGNORAMOS TECLAS ESPECIALES
   if (key == CODED || key == ENTER || key == RETURN ||
      key == TAB || key == DELETE || key < 32) {
    return;
  }


//ESCRIBIR EN EL CAMPO NOMBRE
if(campoActivo==1){
  nombreRegistro=nombreRegistro+key;
}


//ESCRIBIR EN EL CAMPO CREDITOS
if(campoActivo==3){
    // SOLO ACEPTAMOS NUMEROS
    if (key >= '0' && key <= '9') {
      creditosRegistro += key;
    }
}
    
//ESCRIBIR EN EL CAMPO CREDITO(VENTANA CARGAR CREDITOS)
if(campoActivo==4){
  if(key>='0' && key<='9'){
    creditosCargar+=key;
  }
}
}






void ejecutarBoton(int boton){
  switch(boton){
     case 3:
   mostrandoRegistro=true;
   
   //UTILIZAMOS EL ULTIMO UID RECIBIDO
   uidRegistro=uidAdministrativo;
    break;
    
    case 4:
    guardarRegistro();
    break;
    
    case 5:
    mostrandoCargaCreditos=true;
    
    //UTILIZAMOS EL ULTIMO UID RECIBIDO
    uidCargarCreditos=uidAdministrativo;
    
    Usuario usuario=gestor.buscarUsuario(uidCargarCreditos);//buscamos el usuario con su id, para cargar creditos
   
   if(usuario==null){
     println("usuario no encontrado");
     nombreCargarCreditos="";//en el caso que no encuentre el usuario;
   }else{
   nombreCargarCreditos=usuario.obtenerNombre();
   }
    break;
    
    case 6:
    guardarCreditos();
    break;
    
    case 7:
    mostrandoCargaCreditos = false;//CERRAMOS EL FORMULARIO
    
    //Las tres variables de string las vaciamos para que no queden guardados los datos
    uidCargarCreditos = "";
    nombreCargarCreditos = "";
    creditosCargar = "";

    campoActivo = 0;
    break;
    
    default:
    println("Boton no reconocido");
    break;
  }
}



// RECIBIR DATOS DESDE ARDUINO
void serialEvent(Serial puerto) {
  
  if(comunicacion.recibirMensaje()){

  String mensaje =comunicacion.obtenerUltimoMensaje();
  
  procesarMensaje(mensaje);
}
}



// PROCESAR MENSAJES RECIBIDOS DESDE ARDUINO
void procesarMensaje(String mensaje) {
  
  mensaje=mensaje.trim();
  
  //RECIBIMOS EL UID PARA INGRESAR
  if (mensaje.startsWith("UID_INGRESO:")) {//esta funcion se encarga que los primeros caracteres que envia arduino coincidan con el mismo
  
  //EXTRAEMOS EL UID
 uidRecibido=mensaje.substring(12).trim();//GUARDA LA DIRECCION UID.Aplicamos trim() para que borre el salto de linea
 
  println("UID de ingreso:"+uidRecibido);
  
  //GUARDAMOS EL UID EN OTRA VARIABLE LOCAL PARA EL MANEJO DE REGISTRO Y CREDITOS
  uidAdministrativo=uidRecibido;
  
  //EJECUTAMOS LA FUNCION autorizarIngreso
  autorizarIngreso();
  }
 
 //RECIBIMOS EL UID PARA SALIR
 if(mensaje.startsWith("UID_SALIDA:")){
   
   //EXTRAEMOS EL UID
   uidRecibido=mensaje.substring(11).trim();
   
   println("UID de salida:"+uidRecibido);
   
   //EJECUTAMOS LA FUNCION autorizarSalida
   autorizarSalida();
 }
   
 
 //ENVIO DE INGRESO CONFIRMADO DESDE ARDUINO
  if(mensaje.equals("INGRESO_CONFIRMADO")){
    confirmarIngreso();//ESTA FUNCION CONFIRMA EL INGRESO DEL USUARIO
  }
    
   //ENVIO DE EGRESO CONFIRMADO DESDE ARDUINO
  if(mensaje.equals("SALIDA_CONFIRMADA")){
    confirmarSalida();
  }
}



//AUTORIZAR INGRESO AL ESTACIONAMIENTO
void autorizarIngreso(){

  // VERIFICAMOS SI YA HAY UN INGRESO PENDIENTE
  if (ingresoPendiente||salidaPendiente) {
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
    
    //ACTUALIZAMOS ESTADO 
    actualizarEstado("Ingreso rechazado","Tarjeta no registrada",rojo);
    return;
  }
  
    //VERIFICAMOS SI EL USUARIO YA ESTA ESTACIONADO
    if(estacionamiento.buscarPlazaPorUID(uidRecibido)!=-1){
    println("El usuario ya esta estacionado");
    comunicacion.enviarMensaje("ERROR:ESTACIONADO");
    
    //ACTUALIZAMOS ESTADO
    actualizarEstado("Ingreso rechazado","Usuario ya estacionado",rojo);
    return;
}
    
    //VERIFICAMOS SI TIENE CREDITOS
    if(usuario.obtenerSaldo()<=0){
     println("Usuario sin credito");
     comunicacion.enviarMensaje("ERROR:CREDITOS");
     
     //ACTUALIZAMOS ESTADO
    actualizarEstado("Ingreso rechazado","Usuario sin creditos",rojo);
     return;
    }
    
    //BUSCAMOS UNA PLAZA LIBRE AUTOMATICAMENTE
     int plazaEntrada=estacionamiento.hayLugar();
     
    //VERIFICAMOS SI HAY LUGAR EN EL ESTACIONAMIENTO
    if(plazaEntrada==-1){
      println("Estacionamiento completo");
      comunicacion.enviarMensaje("ERROR:COMPLETO");
      
    //ACTUALIZAMOS ESTADO
    actualizarEstado("Ingreso rechazado","Estacionamiento completo",rojo);
      return;
    }
    
    //TODAS LAS CONDICIONES SE CUMPLIERON
    println("Ingreso autorizado:"+usuario.obtenerNombre());
    
    //GUARDAMOS LOS DATOS DEL INGRESO PENDIENTE,esperando confirmacion del segundo sensor
    uidPendiente=uidRecibido;
    plazaPendiente=plazaEntrada;
    ingresoPendiente=true;
    
    //CALCULAMOS LOS CREDITOS QUE QUEDARAN DESPUES DEL INGRESO
    int CreditosRestantes=usuario.obtenerSaldo()-1;
    
    //ENVIAMOS LA AUTORIZACION Y EL NOMBRE A ARDUINO
    comunicacion.enviarMensaje("AUTORIZADO:"+usuario.obtenerNombre()+":"+CreditosRestantes+":"+plazaPendiente);
    
    //ACTUALIZAMOS ESTADO
     actualizarEstado("Ingreso autorizado",usuario.obtenerNombre()+" - Plaza "+plazaPendiente,verde);
    
    println("Esperando la confrimacion del segundo sensor");
   
}



//AUTORIZAMOS EGRESO DEL ESTACIONAMIENTO
void autorizarSalida(){

  //VERIFICAMOS QUE NO HAYA OTRA SALIDA PENDIENTE
  if(salidaPendiente||ingresoPendiente){
    println("Ya existe una salida pendiente");
    return;
  }
    
  //VERIFICAMOS QUE TENEMOS UN UID
  if(uidRecibido.isEmpty()){
    println("No se recibio ninguna tarjeta");
    return;
  }
  
  //BUSCAMOS LA PLAZA QUE OCUPA EL USUARIO
  int plazaSalida=estacionamiento.buscarPlazaPorUID(uidRecibido);
  
  //VERIFICAMOS SI EL USUARIO ESTA ESTACIONADO
  if(plazaSalida==-1){
    println("El usuario no esta estacionado");
    comunicacion.enviarMensaje("ERROR:NO ESTACIONADO");
    
    //ACTUALIZAMOS ESTADO
    actualizarEstado("Salida rechazada","Usuario no estacionado",rojo);
    return;
  }
  
  //GUARDAMOS LA SALIDA PENDIENTE
  plazaSalidaPendiente=plazaSalida;
  salidaPendiente=true;
  
  //ENVIAMOS LA AUTORIZACION A ARDUINO
  comunicacion.enviarMensaje("AUTORIZAR_SALIDA");
  
  //ACTUALIZAMOS ESTADO
  actualizarEstado("Salida autorizada","Vehiculo de la plaza "+plazaSalidaPendiente,azul);

  
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
  
  //ACTUALIZAMOS ESTADO
  actualizarEstado("Error de ingreso","No se pudo registrar el vehiculo",rojo);

  //LIMPIAMOS LAS VARIABLES PENDIENTES
  uidPendiente="";
  plazaPendiente=0;
  ingresoPendiente=false;
  uidRecibido="";

  return;
}

//BUSCAMOS AL USUARIO AUTORIZADO
Usuario usuario=gestor.buscarUsuario(uidPendiente);

if (usuario == null) {
  println("Error: usuario pendiente no encontrado");
  println("El vehiculo ingreso, pero no se pudo identificar al usuario");

  //ACTUALIZAMOS ESTADO
  actualizarEstado("Error de ingreso","Usuario no encontrado",rojo);
  
  // LIMPIAMOS LAS VARIABLES PENDIENTES
  uidPendiente = "";
  plazaPendiente = 0;
  ingresoPendiente = false;
  uidRecibido = "";

  return;
}

//DESCONTAMOS UN CREDITO
boolean descontado=usuario.descontarIngreso();

if (!descontado) {
  println("Error al descontar credito");
  println("El vehiculo ingreso, pero el saldo no se actualizo");
  
  //ACTUALIZAMOS ESTADO
  actualizarEstado("Error de ingreso","No se pudo actualizar el saldo",rojo);

  // LIMPIAMOS LAS VARIABLES PENDIENTES
  uidPendiente = "";
  plazaPendiente = 0;
  ingresoPendiente = false;
  uidRecibido = "";

  return;
}

//GUARDAMOS EL SALDO ACTUALIZADO
gestor.guardarUsuarios();//solo actualizamos el saldo

  println("Ingreso confirmado");
  println("Usuario: " + usuario.obtenerNombre());
  println("Plaza: " + plazaPendiente);
  println("Saldo restante: " + usuario.obtenerSaldo());


//ACTUALIZAMOS ESTADO
actualizarEstado("Ingreso confirmado",usuario.obtenerNombre()+" - Plaza "+plazaPendiente+" - Creditos restantes: "+usuario.obtenerSaldo(),verde);

  // LIMPIAMOS LAS VARIABLES PENDIENTES
  uidPendiente = "";
  plazaPendiente = 0;
  ingresoPendiente = false;
  uidRecibido = "";
}



//CONFIRMAMOS SALIDA DEL ESTACIONAIENTO
void confirmarSalida(){
  
  if(!salidaPendiente){
    println("No hay ninguna salida pendiente");
    return;
  }
  
  //REGISTRAMOS LA SALIDA DEL VEHICULO
  boolean salidaRegistrada=estacionamiento.registrarSalida(plazaSalidaPendiente);
  
  if(!salidaRegistrada){
    println("Error al registrar la salida");
    
    //ACTUALIZAMOS ESTADO
    actualizarEstado("Error de salida","No se pudo registrar la salida",rojo);
    //LIMPIAMOS LAS VARIABLES PENDIENTES
      plazaSalidaPendiente=0;
      salidaPendiente=false;
      uidRecibido="";
    return;
  }
  
  //MOSTRAMOS LA CONFIRMACION
  println("Salida confirmada de la plaza"+plazaSalidaPendiente);
  
  //ACTUALIZAMOS ESTADO
  actualizarEstado("Salida confirmada","Plaza"+plazaSalidaPendiente+"liberada",verde);
  
  //LIMPIAMOS LAS VARIABLES PENDIENTES
  plazaSalidaPendiente=0;
  salidaPendiente=false;
  uidRecibido="";
  
}
    
    
//GUARDAMOS LOS REGISTROS
void guardarRegistro(){

// VERIFICAMOS QUE EL CAMPO CREDITOS NO ESTE VACIO
  if (creditosRegistro.trim().isEmpty()) {
    println("Error: ingrese los creditos");
    return;
  }

  
//convertimos a int el string creditos
int saldo=int(creditosRegistro);


boolean registrado=gestor.registrarUsuario(nombreRegistro,uidRegistro,saldo);

if(!registrado){
  println("Usuario registrado incorrectamente");
  return;
}
else{
  println("Usuario registrado correctamente");

  nombreRegistro = "";
  uidRegistro = "";
  creditosRegistro = "";
  uidRecibido="";

  mostrandoRegistro = false;//Aca salimos de la interface del registro de usuarios
  campoActivo = 0;
}

}

void guardarCreditos(){
  //VERIFICAMOS QUE EL CAMPO CREDITO NO ESTE VACIO
  if(creditosCargar.trim().isEmpty()){
    println("Error:ingrese los creditos");
    return;
  }
  
  //CONVERTIMOS A ENTERO EL STRING CREDITOS
  int creditos=int(creditosCargar);
  
boolean creditoCargado=gestor.cargarSaldo(uidCargarCreditos,creditos);

if(!creditoCargado){
  println("Creditos cargados incorrectamente");
  return;
}
else{
  println("Creditos cargados correctamente");
  
  
  uidCargarCreditos="";
  nombreCargarCreditos="";
  creditosCargar="";

//SALIR DE LA VENTANA CARGAR CREDITOS
mostrandoCargaCreditos=false;
campoActivo=0;
}
}




// CERRAR CONEXION
void dispose() {

  if (comunicacion != null) {
    comunicacion.desconectar();
  }
}
