-- --- PASO 1: CREACIÓN DE LA BASE DE DATOS Y ESTRUCTURA ---

-- 1.2 Crear la Base de Datos
CREATE DATABASE hotel_reservas;
USE hotel_reservas;

-- Tabla de hoteles
CREATE TABLE hoteles (
    hotel_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    email VARCHAR(100),
    estrellas TINYINT,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de habitaciones
CREATE TABLE habitaciones (
    habitacion_id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT NOT NULL,
    numero_habitacion VARCHAR(10) NOT NULL,
    tipo ENUM('Individual', 'Doble', 'Suite', 'Familiar') NOT NULL,
    precio_noche DECIMAL(10,2) NOT NULL,
    capacidad TINYINT NOT NULL,
    descripcion TEXT,
    disponible BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (hotel_id) REFERENCES hoteles(hotel_id) ON DELETE CASCADE,
    UNIQUE KEY unique_habitacion_hotel (hotel_id, numero_habitacion)
);

-- Tabla de clientes
CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    pais VARCHAR(50),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de reservas
CREATE TABLE reservas (
    reserva_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    habitacion_id INT NOT NULL,
    fecha_entrada DATE NOT NULL,
    fecha_salida DATE NOT NULL,
    adultos TINYINT DEFAULT 1,
    ninos TINYINT DEFAULT 0,
    estado ENUM('Pendiente', 'Confirmada', 'En curso', 'Completada', 'Cancelada') DEFAULT 'Pendiente',
    total DECIMAL(10,2) NOT NULL,
    observaciones TEXT,
    fecha_reserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id) ON DELETE CASCADE,
    FOREIGN KEY (habitacion_id) REFERENCES habitaciones(habitacion_id) ON DELETE CASCADE,
    CHECK (fecha_salida > fecha_entrada)
);

-- Tabla de pagos
CREATE TABLE pagos (
    pago_id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    metodo ENUM('Tarjeta', 'Efectivo', 'Transferencia', 'Online') NOT NULL,
    estado ENUM('Pendiente', 'Completado', 'Fallido', 'Reembolsado') DEFAULT 'Pendiente',
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaccion_id VARCHAR(100),
    FOREIGN KEY (reserva_id) REFERENCES reservas(reserva_id) ON DELETE CASCADE
);

-- Tabla de auditoría
CREATE TABLE auditoria_reservas (
    auditoria_id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT NOT NULL,
    accion ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    usuario VARCHAR(100) NOT NULL,
    fecha_auditoria TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datos_anteriores JSON,
    datos_nuevos JSON
);

SHOW TABLES;