CREATE DATABASE IF NOT EXISTS Universidad;
USE Universidad;

-- Tabla Estudiantes
CREATE TABLE Estudiantes (
    id_estudiante INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE,
    email VARCHAR(100) UNIQUE,
    activo BOOLEAN DEFAULT TRUE
);

-- Tabla Cursos
-- Corrección: Se corrigió "id curso" a "id_curso" y "AUTO INCREMENT" a "AUTO_INCREMENT"
CREATE TABLE Cursos (
    id_curso INT PRIMARY KEY AUTO_INCREMENT,
    nombre_curso VARCHAR(100) NOT NULL,
    creditos INT DEFAULT 3,
    profesor VARCHAR(100),
    cupo_maximo INT CHECK (cupo_maximo > 0)
);

-- =============================================
-- EJERCICIO 2: MODIFICACIÓN (ALTER)
-- =============================================

ALTER TABLE Estudiantes ADD semestre INT DEFAULT 1;

-- Nota: Algunos motores requieren separar MODIFY y CHECK o usar sintaxis específica.
ALTER TABLE Cursos MODIFY creditos DECIMAL(3,1);
ALTER TABLE Cursos ADD CONSTRAINT chk_creditos CHECK (creditos BETWEEN 1 AND 10);

ALTER TABLE Cursos ADD fecha_creacion DATE DEFAULT (CURRENT_DATE);

-- =============================================
-- EJERCICIO 3: MATRICULAS (Con Correcciones)
-- =============================================

-- Corrección: Se cambió la letra 'O' por el número 0 en el CHECK
CREATE TABLE Matriculas (
    id_matricula INT PRIMARY KEY AUTO_INCREMENT,
    id_estudiante INT,
    id_curso INT,
    fecha_matricula DATE DEFAULT (CURRENT_DATE),
    calificacion DECIMAL(3,2) CHECK (calificacion BETWEEN 0 AND 10),
    FOREIGN KEY (id_estudiante) REFERENCES Estudiantes(id_estudiante),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso),
    UNIQUE KEY unique_matricula (id_estudiante, id_curso)
);

-- =============================================
-- EJERCICIO 4: MANTENIMIENTO
-- =============================================

RENAME TABLE Matriculas TO Inscripciones;

CREATE INDEX idx_estudiante_email ON Estudiantes(email);

ALTER TABLE Estudiantes DROP COLUMN activo;

TRUNCATE TABLE Inscripciones;

DROP TABLE Inscripciones;

-- =============================================
-- EJERCICIO 5: BIBLIOTECA (Estructura Compleja)
-- =============================================
CREATE DATABASE IF NOT EXISTS Biblioteca;
USE Biblioteca;

CREATE TABLE Autores (
    id_autor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50),
    fecha_nacimiento DATE
);

-- Corrección: Se eliminaron símbolos '$' y se corrigió 'DEFAULT O' a 'DEFAULT 0'
-- Corrección: Se movió la FK dentro de la definición de la tabla
CREATE TABLE Libros (
    id_libro INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    anio_publicacion INT,
    id_autor INT,
    precio DECIMAL(8,2) CHECK (precio >= 0),
    stock INT DEFAULT 0 CHECK (stock >= 0),
    FOREIGN KEY (id_autor) REFERENCES Autores(id_autor)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre_categoria VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);

CREATE TABLE Libro_Categorias (
    id_libro INT,
    id_categoria INT,
    PRIMARY KEY (id_libro, id_categoria),
    FOREIGN KEY (id_libro) REFERENCES Libros (id_libro),
    FOREIGN KEY (id_categoria) REFERENCES Categorias (id_categoria)
);