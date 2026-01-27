-- --- PASO 2: GESTIÓN DE USUARIOS Y PRIVILEGIOS ---

-- 2.1 Crear Usuarios Específicos por Rol
-- Usuario para la aplicación web (acceso local y remoto)
CREATE USER 'app_hotel'@'localhost' IDENTIFIED BY 'AppHotel2024!';
CREATE USER 'app_hotel'@'%' IDENTIFIED BY 'AppHotel2024!';

-- Usuario para reportes (solo lectura)
CREATE USER 'reportes_hotel'@'localhost' IDENTIFIED BY 'Reportes2024!';

-- Usuario administrador
CREATE USER 'admin_hotel'@'localhost' IDENTIFIED BY 'AdminHotel2024!';

-- Usuario para realizar backups
CREATE USER 'backup_user'@'localhost' IDENTIFIED BY 'Backup2024!';


-- 2.2 Asignar Privilegios por Rol

-- Privilegios para aplicación web (operaciones CRUD limitadas)
GRANT SELECT, INSERT, UPDATE ON hotel_reservas.clientes TO 'app_hotel'@'localhost';
GRANT SELECT, INSERT, UPDATE ON hotel_reservas.reservas TO 'app_hotel'@'localhost';
GRANT SELECT, INSERT ON hotel_reservas.pagos TO 'app_hotel'@'localhost';
GRANT SELECT ON hotel_reservas.hoteles TO 'app_hotel'@'localhost';
GRANT SELECT ON hotel_reservas.habitaciones TO 'app_hotel'@'localhost';

-- Privilegios para reportes (solo lectura en toda la BD)
GRANT SELECT ON hotel_reservas.* TO 'reportes_hotel'@'localhost';

-- Privilegios para administración (control total de la BD)
GRANT ALL PRIVILEGES ON hotel_reservas.* TO 'admin_hotel'@'localhost';

-- Privilegios para backups (permisos globales necesarios para mysqldump)
GRANT SELECT, RELOAD, LOCK TABLES, PROCESS ON *.* TO 'backup_user'@'localhost';
GRANT EVENT ON hotel_reservas.* TO 'backup_user'@'localhost';

-- Aplicar los cambios
FLUSH PRIVILEGES;

-- 2.3 Verificar Privilegios
SHOW GRANTS FOR 'app_hotel'@'localhost';
SELECT user, host FROM mysql.user WHERE user LIKE '%hotel%';