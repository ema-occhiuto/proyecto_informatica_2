class Estacionamiento{
  
  //ATRIBUTOS PRIVADOS
  private String [] plazas;
  private int capacidadMaxima;
  
  //CONSTRUCTOR
  public Estacionamiento(int capacidadMaxima){
    
    this.capacidadMaxima=capacidadMaxima;
    plazas=new String[capacidadMaxima];//creamos un array list, tipo string denominado plazas
  }
  
  
  
  //VERIFICAR SI UNA PLAZA ESTA LIBRE
  public boolean plazaLibre(int numeroPlaza){
  
  if(numeroPlaza<1||numeroPlaza>capacidadMaxima){
    return false;
  }
  
  if(plazas[numeroPlaza-1]==null){
    return true;
  }
 else{
   return false;
 }
}


//VERIFICAMOS SI HAY ALGUN LUGAR
public boolean hayLugar(){
  if(int i=0;i<plazas.length;i++);
