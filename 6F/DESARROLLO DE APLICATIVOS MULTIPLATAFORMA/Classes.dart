class Persona {
  String name;
  int age;
  String city;

  Persona(this.name, this.age, this.city);
  void Presentarse(Persona persona) {
    print(
      "Hola, mi nombre es ${persona.name}, tengo ${persona.age} años y vivo en ${persona.city}.",
    );
  }

  void saludar(Persona persona) {
    print("Hola ${persona.name}, ¿cómo estás?");
  }
}

void main() {
  Persona p1 = Persona("Juan", 30, "Madrid");
  Persona p2 = Persona("Farid", 25, "Cusco");

  print("Nombre: ${p1.name}");
  print("Edad: ${p1.age}");
  print("Ciudad: ${p1.city}");
  p1.Presentarse(p1);
  p2.saludar(p2);
}
