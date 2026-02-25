import 'dart:math';

class Animal {
  String Nombre;
  static final random = Random();
  static const List<String> carnes = [
    'carne',
    'pollo',
    'res',
    'pescado',
    'cordero',
  ];
  Animal(this.Nombre);
  void comer() {
    final alimento = carnes[random.nextInt(carnes.length)];
    print('$Nombre come $alimento.');
  }
}

class Perro extends Animal {
  String Raza;
  Perro(super.nombre, this.Raza);
  void ladrar() => print('$Nombre ladra!');
}

class Gato extends Animal {
  String Raza;
  Gato(super.nombre, this.Raza);
  void Maulla() => print('$Nombre Miahugo!');
}

void main() {
  Perro m1 = Perro("Yucrecio", "Chaku");
  Perro m2 = Perro("Blanca", "Meztiso");
  Gato m3 = Gato("Teresa", "Angora");
  Gato m4 = Gato("Anita", "pelao");

  print("=== PERROS ===");
  print("Nombre: ${m1.Nombre} - Raza: ${m1.Raza}");
  m1.comer();
  print("Nombre: ${m2.Nombre} - Raza: ${m2.Raza}");
  m2.comer();
  print("=== GATOS ===");
  print("Nombre: ${m3.Nombre} - Raza: ${m3.Raza}");
  m3.comer();
  print("Nombre: ${m4.Nombre} - Raza: ${m4.Raza}");
  m4.comer();
}
