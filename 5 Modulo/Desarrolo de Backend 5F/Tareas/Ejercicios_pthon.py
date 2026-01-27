''' # Ejercicios de Python
1- crear una funcion que reciva  2 numeros y defina el mayor de ellos
2- suma de tres nuemros defina una funcion que devuelva suma de 3 numeros
3- escriba una funcion que muestre un mensaje aleatorio ""
4- crea una funcion que devuelva true si el numero es par y false si es impar
5- escribir una funcion  que determine si una palabra es palindroma o sea si se lee igual de izquierda a derecha y de derecha a izquierda debe validar que no haya espacios en blanco y no distinga entre mayusculas y minusculas
'''
# librerias
import random

numero1 = int(input("Introduce el primer número: "))
numero2 = int(input("Introduce el segundo número: "))
numero3 = int(input("Introduce el tercer número: "))

def encontrar_mayor(num1, num2):
  if num1 > num2:
    return num1
  else:
    return num2
mayor = encontrar_mayor(numero1, numero2)
print(f"El número mayor es: {mayor}")

def suma_de_tres(a, b, c):
    return numero1 + numero2 + numero3

print(suma_de_tres(numero1, numero2, numero3))

def mensaje_aleatorio():
    mensajes = ["Hola", "Bienvenido", "Adiós", "Gracias", "Buen día", "¿Cómo estás?", "Éxitos", "Felicidades", "Nos vemos", "Hasta pronto"]
    return random.choice(mensajes)

print(mensaje_aleatorio())

def es_par(numero):
    if numero % 2 == 0:
        return f"El número {numero} es par"
    else:
        return f"El número {numero} es impar"

print(es_par(numero1))
print(es_par(numero2))
print(es_par(numero3))

def es_palindromo(palabra):
    if palabra := palabra.replace(" ", "").lower():
        return palabra == palabra[::-1]
    return f"El texto '{palabra}' no es palíndromo."
palabra = input("Introduce una palabra o frase: ")
if es_palindromo(palabra):
    print(f'"{palabra}" es un palíndromo.')