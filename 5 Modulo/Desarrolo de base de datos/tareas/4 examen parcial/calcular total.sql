DELIMITER //

CREATE FUNCTION calcular_total_pedido(p_id_pedido INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);
    
    SELECT IFNULL(SUM(cantidad * precio_unitario), 0) INTO v_total
    FROM detalles_pedido
    WHERE id_pedido = p_id_pedido;
    
    RETURN v_total;
END //

DELIMITER ;