CREATE DATABASE biblioteca_universitaria;
USE biblioteca_universitaria;

CREATE TABLE autores (
    id_autor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50)
);

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre_categoria VARCHAR(50) NOT NULL
);

CREATE TABLE libros (
    id_libro INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    anio_publicacion INT,
    ejemplares_disponibles INT DEFAULT 1,
    id_autor INT,
    id_categoria INT,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    tipo_usuario ENUM('Estudiante', 'Profesor') NOT NULL
);

CREATE TABLE prestamos (
    id_prestamo INT PRIMARY KEY AUTO_INCREMENT,
    id_libro INT,
    id_usuario INT,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion_esperada DATE NOT NULL,
    fecha_devolucion_real DATE,
    FOREIGN KEY (id_libro) REFERENCES libros(id_libro),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

CREATE TABLE multas (
    id_multa INT PRIMARY KEY AUTO_INCREMENT,
    id_prestamo INT,
    monto DECIMAL(10, 2) NOT NULL,
    estado ENUM('Pendiente', 'Pagada') DEFAULT 'Pendiente',
    FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo)
);

INSERT INTO autores (nombre, nacionalidad) VALUES 
('Gabriel García Márquez', 'Colombiana'),
('J.K. Rowling', 'Británica'),
('Antoine de Saint-Exupéry', 'Francesa');

INSERT INTO categorias (nombre_categoria) VALUES 
('Realismo Mágico'), ('Fantasía'), ('Literatura Infantil');

INSERT INTO libros (titulo, isbn, anio_publicacion, ejemplares_disponibles, id_autor, id_categoria) VALUES
('Cien años de soledad', '978-8437604947', 1967, 5, 1, 1),
('Harry Potter y la Piedra Filosofal', '978-8478884452', 1997, 3, 2, 2),
('El Principito', '978-0156012195', 1943, 2, 3, 3);

INSERT INTO usuarios (nombre, email, tipo_usuario) VALUES
('Juan Pérez', 'juan.perez@uni.edu', 'Estudiante'),
('Maria Lopez', 'maria.lopez@uni.edu', 'Profesor'),
('Carlos Ruiz', 'carlos.ruiz@uni.edu', 'Estudiante');

INSERT INTO prestamos (id_libro, id_usuario, fecha_prestamo, fecha_devolucion_esperada, fecha_devolucion_real) VALUES
(1, 1, '2023-11-01', '2023-11-15', NULL),          
(2, 2, '2023-10-01', '2023-10-15', '2023-10-20'), 
(3, 3, '2023-11-05', '2023-11-12', '2023-11-10'); 

INSERT INTO multas (id_prestamo, monto, estado) VALUES
(2, 5.50, 'Pendiente');

SELECT l.titulo, u.nombre AS usuario, p.fecha_prestamo
FROM prestamos p
JOIN libros l ON p.id_libro = l.id_libro
JOIN usuarios u ON p.id_usuario = u.id_usuario
WHERE p.fecha_devolucion_real IS NULL;

SELECT u.nombre, m.monto, m.estado
FROM multas m
JOIN prestamos p ON m.id_prestamo = p.id_prestamo
JOIN usuarios u ON p.id_usuario = u.id_usuario
WHERE m.estado = 'Pendiente';

SELECT l.titulo, COUNT(p.id_prestamo) AS total_prestamos
FROM libros l
JOIN prestamos p ON l.id_libro = p.id_libro
GROUP BY l.id_libro, l.titulo
ORDER BY total_prestamos DESC;

SELECT u.nombre, l.titulo, p.fecha_devolucion_esperada, p.fecha_devolucion_real
FROM prestamos p
JOIN usuarios u ON p.id_usuario = u.id_usuario
JOIN libros l ON p.id_libro = l.id_libro
WHERE p.fecha_devolucion_real > p.fecha_devolucion_esperada
   OR (p.fecha_devolucion_real IS NULL AND CURDATE() > p.fecha_devolucion_esperada);