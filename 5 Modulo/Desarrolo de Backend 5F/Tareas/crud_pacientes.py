import mysql.connector
print(mysql.connector.__version__)
config = {
    'user': 'root',
    'password': '',  # Cambia por tu contraseña real
    'host': 'localhost',
    'database': 'crud_pacientes'
}

conn = mysql.connector.connect(**config)
cursor = conn.cursor()

def crear_paciente(nombre, edad, diagnostico):
    cursor.execute("INSERT INTO pacientes (nombre, edad, diagnostico) VALUES (%s, %s, %s)", (nombre, edad, diagnostico))
    conn.commit()
    print("Paciente registrado con éxito.")

def leer_pacientes():
    cursor.execute("SELECT * FROM pacientes")
    for p in cursor.fetchall():
        print(f"ID: {p[0]}, Nombre: {p[1]}, Edad: {p[2]}, Diagnóstico: {p[3]}")

def actualizar_paciente(id, nombre, edad, diagnostico):
    cursor.execute("UPDATE pacientes SET nombre = %s, edad = %s, diagnostico = %s WHERE id = %s",
                   (nombre, edad, diagnostico, id))
    conn.commit()
    if cursor.rowcount > 0:
        print("Paciente actualizado.")
    else:
        print("Paciente no encontrado.")

def eliminar_paciente(id):
    cursor.execute("DELETE FROM pacientes WHERE id = %s", (id,))
    conn.commit()
    if cursor.rowcount > 0:
        print("Paciente eliminado.")
    else:
        print("Paciente no encontrado.")

def menu():
    while True:
        print("\n--- Sistema CRUD de Pacientes ---")
        print("1. Registrar paciente")
        print("2. Ver pacientes")
        print("3. Actualizar paciente")
        print("4. Eliminar paciente")
        print("5. Salir")

        opcion = input("Seleccione una opción: ")

        if opcion == "1":
            nombre = input("Nombre: ")
            edad = int(input("Edad: "))
            diagnostico = input("Diagnóstico: ")
            crear_paciente(nombre, edad, diagnostico)
        elif opcion == "2":
            leer_pacientes()
        elif opcion == "3":
            id = int(input("ID del paciente a actualizar: "))
            nombre = input("Nuevo nombre: ")
            edad = int(input("Nueva edad: "))
            diagnostico = input("Nuevo diagnóstico: ")
            actualizar_paciente(id, nombre, edad, diagnostico)
        elif opcion == "4":
            id = int(input("ID del paciente a eliminar: "))
            eliminar_paciente(id)
        elif opcion == "5":
            print("Saliendo...")
            break
        else:
            print("Opción no válida.")

if __name__ == "__main__":
    menu()
    cursor.close()
    conn.close()
