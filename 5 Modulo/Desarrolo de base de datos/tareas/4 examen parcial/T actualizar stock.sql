DROP TRIGGER IF EXISTS trg_actualizar_stock_venta;
DELIMITER //
CREATE TRIGGER trg_actualizar_stock_venta
AFTER INSERT ON detalles_pedido
FOR EACH ROW
BEGIN
    UPDATE productos 
    SET stock = stock - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END //

DELIMITER ;