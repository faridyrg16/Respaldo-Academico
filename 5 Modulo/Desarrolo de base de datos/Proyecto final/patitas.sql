CREATE DATABASE IF NOT EXISTS PATITAS;
USE PATITAS;

-- ==========================================
-- 1. CLIENTES Y PACIENTES
-- ==========================================

CREATE TABLE IF NOT EXISTS duenos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150),
    telefono VARCHAR(20),
    direccion TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS especies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL -- ej. Perro, Gato
);

CREATE TABLE IF NOT EXISTS razas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    especie_id INT,
    nombre VARCHAR(100) NOT NULL,
    FOREIGN KEY (especie_id) REFERENCES especies(id)
);

CREATE TABLE IF NOT EXISTS mascotas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dueno_id INT,
    especie_id INT,
    raza_id INT,
    nombre VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE,
    genero ENUM('Macho', 'Hembra'),
    color VARCHAR(50),
    microchip_id VARCHAR(50) UNIQUE,
    peso DECIMAL(5,2),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dueno_id) REFERENCES duenos(id) ON DELETE CASCADE,
    FOREIGN KEY (especie_id) REFERENCES especies(id),
    FOREIGN KEY (raza_id) REFERENCES razas(id)
);

-- ==========================================
-- 2. PERSONAL Y ACCESO
-- ==========================================

CREATE TABLE IF NOT EXISTS roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL -- ej. Administrador, Veterinario, Recepcionista
);

CREATE TABLE IF NOT EXISTS empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    rol_id INT,
    email VARCHAR(150) UNIQUE,
    password_hash VARCHAR(255),
    FOREIGN KEY (rol_id) REFERENCES roles(id)
);

CREATE TABLE IF NOT EXISTS turnos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empleado_id INT,
    dia_semana ENUM('Lunes', 'Martes', 'Miercoles', 'Jueves', 'Viernes', 'Sabado', 'Domingo'),
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

-- ==========================================
-- 3. GESTION MEDICA
-- ==========================================

CREATE TABLE IF NOT EXISTS citas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mascota_id INT,
    veterinario_id INT, 
    fecha_cita DATETIME NOT NULL,
    motivo TEXT,
    estado ENUM('Programada', 'Confirmada', 'Completada', 'Cancelada') DEFAULT 'Programada',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mascota_id) REFERENCES mascotas(id),
    FOREIGN KEY (veterinario_id) REFERENCES empleados(id)
);

CREATE TABLE IF NOT EXISTS historias_clinicas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mascota_id INT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mascota_id) REFERENCES mascotas(id)
);

CREATE TABLE IF NOT EXISTS consultas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cita_id INT UNIQUE,
    historia_clinica_id INT,
    diagnostico TEXT,
    notas_tratamiento TEXT,
    temperatura DECIMAL(4,2),
    frecuencia_cardiaca INT,
    frecuencia_respiratoria INT,
    fecha_consulta DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cita_id) REFERENCES citas(id),
    FOREIGN KEY (historia_clinica_id) REFERENCES historias_clinicas(id)
);

CREATE TABLE IF NOT EXISTS vacunas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    intervalo_dias_defecto INT -- Para calcular proxima dosis
);

CREATE TABLE IF NOT EXISTS registros_vacunacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mascota_id INT,
    vacuna_id INT,
    fecha_administracion DATE NOT NULL,
    fecha_proxima_dosis DATE,
    numero_lote VARCHAR(50),
    veterinario_id INT,
    FOREIGN KEY (mascota_id) REFERENCES mascotas(id),
    FOREIGN KEY (vacuna_id) REFERENCES vacunas(id),
    FOREIGN KEY (veterinario_id) REFERENCES empleados(id)
);

CREATE TABLE IF NOT EXISTS cirugias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    consulta_id INT,
    nombre_procedimiento VARCHAR(200),
    descripcion TEXT,
    hora_inicio DATETIME,
    hora_fin DATETIME,
    resultado TEXT,
    FOREIGN KEY (consulta_id) REFERENCES consultas(id)
);

-- ==========================================
-- 4. INVENTARIO (ERP)
-- ==========================================

CREATE TABLE IF NOT EXISTS proveedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_empresa VARCHAR(150),
    nombre_contacto VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(150)
);

CREATE TABLE IF NOT EXISTS categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    sku VARCHAR(50) UNIQUE,
    categoria_id INT,
    proveedor_id INT,
    precio_costo DECIMAL(10,2),
    precio_venta DECIMAL(10,2),
    stock_actual INT DEFAULT 0,
    alerta_stock_minimo INT DEFAULT 5,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)
);

CREATE TABLE IF NOT EXISTS movimientos_stock (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT,
    tipo ENUM('ENTRADA', 'SALIDA', 'AJUSTE'),
    cantidad INT NOT NULL,
    referencia_id INT, -- Puede ser ID de Factura o de Orden de Compra
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- ==========================================
-- 5. VENTAS Y FACTURACION
-- ==========================================

CREATE TABLE IF NOT EXISTS metodos_pago (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL -- Efectivo, Tarjeta, Transferencia
);

CREATE TABLE IF NOT EXISTS facturas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dueno_id INT,
    monto_total DECIMAL(10,2) DEFAULT 0.00,
    estado ENUM('Borrador', 'Pagada', 'Cancelada') DEFAULT 'Borrador',
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    metodo_pago_id INT,
    FOREIGN KEY (dueno_id) REFERENCES duenos(id),
    FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(id)
);

CREATE TABLE IF NOT EXISTS lineas_factura (
    id INT AUTO_INCREMENT PRIMARY KEY,
    factura_id INT,
    producto_id INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    FOREIGN KEY (factura_id) REFERENCES facturas(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);