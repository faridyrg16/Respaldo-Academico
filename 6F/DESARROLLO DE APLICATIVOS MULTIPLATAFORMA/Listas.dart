String mostarlista(List<String> lista) {
  return lista.join(', ');
}

void main() {
  List<String> nombres = ['Alice', 'Bob', 'Charlie', 'Diana', 'Javier'];
  print(nombres.last);
  print(nombres.first);
  print(nombres);
  nombres.add('Eve');
  nombres.add('Farid');
  nombres.remove('Bob');
  for (var (index, item) in nombres.indexed) {
    print('Índice: $index, Valor: $item');
  }
  print(mostarlista(nombres));
}
