/* ---------------------------------------------------------
   PASO 1: PREPARAR DATOS (POBLADO)
   Insertamos clientes y productos para poder hacer pruebas.
   --------------------------------------------------------- */
   
/* Limpiamos datos anteriores si existen para empezar limpio */
use ecommerce_khipu;
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE detalles_pedido;
TRUNCATE TABLE pagos;
TRUNCATE TABLE pedidos;
TRUNCATE TABLE productos;
TRUNCATE TABLE clientes;
SET FOREIGN_KEY_CHECKS = 1;

/* 1. Insertamos Clientes */
INSERT INTO clientes (nombre, apellido, email, direccion) VALUES 
('Juan', 'Perez', 'juan.perez@email.com', 'Av. Sol 123'),
('Maria', 'Gomez', 'maria.gomez@email.com', 'Calle Real 456');

/* 2. Insertamos Productos (Fíjate en el STOCK INICIAL) */
INSERT INTO productos (nombre, precio, stock) VALUES 
('Laptop Gamer', 3500.00, 10),      /* ID 1 - Stock 10 */
('Mouse Logitech', 50.00, 100),     /* ID 2 - Stock 100 */
('Teclado RGB', 150.00, 5);         /* ID 3 - Stock 5 */


/* ---------------------------------------------------------
   PASO 2: TRES (3) CASOS BUENOS
   Verificaremos que el Trigger descuente el stock.
   --------------------------------------------------------- */

/* CASO 1: Venta normal usando el Procedimiento Almacenado */
/* Juan compra 2 Laptops. Stock debe bajar de 10 a 8 */
CALL sp_registrar_pedido(1, 1, 2, 'TARJETA');

/* CASO 2: Otra venta normal */
/* Maria compra 5 Mouse. Stock debe bajar de 100 a 95 */
CALL sp_registrar_pedido(2, 2, 5, 'YAPE');

/* CASO 3: Inserción Manual (Directa) para probar el TRIGGER puro */
/* Vamos a simular que el sistema inserta un pedido "a mano" sin el procedimiento.
   Aquí comprobamos si el trigger salta solo. */
INSERT INTO pedidos (id_cliente, estado) VALUES (1, 'PENDIENTE');
/* Insertamos el detalle: Vendemos 1 Teclado (ID 3). Stock debe bajar de 5 a 4 */
INSERT INTO detalles_pedido (id_pedido, id_producto, cantidad, precio_unitario) 
VALUES (LAST_INSERT_ID(), 3, 1, 150.00);


/* ---------------------------------------------------------
   VERIFICACIÓN VISUAL
   Ejecuta esto para ver si los stocks bajaron (10->8, 100->95, 5->4)
   --------------------------------------------------------- */
SELECT * FROM productos;


/* ---------------------------------------------------------
   PASO 3: EL CASO QUE FALLA (INTEGRIDAD)
   --------------------------------------------------------- */

/* CASO 4: Intentar vender más de lo que hay */
/* Intentamos vender 20 Laptops. Solo quedan 8. */
/* Esto debe dar ERROR: "Stock insuficiente para realizar la venta" */

CALL sp_registrar_pedido(1, 1, 20, 'EFECTIVO');

/* NOTA: Si intentas hacer un INSERT manual que deje el stock en negativo, 
   fallará por la restricción CHECK (stock >= 0) que pusimos en la tabla productos. */