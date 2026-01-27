def leer_numero(prompt):
    while True:
        s = input(prompt).strip().replace(',', '.')
        try:
            numero = float(s)
            if 0 <= numero <= 10:
                return numero
            else:
                print("La nota debe estar en el rango de 0 a 10.")
        except ValueError:
            print("Entrada inválida. Por favor, ingresa solo números")

nota1 = leer_numero("Ingresa la primera nota: ")
nota2 = leer_numero("Ingresa la segunda nota: ")
nota3 = leer_numero("Ingresa la tercera nota: ")

promedio = (nota1 + nota2 + nota3) / 3

if promedio >= 7:
    print(f"Tu promedio es {promedio:.2f}. ¡Aprobaste!")
elif promedio >= 5 and promedio <= 6.9:
    print(f"Tu promedio es {promedio:.2f}. Necesitas recuperación.")
else: 
    print(f"Tu promedio es {promedio:.2f}. Reprobaste.")
    print("Debes mejorar tus notas.")