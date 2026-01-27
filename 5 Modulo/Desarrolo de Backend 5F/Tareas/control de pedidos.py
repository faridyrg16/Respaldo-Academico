total = 0
cantidad_productos = 0
precio_maximo = 0

print("    CONTROL DE PEDIDO    ")
print("Ingrese los precios de los productos (0 o vacio para finalizar)\n")

while True:
    entrada = input("Ingrese el precio del producto: S/.").strip()
    if entrada == "":
        break
    try:
        precio = float(entrada)
    except ValueError:
        print("Por favor, ingrese un precio válido (mayor a 0)")
        continue
    if precio == 0:
        break
    if precio > 0:
        total += precio
        cantidad_productos += 1
        if precio > precio_maximo:
            precio_maximo = precio
    else:
        print("Por favor, ingrese un precio válido (mayor a 0)")
        
print("\n=== RESUMEN DEL PEDIDO ===")
print(f"Total del pedido: S/.{total:.2f}")
print(f"Número de productos: {cantidad_productos}")
print(f"Producto más caro: S/.{precio_maximo:.2f}")