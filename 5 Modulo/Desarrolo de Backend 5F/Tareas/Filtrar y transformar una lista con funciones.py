def es_par(numero):
  return numero % 2 == 0

def cuadrado(numero):
  return numero ** 2

def procesar_lista(lista_numeros, filtro, transformacion):
  lista_filtrada = []
  for numero in lista_numeros:
    if filtro(numero):
      lista_filtrada.append(numero)
  
  lista_transformada = []
  for numero in lista_filtrada:
    lista_transformada.append(transformacion(numero))
    
  return lista_transformada

def principal():
  entrada_usuario = input("Introduce una lista de números (separados por comas): ")
  
  lista_numeros = []
  try:
    numeros_str = entrada_usuario.split(',')
    for num_str in numeros_str:
      lista_numeros.append(int(num_str.strip()))
  except ValueError:
    print("Error: Asegúrate de introducir solo números separados por comas.")
    return

  print(f"\nLista original: {lista_numeros}")
  pares_al_cuadrado = procesar_lista(lista_numeros, es_par, cuadrado)
  print(f"Pares al cuadrado: {pares_al_cuadrado}")
  es_impar = lambda n: not es_par(n)
  multiplicar_por_3 = lambda n: n * 3
  
  impares_por_3 = procesar_lista(lista_numeros, es_impar, multiplicar_por_3)
  print(f"Impares por 3: {impares_por_3}")

principal()
