-- ==========================================
-- 6. AUTOMATIZACIÓN (TRIGGERS Y PROCEDIMIENTOS)
-- ==========================================

-- TRIGGER: Descontar stock automáticamente al vender
DELIMITER //
CREATE TRIGGER trg_actualizar_stock_venta
AFTER INSERT ON lineas_factura
FOR EACH ROW
BEGIN
    UPDATE productos
    SET stock_actual = stock_actual - NEW.cantidad
    WHERE id = NEW.producto_id;
END //
DELIMITER ;

-- TRIGGER: Evitar citas duplicadas para el mismo veterinario a la misma hora
DELIMITER //
CREATE TRIGGER trg_validar_cita
BEFORE INSERT ON citas
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM citas 
               WHERE veterinario_id = NEW.veterinario_id 
               AND fecha_cita = NEW.fecha_cita 
               AND estado NOT IN ('Cancelada')) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El veterinario ya tiene una cita programada a esa hora';
    END IF;
END //
DELIMITER ;

-- VISTA: Reporte rápido de historial clínico
CREATE VIEW vw_historial_completo AS
SELECT 
    m.nombre AS Mascota,
    d.apellido AS Dueno,
    c.fecha_consulta,
    c.diagnostico,
    v.nombre AS Veterinario
FROM consultas c
JOIN citas ci ON c.cita_id = ci.id
JOIN mascotas m ON ci.mascota_id = m.id
JOIN duenos d ON m.dueno_id = d.id
JOIN empleados v ON ci.veterinario_id = v.id;