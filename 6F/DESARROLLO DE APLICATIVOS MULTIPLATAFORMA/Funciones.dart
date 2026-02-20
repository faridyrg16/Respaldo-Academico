void saludar(String nombre) {
  print('Hola, $nombre!');
}

int sumar(int a, int b) {
  return a + b;
}

double division(double a, double b) {
  if (b == 0) {
    print("Error: La division por cero no esta permitida.");
    return 0;
  }
  return a / b;
}

void bienvenida() {
  print("Bienvenido a Dart! de parte de Farid");
}

int multiplicar(int a, int b) {
  return a * b;
}

String despedida(String nombre) {
  return 'Adios, $nombre!';
}

arrowFunction(int a, int b) => a * b;
void main() {
  bienvenida();
  saludar('Tuki');
  print(sumar(5, 3));
  print(division(10.0, 2.0));
  print(multiplicar(5, 3));
  print(arrowFunction(2, 2));

  //Lista
  List<int> numeros = [1, 2, 3, 4, 5];
  numeros.add(10);
  print(numeros.length);
  for (int f in numeros) {
    int numero = f + 4;
    print(numero);
  }
  numeros.remove(2);

  if (numeros.contains(4)) {
    print("El numero 4 esta en la lista.");
  } else {
    print("El numero 4 no esta en la lista.");
  }

  numeros.forEach((numero) {
    print(numero);
  });
  print(despedida('Farid'));
}
