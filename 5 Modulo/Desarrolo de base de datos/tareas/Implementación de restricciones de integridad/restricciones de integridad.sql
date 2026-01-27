DROP DATABASE IF EXISTS biblioteca_avanzada;
CREATE DATABASE biblioteca_avanzada CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE biblioteca_avanzada;

--Creacion de tablas y restricciones de integridad para una biblioteca avanzada
 
CREATE TABLE estudiantes (
    id_estudiante INT PRIMARY KEY,
    codigo_estudiante VARCHAR(10) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(15),
    estado ENUM('ACTIVO', 'INACTIVO', 'BLOQUEADO') DEFAULT 'ACTIVO',
    fecha_registro DATE DEFAULT (CURDATE()),
    CHECK (email LIKE '%@%.%') -- Valida formato email
);

-- CHECK para validar emails, fechas y precios

CREATE TABLE libros (
    id_libro INT PRIMARY KEY AUTO_INCREMENT,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(150) NOT NULL,
    editorial VARCHAR(100),
    anio_publicacion YEAR,
    categoria VARCHAR(50),
    CONSTRAINT chk_isbn_length CHECK (LENGTH(isbn) IN (10, 13)) -- Valida longitud ISBN
);

--Se añade la tabla ejemplares (para tener varias copias de un mismo libro)
CREATE TABLE ejemplares (
    id_ejemplar INT PRIMARY KEY AUTO_INCREMENT,
    id_libro INT NOT NULL,
    codigo_barras VARCHAR(20) UNIQUE NOT NULL,
    estado ENUM('DISPONIBLE', 'PRESTADO', 'MANTENIMIENTO', 'PERDIDO') DEFAULT 'DISPONIBLE',
    ubicacion VARCHAR(50),
    fecha_adquisicion DATE DEFAULT (CURDATE()),
    FOREIGN KEY (id_libro) REFERENCES libros (id_libro) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE prestamos (
    id_prestamo INT PRIMARY KEY AUTO_INCREMENT,
    id_estudiante INT NOT NULL,
    id_ejemplar INT NOT NULL,
    fecha_prestamo DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_devolucion_estimada DATE NOT NULL,
    fecha_devolucion_real DATE,
    estado ENUM('ACTIVO', 'DEVUELTO', 'RETRASADO') DEFAULT 'ACTIVO',
    
    CHECK (fecha_devolucion_estimada > DATE(fecha_prestamo)),
    CHECK (fecha_devolucion_real IS NULL OR fecha_devolucion_real >= DATE(fecha_prestamo)),
    
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes (id_estudiante) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_ejemplar) REFERENCES ejemplares (id_ejemplar) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_fecha_prestamo (fecha_prestamo),
    INDEX idx_estado (estado)
);

CREATE TABLE multas (
    id_multa INT PRIMARY KEY AUTO_INCREMENT,
    id_estudiante INT NOT NULL,
    id_prestamo INT NOT NULL,
    monto DECIMAL(8,2) NOT NULL CHECK (monto >= 0),
    fecha_generacion DATE DEFAULT (CURDATE()),
    fecha_pago DATE,
    estado ENUM('PENDIENTE', 'PAGADA', 'PERDONADA') DEFAULT 'PENDIENTE',
    motivo VARCHAR(200),
    
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes (id_estudiante) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_prestamo) REFERENCES prestamos (id_prestamo) ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (fecha_pago IS NULL OR fecha_pago >= fecha_generacion)
);

-- TRIGGERS DE INTEGRIDAD

DELIMITER //

-- Trigger 1: Evitar préstamo si hay multas pendientes
CREATE TRIGGER verificar_multas_antes_prestamo
BEFORE INSERT ON prestamos
FOR EACH ROW
BEGIN
    DECLARE multas_pendientes INT;
    SELECT COUNT(*) INTO multas_pendientes
    FROM multas
    WHERE id_estudiante = NEW.id_estudiante AND estado = 'PENDIENTE';
    
    IF multas_pendientes > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El estudiante tiene multas pendientes';
    END IF;
END//

-- Trigger 2: Cambiar estado del ejemplar a "PRESTADO" al crear préstamo
CREATE TRIGGER actualizar_estado_ejemplar_prestamo
AFTER INSERT ON prestamos
FOR EACH ROW
BEGIN
    IF NEW.estado = 'ACTIVO' THEN
        UPDATE ejemplares SET estado = 'PRESTADO' WHERE id_ejemplar = NEW.id_ejemplar;
    END IF;
END//

-- Trigger 3: Generar multa automática si devuelve tarde
CREATE TRIGGER generar_multa_automatica
AFTER UPDATE ON prestamos
FOR EACH ROW
BEGIN
    DECLARE dias_retraso INT;
    -- Si se registra devolución real Y estaba nula antes Y se pasó de la fecha
    IF NEW.fecha_devolucion_real IS NOT NULL 
       AND OLD.fecha_devolucion_real IS NULL 
       AND NEW.fecha_devolucion_real > NEW.fecha_devolucion_estimada THEN
       
       SET dias_retraso = DATEDIFF(NEW.fecha_devolucion_real, NEW.fecha_devolucion_estimada);
       
       IF dias_retraso > 0 THEN
            INSERT INTO multas (id_estudiante, id_prestamo, monto, motivo)
            VALUES (NEW.id_estudiante, NEW.id_prestamo, dias_retraso * 5.00, CONCAT('Retraso de ', dias_retraso, ' días'));
       END IF;
    END IF;
END//

-- PROCEDIMIENTOS ALMACENADOS

CREATE PROCEDURE realizar_prestamo(
    IN p_id_estudiante INT,
    IN p_id_ejemplar INT,
    IN p_dias_prestamo INT
)
BEGIN
    DECLARE v_estado_estudiante VARCHAR(20);
    DECLARE v_estado_ejemplar VARCHAR(20);
    DECLARE v_prestamos_activos INT;

    -- Validar Estudiante
    SELECT estado INTO v_estado_estudiante FROM estudiantes WHERE id_estudiante = p_id_estudiante;
    IF v_estado_estudiante != 'ACTIVO' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estudiante no está activo';
    END IF;

    -- Validar Ejemplar
    SELECT estado INTO v_estado_ejemplar FROM ejemplares WHERE id_ejemplar = p_id_ejemplar;
    IF v_estado_ejemplar != 'DISPONIBLE' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ejemplar no disponible';
    END IF;

    -- Validar Límite de 3 libros
    SELECT COUNT(*) INTO v_prestamos_activos FROM prestamos WHERE id_estudiante = p_id_estudiante AND estado = 'ACTIVO';
    IF v_prestamos_activos >= 3 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Límite de préstamos activos alcanzado';
    END IF;

    -- Insertar
    INSERT INTO prestamos (id_estudiante, id_ejemplar, fecha_devolucion_estimada)
    VALUES (p_id_estudiante, p_id_ejemplar, DATE_ADD(CURDATE(), INTERVAL p_dias_prestamo DAY));
    
    SELECT 'Préstamo realizado exitosamente' AS mensaje;
END//

DELIMITER ;

-- 4. DATOS DE PRUEBA
INSERT INTO estudiantes (id_estudiante, codigo_estudiante, nombre, email) VALUES
(1, '2023001', 'Ana García', 'ana.garcia@universidad.edu'),
(2, '2023002', 'Carlos López', 'carlos.lopez@universidad.edu');

INSERT INTO libros (isbn, titulo, autor, categoria) VALUES
('9788499890944', 'Cien años de soledad', 'Gabriel García Márquez', 'Literatura'),
('9788437604947', 'Don Quijote de la Mancha', 'Miguel de Cervantes', 'Literatura');

INSERT INTO ejemplares (id_libro, codigo_barras, estado) VALUES
(1, 'LIB001-001', 'DISPONIBLE'),
(1, 'LIB001-002', 'DISPONIBLE'),
(2, 'LIB002-001', 'DISPONIBLE');

-- Prueba del procedimiento
CALL realizar_prestamo(1, 1, 15);