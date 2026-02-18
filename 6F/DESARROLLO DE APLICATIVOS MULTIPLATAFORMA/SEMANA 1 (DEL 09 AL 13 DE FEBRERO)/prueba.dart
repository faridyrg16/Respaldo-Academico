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

void mayorDeEdad() {
  //if else switch for while do-while
  int edad = 20;
  if (edad >= 18) {
    print("Es mayor de edad");
  } else if (edad < 13) {
    print("Es menor de edad");
  }
}

void Positivo() {
  int a = 5;
  if (a > 0) {
    print('positivo');
  } else if (a < 0) {
    print('negativo');
  } else {
    print('cero');
  }
}

void ParImpar() {
  int numero = 10;
  if (numero % 2 == 0) {
    print('par');
  } else {
    print('impar');
  }
}

void MayorMenor() {
  int num1 = 5;
  int num2 = 10;
  if (num1 > num2) {
    print('num1 es mayor que num2');
  } else if (num1 < num2) {
    print('num1 es menor que num2');
  } else {
    print('num1 y num2 son iguales');
  }
}

void SwitchCase() {
  int dia = 3;
  switch (dia) {
    case 1:
      print('Lunes');
      break;
    case 2:
      print('Martes');
      break;
    case 3:
      print('Miércoles');
      break;
    case 4:
      print('Jueves');
      break;
    case 5:
      print('Viernes');
      break;
    case 6:
      print('Sábado');
      break;
    case 7:
      print('Domingo');
      break;
    default:
      print('Número de día inválido');
  }
}

void WhileLoop() {
  int i = 0;
  while (i < 5) {
    print(i);
    i++;
  }
}

void ramdom() {
  for (int i = 0; i < 3; i++) {
    print('i = $i');
  }

  List<String> names = ['Ana', 'Luis', 'Eva'];
  for (var name in names) {
    print(name);
  }
}
