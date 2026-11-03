import java.util.ArrayList;
import java.io.File;




class GestorUsuarios{
  
  //Lista de usuarios
  private ArrayList<Usuario>usuarios;//creamos una lista llamada usuarios
  private String archivo;//Va guardar la ruta de almacenamiento del archivo
  
  
  //Constructor
  public GestorUsuarios(String archivo){//se ejecuta cuando creamos un objeto en main
    usuarios=new ArrayList<Usuario>();//crea una lista vacia,del espacio Usuario
    this.archivo=archivo;
  }
  
  //BUSCAR USUARIO POR UID
  public Usuario buscarUsuario(String uid){//esta funcion devuelve un usuario
  
  if(uid==null){
    return null;
  }
  
  for(Usuario usuario: usuarios){
    
    if(usuario.obtenerUID().equalsIgnoreCase(uid.trim())){//cuando encuentra el usuario por el uid, devuelve ese usuario
      return usuario;//.equalsIgnoreCase esto compara el uid de la lista usuario con el uid ingresado por el teclado
    }
    }
       return null;
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
    if(buscarUsuario(uid)!=null){
      return false;
    }
    
   //CREAMOS USUARIO
   Usuario nuevo=new Usuario(nombre.trim(),uid.trim(),saldo);//Aca es como crear un objeto de class Usuario, denominado nuevo
   
   //AGREGAR A LISTA
   usuarios.add(nuevo);//agregamos a la lista el nuevo usuario
      
   //GUARDAMOS EN EL ARCHIVO
   guardarUsuarios();
   
   return true;
  }
  
  //CARGAR CREDITOS
  public boolean cargarSaldo(String uid,int cantidad){
    
    Usuario usuario=buscarUsuario(uid);
    
    if(usuario==null||cantidad<0){
      return false;
    }
    
    usuario.cargarSaldo(cantidad);//Aca carga el saldo dentro de la funcion cargarSaldo proveniente de la lista usuario
    
    guardarUsuarios();
    
    return true;
  }
  
  
  //DESCONTAR UN INGRESO
  public boolean descontarIngreso(String uid){
    Usuario usuario=buscarUsuario(uid);//buscamos el usuario con su uid dentro del Array
    
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
    
    String[] lineas=new String[usuarios.size()+1];//crea un arreglo de cadena de textos, de tamano cantidad usuarios
    
    lineas[0]="nombre,uid,saldo";//encabezado del archivo
    
    for(int i=0;i<usuarios.size();i++){//va hasta la cantidad de usuarios registrados en Array list
    
    Usuario usuario=usuarios.get(i);//Obtiene el objeto Usuario que está en la posición i del ArrayList
    
     lineas[i + 1] =
        usuario.obtenerNombre() + "," +
        usuario.obtenerUID() + "," +
        usuario.obtenerSaldo();
    }
     saveStrings(archivo, lineas);//le pasamos el nombre del archivo y el string lineas
  }
    
    
    
  // CARGAR USUARIOS DESDE ARCHIVO
  public void cargarUsuarios() {

    File fichero = new File(sketchPath(archivo));

    if (!fichero.exists()) {
      println("No existe el archivo de usuarios.");
      return;
    }

    String[] lineas = loadStrings(archivo);//Creamos un arreglo llamado lineas , que almacenara los datos de archivo

    if (lineas == null) {
      println("No se pudo leer el archivo.");
      return;
    }

    usuarios.clear();//Borramos todos los datos del Array list llamado usuario

    // EMPEZAMOS EN 1 PORQUE LA FILA 0 ES EL ENCABEZADO
    for (int i = 1; i < lineas.length; i++) {

      String[] datos = split(lineas[i], ',');//este se encarga, de separar el nombre, uid y saldo. 

      if (datos.length != 3) {//Comprueba que haya exactamente tres campos: nombre, UID y saldo
        continue;
      }

      String nombre = trim(datos[0]);
      String uid = trim(datos[1]);

      int saldo;

      try {
        saldo = Integer.parseInt(trim(datos[2]));//Aca pasamos de cadena de texto, a un entero
      }
      catch (NumberFormatException e) {
        continue;
      }

      if (nombre.isEmpty() || uid.isEmpty() || saldo < 0) {//Comprobamos que los tres campos no esten vacios 
        continue;
      }

      if (buscarUsuario(uid) == null) {

        Usuario nuevo = new Usuario(nombre, uid, saldo);

        usuarios.add(nuevo);
      }
    }
  }



//MOSTRAMOS USUARIOS EN CONSOLA
public void mostrarUsuarios(){
  
  for(Usuario usuario:usuarios){//Esto es un for-each, sirve para recorrer el Array list usuarios 
  println("Nombre: "+usuario.obtenerNombre());
  println("UID: "+usuario.obtenerUID());
  println("Saldo: "+usuario.obtenerSaldo());
  println("---------------------------------");
  }
}
}
    
  
  
