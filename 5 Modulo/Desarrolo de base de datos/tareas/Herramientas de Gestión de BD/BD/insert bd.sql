-- --- PASO 1.3: INSERTAR DATOS DE EJEMPLO ---

-- Insertar hoteles
INSERT INTO hoteles (nombre, direccion, telefono, email, estrellas) VALUES
('Grand Palace Hotel', 'Av. Principal 123, Ciudad', '+34 912 345 678', 'info@grandpalace.com', 5),
('Sea View Resort', 'Playa del Sol 45, Costa', '+34 913 456 789', 'reservas@seaview.com', 4),
('Mountain Lodge', 'Sierra Nevada 78, Montaña', '+34 914 567 890', 'contact@mountainlodge.com', 3);

-- Insertar habitaciones
INSERT INTO habitaciones (hotel_id, numero_habitacion, tipo, precio_noche, capacidad, descripcion) VALUES
(1, '101', 'Individual', 80.00, 1, 'Habitación individual con vista al jardín'),
(1, '102', 'Doble', 120.00, 2, 'Habitación doble con cama king size'),
(1, '201', 'Suite', 250.00, 3, 'Suite ejecutiva con sala de estar'),
(2, '101', 'Individual', 70.00, 1, 'Habitación con vista al mar'),
(2, '102', 'Familiar', 180.00, 4, 'Habitación familiar con dos camas dobles'),
(3, '101', 'Doble', 90.00, 2, 'Habitación doble con chimenea');

-- Insertar clientes
INSERT INTO clientes (dni, nombre, apellidos, email, telefono, pais) VALUES
('12345678A', 'María', 'González Pérez', 'maria.gonzalez@email.com', '+34 600 111 222', 'España'),
('87654321B', 'Carlos', 'Rodríguez López', 'carlos.rodriguez@email.com', '+34 600 333 444', 'España'),
('11223344C', 'Anna', 'Smith Johnson', 'anna.smith@email.com', '+44 7700 123456', 'Reino Unido');

SELECT * FROM hoteles;
SELECT * FROM habitaciones;
SELECT * FROM clientes;