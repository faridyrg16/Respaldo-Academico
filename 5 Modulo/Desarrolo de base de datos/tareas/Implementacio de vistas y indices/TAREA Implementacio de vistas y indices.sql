DROP DATABASE IF EXISTS tienda_demo;
CREATE DATABASE tienda_demo;
USE tienda_demo;

/*----------------------------------------------------------
  2. ELIMINAR TABLAS EN ORDEN (HIJO → PADRE)
----------------------------------------------------------*/
DROP TABLE IF EXISTS DetalleVenta;
DROP TABLE IF EXISTS Venta;
DROP TABLE IF EXISTS Producto;
DROP TABLE IF EXISTS Cliente;

/*----------------------------------------------------------
  3. CREAR TABLAS
----------------------------------------------------------*/

/* Tabla: Cliente */
CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  pais VARCHAR(50),
  UNIQUE INDEX unq_email (email)
);

/* Tabla: Producto */
CREATE TABLE Producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  categoria VARCHAR(50),
  precio DECIMAL(10,2),
  INDEX idx_nombre_producto (nombre)
);

/* Tabla: Venta */
CREATE TABLE Venta (
  id_venta INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  fecha DATE,
  total DECIMAL(12,2),
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  INDEX idx_fecha (fecha)
);

/* Tabla: DetalleVenta */
CREATE TABLE DetalleVenta (
  id_detalle INT AUTO_INCREMENT PRIMARY KEY,
  id_venta INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad INT,
  precio_unit DECIMAL(10,2),
  FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

/*----------------------------------------------------------
  4. INSERTAR DATOS ORIGINALES
----------------------------------------------------------*/
INSERT INTO Cliente (nombre, email, pais) VALUES
('Juan Perez','juan@ejemplo.com','Perú'),
('Ana Lopez','ana@ejemplo.com','España');

INSERT INTO Producto (nombre,categoria,precio) VALUES
('Laptop Pro','Electrónica',3500.00),
('Mouse','Electrónica',25.00);

INSERT INTO Venta (id_cliente,fecha,total) VALUES
(1,'2025-12-01',3525.00),
(2,'2025-11-15',25.00);

INSERT INTO DetalleVenta (id_venta,id_producto,cantidad,precio_unit) VALUES
(1,1,1,3500.00),
(1,2,1,25.00),
(2,2,1,25.00);

/*----------------------------------------------------------
  5. INSERTAR DATOS ADICIONALES (40+ DATOS)
----------------------------------------------------------*/

/* Clientes adicionales */
INSERT INTO Cliente (nombre, email, pais) VALUES
('Carlos Torres','carlos.torres@example.com','Perú'),
('María Silva','maria.silva@example.com','España'),
('Luis Fernández','luis.fernandez@example.com','México'),
('Rosa Ramos','rosa.ramos@example.com','Colombia'),
('Pedro Medina','pedro.medina@example.com','Chile'),
('Lucía Gómez','lucia.gomez@example.com','Perú'),
('Jorge Valdez','jorge.valdez@example.com','Argentina'),
('Elena Rivas','elena.rivas@example.com','España'),
('Miguel Paredes','miguel.paredes@example.com','Perú'),
('Sofía Morales','sofia.morales@example.com','México');

/* Productos adicionales */
INSERT INTO Producto (nombre, categoria, precio) VALUES
('Teclado Mecánico','Electrónica',120.00),
('Monitor 24"','Electrónica',550.00),
('Impresora Láser','Oficina',850.00),
('Silla Ergonómica','Oficina',300.00),
('Audífonos Bluetooth','Electrónica',80.00),
('USB 64GB','Accesorios',25.00),
('Webcam HD','Electrónica',150.00),
('Escritorio Gamer','Muebles',450.00);

/* Ventas adicionales */
INSERT INTO Venta (id_cliente, fecha, total) VALUES
(3,'2025-10-12',120.00),
(4,'2025-09-05',550.00),
(5,'2025-08-20',850.00),
(6,'2025-07-15',380.00),
(7,'2025-07-18',80.00),
(8,'2025-06-21',175.00),
(9,'2025-05-30',975.00),
(10,'2025-05-12',300.00),
(3,'2025-04-02',150.00),
(4,'2025-03-25',450.00);

/* Detalles adicionales */
INSERT INTO Venta (id_cliente, fecha, total) VALUES
(5,'2025-02-10',850.00),   -- id_venta = 11
(6,'2025-02-15',380.00),   -- id_venta = 12
(7,'2025-02-20',80.00),    -- id_venta = 13
(8,'2025-02-25',175.00),   -- id_venta = 14
(9,'2025-03-01',975.00),   -- id_venta = 15
(10,'2025-03-05',300.00);  -- id_venta = 16



/*----------------------------------------------------------
  6. CREACIÓN DE ÍNDICES
----------------------------------------------------------*/

/* Índice compuesto */
CREATE INDEX idx_nombre_pais ON Cliente (nombre, pais);

/* Índice por total */
CREATE INDEX idx_total_venta ON Venta (total);

/*----------------------------------------------------------
  7. CREACIÓN DE VISTAS
----------------------------------------------------------*/

/* Vista 1: pedidos por cliente */
CREATE VIEW vista_pedidos_cliente AS
SELECT 
  C.id_cliente,
  C.nombre AS Cliente,
  V.id_venta,
  V.fecha,
  V.total
FROM Cliente C
JOIN Venta V ON C.id_cliente = V.id_cliente;

/* Vista 2: ventas totales por cliente */
CREATE VIEW vista_ventas_por_cliente AS
SELECT 
  C.id_cliente,
  C.nombre AS Cliente,
  COUNT(V.id_venta) AS TotalVentas,
  IFNULL(SUM(V.total),0) AS TotalGastado
FROM Cliente C
LEFT JOIN Venta V ON C.id_cliente = V.id_cliente
GROUP BY C.id_cliente, C.nombre;

/* Vista 3: clientes de España */
CREATE VIEW vista_clientes_es AS
SELECT *
FROM Cliente
WHERE pais = 'España';


-- CONSULTAS

-- 1. Clientes que han gastado más de 1000
SELECT * 
FROM vista_ventas_por_cliente 
WHERE TotalGastado > 1000;

-- 2. Productos comprados más de 2 veces
SELECT id_producto, SUM(cantidad) AS total
FROM DetalleVenta
GROUP BY id_producto
HAVING total > 2;


-- 3. Ventas realizadas entre fechas
SELECT * 
FROM Venta 
WHERE fecha BETWEEN '2025-01-01' AND '2025-12-31';

-- 4. Clientes de Perú con más de 1 venta
SELECT C.nombre, COUNT(V.id_venta) AS ventas
FROM Cliente C 
JOIN Venta V ON C.id_cliente = V.id_cliente
WHERE C.pais = 'Perú'
GROUP BY C.id_cliente
HAVING ventas > 1;