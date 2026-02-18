import 'dart:ffi';
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
    double var1 = 10.0;
  double var2 = 5;
  String operacion = '+';
  double multi = var1 * var2;
  double resta = var1 - var2;
  double suma = var1 + var2;
  calculadora(var1, var2, operacion);
  print('suma: ${suma}');
  print('resta: ${resta}');
  print('multiplicacion: ${multi}');
  print(var1 == var2);
  print(var1 != var2);
  print(var1 > var2);
  print(var1 < var2);
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

    //estructuras de control
  //if, else if, else
  int edad = 20;
  if (edad < 18) {
    print("Menor");
  } else if (edad >= 18 && edad < 65) {
    print("Mayor");
  } else {
    print("Adulto mayor");
  }

  //switch
  String dia = "Lunes";
  switch (dia) {
    case "Lunes":
    case "Viernes":
      print("Inicio/fin");
      break;
    default:
      print("Dia Laboral");
  }

  //Estructuras de repetición
  //for
  for (int i = 0; i < 10; i++) {
    print(i);
  }
  int contador = 0;
  while (contador < 5) {
    print(contador);
    contador++;
  }
  int num = 0;
  do {
    print(num);
    num++;
  } while (num < 10);
}

void calculadora(double num1, double num2, String operacion) {
  double resultado;

  switch (operacion) {
    case '+':
      resultado = num1 + num2;
      break;
    case '-':
      resultado = num1 - num2;
      break;
    case '*':
      resultado = num1 * num2;
      break;
    case '/':
      if (num2 != 0) {
        resultado = num1 / num2;
      } else {
        print("Error: No se puede dividir por cero.");
        return;
      }
      break;
    default:
      print("Operación no válida.");
      return;
  }
  print("El resultado de $num1 $operacion $num2 es: $resultado");
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


