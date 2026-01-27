IF DB_ID('ExamenBiblioteca') IS NOT NULL
BEGIN
    ALTER DATABASE ExamenBiblioteca SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ExamenBiblioteca;
END

-- 2) Crear base de datos
CREATE DATABASE ExamenBiblioteca;

USE ExamenBiblioteca;

-- 3) Crear tablas en orden (padres primero)

-- Editorial
IF OBJECT_ID('dbo.Editorial','U') IS NOT NULL DROP TABLE dbo.Editorial;
CREATE TABLE dbo.Editorial (
    id_editorial INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    pais NVARCHAR(100)
);

-- Cateria
IF OBJECT_ID('dbo.Cateria','U') IS NOT NULL DROP TABLE dbo.Cateria;
CREATE TABLE dbo.Cateria (
    id_cateria INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(MAX)
);

-- Autor
IF OBJECT_ID('dbo.Autor','U') IS NOT NULL DROP TABLE dbo.Autor;
CREATE TABLE dbo.Autor (
    id_autor INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    nacionalidad NVARCHAR(100)
);

-- Libro (depende de Editorial y Cateria)
IF OBJECT_ID('dbo.Libro','U') IS NOT NULL DROP TABLE dbo.Libro;
CREATE TABLE dbo.Libro (
    id_libro INT IDENTITY(1,1) PRIMARY KEY,
    titulo NVARCHAR(200) NOT NULL,
    a�o INT CHECK (a�o >= 0),
    id_editorial INT NULL,
    id_cateria INT NULL,
    CONSTRAINT FK_Libro_Editorial FOREIGN KEY (id_editorial) REFERENCES dbo.Editorial(id_editorial) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT FK_Libro_Cateria FOREIGN KEY (id_cateria) REFERENCES dbo.Cateria(id_cateria) ON DELETE SET NULL ON UPDATE CASCADE
);

-- LibroAutor (tabla puente entre Libro y Autor)
IF OBJECT_ID('dbo.LibroAutor','U') IS NOT NULL DROP TABLE dbo.LibroAutor;
CREATE TABLE dbo.LibroAutor (
    id_libro INT NOT NULL,
    id_autor INT NOT NULL,
    PRIMARY KEY (id_libro, id_autor),
    CONSTRAINT FK_LibroAutor_Libro FOREIGN KEY (id_libro) REFERENCES dbo.Libro(id_libro) ON DELETE CASCADE,
    CONSTRAINT FK_LibroAutor_Autor FOREIGN KEY (id_autor) REFERENCES dbo.Autor(id_autor) ON DELETE CASCADE
);

-- Usuario
IF OBJECT_ID('dbo.Usuario','U') IS NOT NULL DROP TABLE dbo.Usuario;
CREATE TABLE dbo.Usuario (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    correo NVARCHAR(200) NOT NULL UNIQUE,
    telefono NVARCHAR(20)
);

-- Ejemplar (depende de Libro)
IF OBJECT_ID('dbo.Ejemplar','U') IS NOT NULL DROP TABLE dbo.Ejemplar;
CREATE TABLE dbo.Ejemplar (
    id_ejemplar INT IDENTITY(1,1) PRIMARY KEY,
    id_libro INT NULL,
    codi_interno NVARCHAR(50) UNIQUE,
    estado NVARCHAR(20) DEFAULT 'Disponible',
    CONSTRAINT FK_Ejemplar_Libro FOREIGN KEY (id_libro) REFERENCES dbo.Libro(id_libro) ON DELETE SET NULL
);

-- Prestamo (depende de Usuario)
IF OBJECT_ID('dbo.Prestamo','U') IS NOT NULL DROP TABLE dbo.Prestamo;
CREATE TABLE dbo.Prestamo (
    id_prestamo INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion_prevista DATE,
    fecha_devolucion_real DATE NULL,
    estado NVARCHAR(20) DEFAULT 'Activo',
    CONSTRAINT FK_Prestamo_Usuario FOREIGN KEY (id_usuario) REFERENCES dbo.Usuario(id_usuario) ON DELETE SET NULL
);

-- DetallePrestamo (depende de Prestamo y Ejemplar)
IF OBJECT_ID('dbo.DetallePrestamo','U') IS NOT NULL DROP TABLE dbo.DetallePrestamo;
CREATE TABLE dbo.DetallePrestamo (
    id_prestamo INT NOT NULL,
    id_ejemplar INT NOT NULL,
    cantidad INT DEFAULT 1,
    PRIMARY KEY (id_prestamo, id_ejemplar),
    CONSTRAINT FK_Detalle_Prestamo FOREIGN KEY (id_prestamo) REFERENCES dbo.Prestamo(id_prestamo) ON DELETE CASCADE,
    CONSTRAINT FK_Detalle_Ejemplar FOREIGN KEY (id_ejemplar) REFERENCES dbo.Ejemplar(id_ejemplar) ON DELETE CASCADE
);

-- Multa (depende de Prestamo)
IF OBJECT_ID('dbo.Multa','U') IS NOT NULL DROP TABLE dbo.Multa;
CREATE TABLE dbo.Multa (
    id_multa INT IDENTITY(1,1) PRIMARY KEY,
    id_prestamo INT NULL,
    dias_retraso INT DEFAULT 0,
    monto DECIMAL(10,2) DEFAULT 0.00,
    pagada BIT DEFAULT 0,
    CONSTRAINT FK_Multa_Prestamo FOREIGN KEY (id_prestamo) REFERENCES dbo.Prestamo(id_prestamo) ON DELETE CASCADE
);

-- 4) Funci�n para calcular d�as de retraso
IF OBJECT_ID('dbo.calcular_dias_retraso','FN') IS NOT NULL DROP FUNCTION dbo.calcular_dias_retraso;

CREATE FUNCTION dbo.calcular_dias_retraso(
    @fecha_prevista DATE,
    @fecha_real DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @dias INT;
    IF @fecha_real IS NULL
        SET @dias = 0;
    ELSE
        SET @dias = DATEDIFF(DAY, @fecha_prevista, @fecha_real);
    IF @dias < 0 SET @dias = 0;
    RETURN @dias;
END;

-- 5) Procedimiento para registrar pr�stamo (devuelve nuevo id via OUTPUT)
IF OBJECT_ID('dbo.registrar_prestamo','P') IS NOT NULL DROP PROCEDURE dbo.registrar_prestamo;

CREATE PROCEDURE dbo.registrar_prestamo
    @id_usuario INT,
    @fecha_prestamo DATE,
    @fecha_prevista DATE,
    @nuevo_id INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.Prestamo (id_usuario, fecha_prestamo, fecha_devolucion_prevista)
    VALUES (@id_usuario, @fecha_prestamo, @fecha_prevista);
    SET @nuevo_id = SCOPE_IDENTITY();
END;

-- 6) Trigger para validar fecha de devoluci�n (no permita fecha_real < fecha_prestamo)
IF OBJECT_ID('trg_validar_fecha_devolucion','TR') IS NOT NULL DROP TRIGGER trg_validar_fecha_devolucion;

CREATE TRIGGER trg_validar_fecha_devolucion
ON dbo.Prestamo
FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1 FROM inserted i
        WHERE i.fecha_devolucion_real IS NOT NULL AND i.fecha_devolucion_real < i.fecha_prestamo
    )
    BEGIN
        RAISERROR('La fecha de devoluci�n no puede ser anterior a la fecha de pr�stamo.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

-- 7) Vista: pr�stamos por usuario
IF OBJECT_ID('dbo.vista_prestamos_usuario','V') IS NOT NULL DROP VIEW dbo.vista_prestamos_usuario;

CREATE VIEW dbo.vista_prestamos_usuario AS
SELECT 
    u.id_usuario,
    u.nombre AS Usuario,
    u.correo AS Correo,
    p.id_prestamo AS CodiPrestamo,
    p.fecha_prestamo AS FechaPrestamo,
    p.fecha_devolucion_prevista AS FechaPrevista,
    p.fecha_devolucion_real AS FechaReal,
    p.estado AS Estado
FROM dbo.Usuario u
LEFT JOIN dbo.Prestamo p ON u.id_usuario = p.id_usuario;

-- 8) �ndices �tiles
CREATE INDEX IX_Libro_Titulo ON dbo.Libro(titulo);
CREATE INDEX IX_Usuario_Correo ON dbo.Usuario(correo);
CREATE INDEX IX_Prestamo_Fecha ON dbo.Prestamo(fecha_prestamo);

-- 9) Insertar datos de ejemplo (en orden correcto)
-- Editoriales (al menos 5-10)
INSERT INTO dbo.Editorial (nombre, pais) VALUES
('Planeta','Espa�a'),
('Santillana','M�xico'),
('Penguin Random House','Argentina'),
('Alfaguara','Per�'),
('Anagrama','Chile'),
('Pearson','EEUU'),
('McGraw-Hill','EEUU'),
('SM','Chile'),
('Siglo XXI','M�xico'),
('Ediciones B','Espa�a');

-- Cater�as
INSERT INTO dbo.Cateria (nombre, descripcion) VALUES
('Novela','Obras de ficci�n'),
('Ciencia','Libros cient�ficos'),
('Historia','Obras hist�ricas'),
('Fantas�a','Relatos imaginarios'),
('Educaci�n','Material educativo'),
('Infantil','Para ni�os'),
('Tecnolog�a','Avances t�cnicos'),
('Arte','Libros de arte'),
('Psicolog�a','Estudio de la conducta'),
('Autoayuda','Desarrollo personal');

-- Autores
INSERT INTO dbo.Autor (nombre, nacionalidad) VALUES
('Gabriel Garc�a M�rquez','Colombia'),
('Stephen Hawking','Reino Unido'),
('Mario Vargas Llosa','Per�'),
('Isabel Allende','Chile'),
('George Orwell','Reino Unido'),
('Jane Austen','Reino Unido'),
('J.K. Rowling','Reino Unido'),
('Dan Brown','EEUU'),
('Paulo Coelho','Brasil'),
('Haruki Murakami','Jap�n');

-- Libros (usar id_editorial y id_cateria v�lidos)
INSERT INTO dbo.Libro(titulo, a�o, id_editorial, id_cateria) VALUES
('Cien a�os de soledad', 1967, 1, 1),
('Breve historia del tiempo', 1988, 2, 2),
('La ciudad y los perros', 1963, 3, 1),
('La casa de los esp�ritus', 1982, 4, 1),
('1984', 1949, 5, 1),
('Orgullo y prejuicio', 1813, 6, 1),
('Harry Potter y la piedra filosofal', 1997, 7, 4),
('El c�di Da Vinci', 2003, 8, 4),
('El alquimista', 1988, 9, 10),
('Kafka en la orilla', 2002, 10, 4);

-- LibroAutor (relaciones N:M)
INSERT INTO dbo.LibroAutor(id_libro, id_autor) VALUES
(1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10);

-- Usuarios (10, correos �nicos)
INSERT INTO dbo.Usuario(nombre, correo, telefono) VALUES
('Juan P�rez','juan@example.com','987654321'),
('Mar�a L�pez','maria@example.com','912345678'),
('Carlos D�az','carlos@example.com','999111222'),
('Ana Torres','ana@example.com','988333444'),
('Luis G�mez','luis@example.com','944555666'),
('Sof�a Ruiz','sofia@example.com','933777888'),
('Pedro Ramos','pedro@example.com','955999000'),
('Elena Vargas','elena@example.com','922111333'),
('Miguel Soto','miguel@example.com','966444555'),
('Luc�a Ch�vez','lucia@example.com','977222111');

-- Ejemplares: asegurar que id_libro 1..10 existen
INSERT INTO dbo.Ejemplar(id_libro, codi_interno, estado) VALUES
(1,'EJ-001','Disponible'),
(1,'EJ-002','Disponible'),
(2,'EJ-003','Disponible'),
(3,'EJ-004','Disponible'),
(4,'EJ-005','Disponible'),
(5,'EJ-006','Disponible'),
(6,'EJ-007','Disponible'),
(7,'EJ-008','Disponible'),
(8,'EJ-009','Disponible'),
(9,'EJ-010','Disponible');

-- ========================================
-- Consultas
-- ========================================
DECLARE 
    @new_prestamo_id INT,
    @user INT = 1,
    @f_prestamo DATE = CAST(GETDATE() AS DATE),
    @f_prevista DATE = DATEADD(DAY, 7, CAST(GETDATE() AS DATE));

EXEC dbo.registrar_prestamo 
    @id_usuario = @user,
    @fecha_prestamo = @f_prestamo,
    @fecha_prevista = @f_prevista,
    @nuevo_id = @new_prestamo_id OUTPUT;

SELECT 'Pr�stamo creado con ID:' AS Mensaje, @new_prestamo_id AS ID;

-- 2
DECLARE @prestamo INT = 1;

IF NOT EXISTS (SELECT 1 FROM dbo.DetallePrestamo WHERE id_prestamo = @prestamo AND id_ejemplar = 1)
    INSERT INTO dbo.DetallePrestamo (id_prestamo, id_ejemplar, cantidad)
    VALUES (@prestamo, 1, 1);

IF NOT EXISTS (SELECT 1 FROM dbo.DetallePrestamo WHERE id_prestamo = @prestamo AND id_ejemplar = 3)
    INSERT INTO dbo.DetallePrestamo (id_prestamo, id_ejemplar, cantidad)
    VALUES (@prestamo, 3, 1);

SELECT * FROM dbo.DetallePrestamo WHERE id_prestamo = @prestamo;

--3
DECLARE @prestamo INT = 1;

UPDATE dbo.Prestamo
SET fecha_devolucion_real = DATEADD(DAY, 3, fecha_devolucion_prevista),
    estado = 'Retrasado'
WHERE id_prestamo = @prestamo;

SELECT * FROM dbo.Prestamo WHERE id_prestamo = @prestamo;
-- 4
DECLARE @prestamo INT = 1;

SELECT 
    id_prestamo,
    dbo.calcular_dias_retraso(fecha_devolucion_prevista, fecha_devolucion_real) AS DiasRetraso
FROM dbo.Prestamo
WHERE id_prestamo = @prestamo;

-- 5
DECLARE @prestamo INT = 1;

INSERT INTO dbo.Multa (id_prestamo, dias_retraso, monto, pagada)
SELECT 
    id_prestamo,
    dbo.calcular_dias_retraso(fecha_devolucion_prevista, fecha_devolucion_real),
    dbo.calcular_dias_retraso(fecha_devolucion_prevista, fecha_devolucion_real) * 5.00,
    0
FROM dbo.Prestamo
WHERE id_prestamo = @prestamo;

SELECT * FROM dbo.Multa WHERE id_prestamo = @prestamo;

--6 
DECLARE @prestamo INT = 1;

SELECT * FROM dbo.Usuario;
SELECT * FROM dbo.Prestamo WHERE id_prestamo = @prestamo;
SELECT * FROM dbo.DetallePrestamo WHERE id_prestamo = @prestamo;
SELECT * FROM dbo.Multa WHERE id_prestamo = @prestamo;
SELECT * FROM dbo.vista_prestamos_usuario WHERE CodiPrestamo = @prestamo;