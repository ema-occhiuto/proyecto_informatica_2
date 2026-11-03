Usuario usuario1;

void setup() {

  size(800, 500);

  usuario1 = new Usuario("Emanuel", "E6BBBC06", 5);

  println("Nombre: " + usuario1.obtenerNombre());
  println("UID: " + usuario1.obtenerUID());
  println("Saldo inicial: " + usuario1.obtenerSaldo());

  usuario1.cargarSaldo(3);

  println("Saldo despues de cargar: " + usuario1.obtenerSaldo());

  usuario1.descontarIngreso();

  println("Saldo final: " + usuario1.obtenerSaldo());
}

void draw() {
  background(240,240);
}
