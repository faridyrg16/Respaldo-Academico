class figura {
  double area() => 0;
}

class Circlulo extends figura {
  double radio;
  Circlulo(this.radio);
  @override
  double.area() => 3.14.16 * radio * radio;
}

class Cuadrado extends figura{
  double lado;
  @override
  double area () => lado * lado;
  }

  void main (){
    List<figura> figuras =[Circlulo(5),Cuadrado(4)]; 
    for (var f in figuras){
      print(f.area());
    }
  }