class Estacionamiento{
  
  //ATRIBUTOS PRIVADOS
  private String [] plazas;
  private int capacidadMaxima;
  private String archivo="estacionamiento.csv";
  
  //CONSTRUCTOR
  public Estacionamiento(int capacidadMaxima){
    
    this.capacidadMaxima=capacidadMaxima;
    
    //CREAMOS EL ARREGLO DE PLAZAS
    plazas=new String[capacidadMaxima];//creamos un array list, tipo string denominado plazas,(solo almacena el uid que ocupa cada plaza)
  }
  
  
  
  
  //VERIFICAR SI UNA PLAZA ESTA LIBRE
  public boolean plazaLibre(int numeroPlaza){
  
  if(numeroPlaza<1||numeroPlaza>capacidadMaxima){
    return false;
  }
  
  if(plazas[numeroPlaza-1]==null){//si la plaza esta libre, devuelve true
    return true;
  }
 else{
   return false;//devuelve false si esta ocupada
 }
}




//VERIFICAMOS SI HAY ALGUN LUGAR DISPONIBLE
public boolean hayLugar(){
  for(int i=0;i<capacidadMaxima;i++){
    
    if(plazas[i]==null){//verifica los lugares disponibles
      
      return true;
    }
  }
  return false;
}




//REGISTRAR INGRESO de un vehiculo

public boolean registrarIngreso(int numeroPlaza,String uid){
  
  //VERIFICAMOS EL UID
  if(uid==null||uid.trim().isEmpty()){//trim elimina espacios y empty verifica que no este vacio
    return false;
  }
  
  //VERIFICAMOS QUE LA PLAZA ESTE LIBRE
  if(!plazaLibre(numeroPlaza)){
    return false;
  }
  
  //EVITAMOS QUE UN MISMO UID OCUPE DOS PLAZAS 
  for(int i=0;i<capacidadMaxima;i++){
    
    if (plazas[i] != null &&
          plazas[i].equalsIgnoreCase(uid.trim())) 
      {
        return false;
      }
    }
    
    //ASIGAMOS EL UID A LA PLAZA
    plazas[numeroPlaza-1]=uid.trim();//se guarda sin los espacios
    guardarPlazas();//Guardamo la plaza en el archivo
    
    return true;
}



//REGISTRAR SALIDA DE UN VEHICULO

public boolean registrarSalida(int numeroPlaza){
 
  //verificamos que el numero sea valido
  if(numeroPlaza<1||numeroPlaza>capacidadMaxima){
    return false;
  }
  
  //VERIFICAMOS QUE ESTE OCUPADA
  if(plazaLibre(numeroPlaza)){
    return false;//ya que la plaza esta libre
  }
  
  //LIBERAMOS LA PLAZA
  plazas[numeroPlaza-1]=null;//vaciamos esa plaza
  guardarPlazas();
  
  return true;//plaza liberada
}


//GUARDAR EL ESTADO DE LAS PLAZAS EN UN ARCHIVO CSV
public void guardarPlazas(){
  PrintWriter salida=createWriter(sketchPath(archivo));
  
  salida.println("plaza,uid");//encabezado del archivo
  
  for(int i=0;i<capacidadMaxima;i++){
    if(plazas[i]==null){
      salida.println((i+1)+",LIBRE");
    }else{
      salida.println((i+1)+","+plazas[i]);//Aca se guarda el uid en el archivo, en la plaza ocupada.
    }
  }
   salida.flush();
   salida.close();//cierra el archivo
}



//RECUPERAR LAS PLAZAS GUARDADAS EN UN ARCHIVO CSV
public void cargarPlazas(){
  
  String[] lineas=loadStrings(archivo);//Guardamos el archivo en un arreglo de cadenas
  
  if(lineas==null){
    return;
  }
  
  for(int i=1;i<lineas.length;i++){//Arrancamos desde i=1 porque i=0 contiene la cabezera del archivo
  String datos[]=split(lineas[i],',');
  
  if(datos.length==2){//2 datos, numero de plaza y uid
  
  int numeroplaza=int(datos[0]);//guardamos localmente el numero de la plaza
  
  if(numeroplaza>=1 && numeroplaza<=capacidadMaxima){
    
    String uid=trim(datos[1]);//Guardamos localmente el uid
    
    if(uid.equals("LIBRE")){
      plazas[numeroplaza-1]=null;//Guardamos el valor en la posicion 0 de la String plazas
    }else{
      plazas[numeroplaza-1]=uid;
    }
  }
  }
  }
}
  
  
  
  // OBTENER UID DE UNA PLAZA
  public String obtenerUID(int numeroPlaza) {

    if (numeroPlaza < 1 || numeroPlaza > capacidadMaxima) {
      return null;
    }

    return plazas[numeroPlaza - 1];//devuelve el uid de la plaza que eligimos
    
  }
  
  
  
 // CONTAR PLAZAS OCUPADAS
  public int obtenerOcupados() {

    int ocupados = 0;

    for (int i = 0; i < capacidadMaxima; i++) {

      if (plazas[i] != null) {
        ocupados++;
      }
    }

    return ocupados;
  }
  
  
    // CONTAR PLAZAS DISPONIBLES
  public int obtenerDisponibles() {

    return capacidadMaxima - obtenerOcupados();
  }
  
  
  // OBTENER CAPACIDAD MAXIMA
  public int obtenerCapacidadMaxima() {

    return capacidadMaxima;
  }


  // MOSTRAR ESTADO DE LAS PLAZAS
  public void mostrarPlazas() {

    println("----- ESTACIONAMIENTO -----");

    for (int i = 0; i < capacidadMaxima; i++) {

      if (plazas[i] == null) {
        println("Plaza " + (i + 1) + ": LIBRE");
      } else {
        println("Plaza " + (i + 1) + ": OCUPADA - UID: " + plazas[i]);
      }
    }

    println("Ocupados: " + obtenerOcupados());
    println("Disponibles: " + obtenerDisponibles());
  }
}

  
  
  
    
