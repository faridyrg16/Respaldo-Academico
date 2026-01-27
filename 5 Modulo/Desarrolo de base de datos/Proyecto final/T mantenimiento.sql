-- SCRIPT DE MANTENIMIENTO DE BASE DE DATOS PATITAS
-- Ejecutar mensualmente

USE PATITAS;

-- 1. Verificar integridad de tablas críticas
CHECK TABLE mascotas;
CHECK TABLE consultas;
CHECK TABLE facturas;
CHECK TABLE lineas_factura;

-- 2. Optimizar espacio en disco y reordenar índices (Desfragmentación)
OPTIMIZE TABLE citas;
OPTIMIZE TABLE consultas;
OPTIMIZE TABLE historial_clinicas;
OPTIMIZE TABLE productos;

-- 3. Actualizar estadísticas para el optimizador de consultas
ANALYZE TABLE mascotas;
ANALYZE TABLE duenos;
ANALYZE TABLE facturas;

-- 4. Purga de logs de acceso antiguos (Opcional, si existiera tabla de logs)
-- DELETE FROM logs_sistema WHERE fecha < DATE_SUB(NOW(), INTERVAL 1 YEAR);