/*Crea un programa que use un Switch para mostrar el nombre del día de la semana según un número del 1 al 7 ingresado por el usuario*/
void mostrarDiaSemana(int numero) {
  switch (numero) {
    case 1:
      print("Lunes");
      break;
    case 2:
      print("Martes");
      break;
    case 3:
      print("Miércoles");
      break;
    case 4:
      print("Jueves");
      break;
    case 5:
      print("Viernes");
      break;
    case 6:
      print("Sábado");
      break;
    case 7:
      print("Domingo");
      break;
    default:
      print("Número inválido. Por favor ingresa un número del 1 al 7.");
  }
}

/*Crea una clase Vehiculo con un método mover().Luego crea clases Auto y Bicicleta que hereden de Vehiculo y redefinan el método mover*/
class Vehiculo {
  void mover() {
    print("El vehículo se está moviendo.");
  }
}

class Auto extends Vehiculo {
  @override
  void mover() {
    print("El auto se está moviendo.");
  }
}

class Bicicleta extends Vehiculo {
  @override
  void mover() {
    print("La bicicleta se está moviendo.");
  }
}

/*Crea una clase CuentaBancaria con los atributos titular y saldo.Implementa métodos depositar() y retirar() usando operadores y condiciones para evitar retiros mayores al saldo*/
class CuentaBancaria {
  String titular;
  double saldo;

  CuentaBancaria(this.titular, this.saldo);

  void depositar(double monto) {
    saldo += monto;
  }

  void retirar(double monto) {
    if (monto <= saldo) {
      saldo -= monto;
    } else {
      print("Fondos insuficientes.");
    }
  }
}

/*Crea un programa donde se creen objetos Rectangulo y Circulo, se almacenen en una lista de tipo List<Figura> y se recorra la lista llamando al método calcularArea() para demostrar polimorfismo dinámico.*/
abstract class Figura {
  double calcularArea();
}

class Rectangulo extends Figura {
  double base;
  double altura;
  Rectangulo(this.base, this.altura);
  @override
  double calcularArea() {
    return base * altura;
  }
}

class Circulo extends Figura {
  double radio;
  Circulo(this.radio);
  @override
  double calcularArea() {
    return 3.1416 * radio * radio;
  }
}

void main() {
  print("Ingrese un número del 1 al 7 para mostrar el día de la semana:");
  int numero = 5;
  mostrarDiaSemana(numero);
  /*Declara una lista de tipo List<int> con cinco números.usa un for para recorrer la lista y mostrar el cuadrado de cada número*/
  List<int> numeros = [1, 2, 3, 4, 5];
  for (int numero in numeros) {
    print("El cuadrado de $numero es ${numero * numero}");
  }
}
