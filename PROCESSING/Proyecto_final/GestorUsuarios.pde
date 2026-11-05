
import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.IOException;



class GestorUsuarios{
  
  //Lista de usuarios
  private Nodo primero;//creamos el primero nodo
  private String archivo;//Va guardar la ruta de almacenamiento del archivo
  
  
  //Constructor
  public GestorUsuarios(String archivo){//se ejecuta cuando creamos un objeto en main
    primero=null;//Lista inicialmente vacia
    this.archivo=archivo;
  }
  

  //BUSCAR USUARIO POR UID
  public Usuario buscarUsuario(String uid){//esta funcion devuelve un usuario
  
  if(uid==null){
    return null;
  }
  Nodo aux=primero;
  
  while(aux!=null){
    
    if(aux.usuario.obtenerUID().equalsIgnoreCase(uid.trim())){//cuando encuentra el usuario por el uid, devuelve ese usuario
    
      return aux.usuario;//.equalsIgnoreCase esto compara el uid de la lista usuario con el uid ingresado por el teclado
    }
    aux=aux.next;
    }
       return null;
  }
  
  
  // AGREGAR NODO AL FINAL DE LA LISTA
  
  private void agregarNodo(Usuario usuario){
    Nodo nuevo=new Nodo(usuario);//nuevo objeto de la clase nodo
     
     if(primero==null){
       primero=nuevo;
       return;
     }
     //recorremos la lista enlzada hasta el ultimo nodo
     
     Nodo aux=primero;
     
     while(aux.next!=null){
       aux=aux.next;
     }
     
     //ENLAZAMOS EL NUEVO NODO
     aux.next=nuevo;
  }
  
  
   //REGISTRAR USUARIO
  public boolean registrarUsuario(String nombre,String uid,int saldo){
    
     if (nombre == null || uid == null ||
        nombre.trim().isEmpty() || uid.trim().isEmpty() ||
        saldo < 0 || nombre.contains(",") || nombre.contains("\n") ||
        nombre.contains("\r") || uid.contains(",")) {
      return false;
    }//esta for comprueba que los datos ingresados sean ingresados correctamente, de lo contrario devuelve false
    
    //COMPROBAMOS QUE LA TARJETA YA EXISTA
    if(buscarUsuario(uid)!=null){//funcion que pertenece a gestor usuarios
      return false;
    }
    
   //CREAMOS USUARIO
   Usuario nuevo=new Usuario(nombre.trim(),uid.trim(),saldo);//Aca es como crear un objeto de class Usuario, denominado nuevo
   
   
   // GUARDAMOS SOLO EL USUARIO NUEVO
     if (!guardarUsuarioNuevo(nuevo)) {
       return false;
   }

   
   //AGREGAR A LISTA
   agregarNodo(nuevo);//agregamos a la lista el nuevo usuario
      
  
   return true;
  }
  
  //CARGAR CREDITOS
  public boolean cargarSaldo(String uid,int cantidad){
    
    Usuario usuario=buscarUsuario(uid);//busca el usuario
    
    if(usuario==null||cantidad<=0){
      return false;
    }
    //CARGARMOS SALDO
    usuario.cargarSaldo(cantidad);//Aca carga el saldo dentro de la funcion cargarSaldo proveniente de la lista usuario
    
    guardarUsuarios();
    
    return true;
  }
  
  
  //DESCONTAR UN INGRESO
  public boolean descontarIngreso(String uid){
    
    Usuario usuario=buscarUsuario(uid);//buscamos el usuario con su uid dentro de la lista enlazada
    
    if(usuario==null){
    return false;
    }
    
    if(usuario.descontarIngreso()){//la funcion descontarIngreso, devuelve true si lo desconto con exito
    guardarUsuarios();
    return true;
    }
    return false;
  }
  
  
  //GUARDAR USUARIOS EN ARCHIVO
  public void guardarUsuarios(){
    
 PrintWriter output = createWriter(sketchPath(archivo));//lo creamos con el nombre del archivo
   
   //ENCABEZADO DEL ARCHIVO
   output.println("nombre,uid,saldo");
   
   //COMENZAMOS POR EL PRIMER NODO
   Nodo aux=primero;
   
   //RECORREMOS LA LISTA
   while(aux!=null){
      output.println(
      aux.usuario.obtenerNombre() + "," +
      aux.usuario.obtenerUID() + "," +
      aux.usuario.obtenerSaldo()
    );
    
    //AVANZAMOS AL SIGUIENTE NODO
    aux=aux.next;
   }

  output.flush();
  output.close();
}

    
    
  // GUARDAR UN USUARIO NUEVO EN MODO APPEND
  public boolean guardarUsuarioNuevo(Usuario usuario) {

    File fichero = new File(sketchPath(archivo));

    boolean encabezado = !fichero.exists() || fichero.length() == 0;

    try {

      FileWriter fw = new FileWriter(fichero, true);
      PrintWriter output = new PrintWriter(fw);

      // SI EL ARCHIVO ESTA VACIO, ESCRIBIMOS EL ENCABEZADO
      if (encabezado) {
        output.println("nombre,uid,saldo");
      }

      // GUARDAMOS SOLAMENTE EL NUEVO USUARIO
      output.println(
        usuario.obtenerNombre() + "," +
        usuario.obtenerUID() + "," +
        usuario.obtenerSaldo()
      );

      output.close();

      return !output.checkError();

    } catch (IOException e) {

      println("Error al guardar usuario: " + e.getMessage());
      return false;
    }
  }

    
    
    
    
    
// CARGAR USUARIOS DESDE ARCHIVO
  public void cargarUsuarios() {

    File fichero = new File(sketchPath(archivo));

    if (!fichero.exists()) {
      println("No existe el archivo de usuarios.");
      return;
    }

    // LEEMOS LAS LINEAS DEL ARCHIVO
  String[] lineas = loadStrings(sketchPath(archivo));

    if (lineas == null) {
      println("No se pudo leer el archivo.");
      return;
    }

    // VACIAMOS LA LISTA ENLAZADA
    primero = null;

    // EMPEZAMOS EN 1 PORQUE LA FILA 0 ES EL ENCABEZADO
    for (int i = 1; i < lineas.length; i++) {

      String[] datos = split(lineas[i], ',');

      // VERIFICAMOS QUE EXISTAN TRES CAMPOS
      if (datos.length != 3) {
        continue;
      }

      String nombre = trim(datos[0]);
      String uid = trim(datos[1]);

      int saldo;

      // CONVERTIMOS EL SALDO A ENTERO
      try {
        saldo = Integer.parseInt(trim(datos[2]));
      }
      catch (NumberFormatException e) {
        continue;
      }

      // VALIDAMOS LOS DATOS
      if (nombre.isEmpty() || uid.isEmpty() || saldo < 0) {
        continue;
      }

      // EVITAMOS USUARIOS DUPLICADOS
      if (buscarUsuario(uid) == null) {

        Usuario nuevo = new Usuario(nombre, uid, saldo);

        // AGREGAMOS EL USUARIO A LA LISTA
        // SIN GUARDAR EL ARCHIVO OTRA VEZ
        agregarNodo(nuevo);
      }
    }
  }


  // MOSTRAR USUARIOS EN CONSOLA
  public void mostrarUsuarios() {

    Nodo actual = primero;

    while (actual != null) {

      Usuario usuario = actual.usuario;

      println("Nombre: " + usuario.obtenerNombre());
      println("UID: " + usuario.obtenerUID());
      println("Saldo: " + usuario.obtenerSaldo());
      println("---------------------------------");

      actual = actual.next;
    }
  }
}
