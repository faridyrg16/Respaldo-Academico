Si intentas ejecutar una instrucción INSERT INTO en la tabla usuarios y el valor proporcionado para la columna email no cumple con la restricción chk_email_valid_email, la operación de inserción fallará y la fila no se agregará a la tabla.

🚫 Detalle del Error
El sistema de gestión de bases de datos (SGBD) lanzará un error de restricción (CHECK constraint violation).

¿Por qué? La restricción CHECK está diseñada para asegurar que los datos en una o más columnas cumplan con una condición específica (en este caso, que el email tenga un formato de dirección de correo electrónico válido, verificado por la expresión regular). Si la condición es falsa, el SGBD rechaza la operación.

Mensaje de error: El mensaje exacto variará dependiendo del SGBD que estés usando (por ejemplo, MySQL, Oracle, PostgreSQL), pero indicará claramente que la operación ha fallado debido a una violación de la restricción CHECK con el nombre chk_email_valid_email.

Ejemplo (simulado): ERROR 3819 (HY000): Check constraint 'chk_email_valid_email' is violated.

💡 Ejemplo
Supongamos que intentas la siguiente inserción:

SQL

INSERT INTO usuarios (email) VALUES ('correoinvalido');
En este caso, la cadena 'correoinvalido' no coincide con el patrón de la expresión regular ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$ (le falta el @ y el dominio), por lo que:

El SGBD evalúa la condición del CHECK.

La condición es falsa.

La sentencia INSERT INTO es rechazada.

La base de datos no se modifica.

✅ Solución
Para que el INSERT INTO sea exitoso, debes proporcionar un email que sí cumpla con el formato:

SQL

INSERT INTO usuarios (email) VALUES ('usuario.ejemplo@dominio.com'); -- ¡Éxito!
