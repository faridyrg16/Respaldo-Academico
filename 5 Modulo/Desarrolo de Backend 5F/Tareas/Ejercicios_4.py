def leer_numero(mensaje):
    while True:
        entrada = input(mensaje).strip().replace(',', '.')
        try:
            numero = float(entrada)
            return numero
        except ValueError:
            print("Entrada inválida. Por favor, ingresa solo números.")
def saludar_xgente():
    cantidad = int(leer_numero("¿Cuántas personas desea saludar? "))
    for i in range(1, cantidad + 1):
        print(f"Hola, amigo {i}")
saludar_xgente()
