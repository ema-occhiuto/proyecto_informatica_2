class Usuario{
 //ATRIBUTOS PRIVADOS
 
 private String nombre;
 private String uid;
 private int saldo;

 
 //CONSTRUCTOR 
 public Usuario(String nombre,String uid,int saldo){
   this.nombre=nombre;
   this.uid=uid;
   this.saldo=max(0,saldo);//Evitamos saldos negativos
 }
 
 //OBTENER NOMBRE
 public String obtenerNombre(){
   return nombre;
 }
 
 //OBTENER UID
 public String obtenerUID(){
   return uid;
 }
 
 //OBTENER SALDO
 public int obtenerSaldo(){
   return saldo;
 }
 
 //Cargar saldo
 public void cargarSaldo(int cantidad){
   if(cantidad>0){
     saldo+=cantidad;
   }
 }
   
   //Descontar saldo
   
   public boolean descontarIngreso(){
     if(saldo>0){
       saldo--;
       return true;
     }
      return false;
     }
     
 }
     
   
