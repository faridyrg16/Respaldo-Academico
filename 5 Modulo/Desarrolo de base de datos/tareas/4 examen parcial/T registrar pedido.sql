DELIMITER //

CREATE PROCEDURE sp_registrar_pedido(
    IN p_id_cliente INT,
    IN p_id_producto INT,
    IN p_cantidad INT,
    IN p_metodo_pago VARCHAR(20)
)
BEGIN
    DECLARE v_stock_actual INT;
    DECLARE v_precio_actual DECIMAL(10,2);
    DECLARE v_id_pedido INT;
    DECLARE v_total DECIMAL(10,2);
    
    /* Manejo de errores SQL */
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error: Transacción revertida' AS mensaje;
    END;

    START TRANSACTION;
    
    /* 1. Verificar Stock disponible */
    SELECT stock, precio INTO v_stock_actual, v_precio_actual 
    FROM productos WHERE id_producto = p_id_producto FOR UPDATE;
    
    IF v_stock_actual >= p_cantidad THEN
    
        /* 2. Crear Cabecera del Pedido */
        INSERT INTO pedidos (id_cliente, estado) VALUES (p_id_cliente, 'PENDIENTE');
        SET v_id_pedido = LAST_INSERT_ID();
        
        /* 3. Insertar Detalle (El Trigger trg_actualizar_stock_venta se disparará aquí) */
        INSERT INTO detalles_pedido (id_pedido, id_producto, cantidad, precio_unitario)
        VALUES (v_id_pedido, p_id_producto, p_cantidad, v_precio_actual);
        
        /* 4. Registrar Pago Automático (opcional según lógica de negocio) */
        SET v_total = p_cantidad * v_precio_actual;
        INSERT INTO pagos (id_pedido, monto, metodo_pago) 
        VALUES (v_id_pedido, v_total, p_metodo_pago);
        
        COMMIT;
        SELECT 'Éxito: Pedido registrado y stock actualizado' AS mensaje, v_id_pedido AS id_generado;
        
    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente para realizar la venta';
    END IF;

END //

DELIMITER ;