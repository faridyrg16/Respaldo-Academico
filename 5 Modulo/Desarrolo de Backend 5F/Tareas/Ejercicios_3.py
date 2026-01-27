def leer_numero(mensaje):
    while True:
        entrada = input(mensaje).strip().replace(',', '.')
        try:
            numero = float(entrada)
            return numero
        except ValueError:
            print("Entrada inválida. Por favor, ingresa solo números.")
numero1 = leer_numero("Ingresa el primer numero: ")
numero2 = leer_numero("Ingresa el segundo numero: ")
def sumar (a, b):
    resultado = a + b
    return resultado
resultadototal = sumar(numero1,numero2)
print(f"La suma es:  {resultadototal:.2f}.")
def restar (a, b):
    resultado = a - b
    return resultado
resultadototal = restar(numero1,numero2)
print(f"La resta  es:  {resultadototal:.2f}.")
def multiplicar (a, b):
    resultado = a * b
    return resultado
resultadototal = multiplicar(numero1,numero2)
print(f"La multiplicacion  es:  {resultadototal:.2f}.")
def dividir (a, b):
    if b == 0:
        return "Error: División por cero"
    resultado = a / b
    return resultado
resultadototal = dividir(numero1,numero2)
print(f"La division  es:  {resultadototal:.2f}.")
def calcular_promedio(notas):
    if len(notas) == 0:
        return 0
    suma = sum(notas)
    promedio = suma / len(notas)
    return promedio
notas = [numero1,numero2]
promedio = calcular_promedio(notas)
print(f"La promedio es:  {promedio:.2f}.")
def calcular_mayor(notas):
    if len(notas) == 0:
        return None
    mayor = max(notas)
    return mayor
mayor_nota = calcular_mayor(notas)
print(f"El numero mayor es:  {mayor_nota:.2f}.")
def calcular_menor(notas):
    if len(notas) == 0:
        return None
    menor = min(notas)
    return menor
menor_nota = calcular_menor(notas)
print(f"El numero menor es:  {menor_nota:.2f}.")

# Realizar una funcion para calcular el promedio de una lista de numeros
def promedio_lista():
    numeros = []
    cantidad = int(input("¿Cuántos números deseas ingresar para calcular el promedio? "))
    for _ in range(cantidad):
        numero = leer_numero("Ingresa un número: ")
        numeros.append(numero)
    promedio = calcular_promedio(numeros)
    return promedio
promedio_numeros = promedio_lista()
print(f"El promedio de los números ingresados es: {promedio_numeros:.2f}.")

promedio_numeros2=[10,20,30,40,50]
def promediodelista(promedio_numeros2):
    if len(promedio_numeros2) == 0:
        return 0
    suma = sum(promedio_numeros2)
    promedio = suma / len(promedio_numeros2)
    return promedio
promedio_final = promediodelista(promedio_numeros2)
print(f"El promedio de la lista predefinida es: {promedio_final:.2f}.")