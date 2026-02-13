void main() {
  print("hola mundo");

  // Declaramos tipos de datos Dart
  int numero = 4;
  double decimal = 5.5;
  String texto = "Programación";
  bool activo = true;
  List lista = [1, 2, 3, 4, 5];
  Set conjunto = {10, 20, 30};
  Map mapa = {'nombre': 'Juan', 'edad': 25};

  // Mostramos los datos
  print("int: $numero");
  print("double: $decimal");
  print("String: $texto");
  print("bool: $activo");
  print("List: $lista");
  print("Set: $conjunto");
  print("Map: $mapa");

  String nombreCompleto(String nombre, String apellido) {
    return "$nombre $apellido";
  }

  int edad;
  double Precio;
  bool estado_civil;
  int codigo;
  var codigo2;

  codigo = 2026;
  codigo2 = "F001";
  edad = 30;
  Precio = 2.5;
  estado_civil = true;

  nombreCompleto("Juan", "Pérez");
  print("Edad: $edad");
  print("Precio: $Precio");
  print("Estado Civil: $estado_civil");
  print("Código: $codigo");
  print("Código 2: $codigo2");
}
