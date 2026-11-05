class Estacionamiento{
  
  //ATRIBUTOS PRIVADOS
  private String [] plazas;
  private int capacidadMaxima;
  
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
  
  return true;//plaza liberada
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

  
  
  
    
