USE streameduxr_db;
DROP PROCEDURE IF EXISTS sp_registrar_compra;
DROP TRIGGER IF EXISTS trg_actualizar_rating;

DELIMITER //
CREATE PROCEDURE sp_registrar_compra(
    IN p_id_usuario INT, IN p_id_contenido INT, IN p_monto DECIMAL(10,2), IN p_metodo_pago VARCHAR(50)
)
BEGIN
    DECLARE v_id_compra INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en compra'; END;
    START TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM usuario WHERE id_usuario = p_id_usuario) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Usuario no existe'; END IF;
        IF NOT EXISTS (SELECT 1 FROM contenido WHERE id_contenido = p_id_contenido) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Contenido no existe'; END IF;
        INSERT INTO compra (id_usuario, monto_total, estado_pago, fecha_compra) VALUES (p_id_usuario, p_monto, 'Pendiente', NOW());
        SET v_id_compra = LAST_INSERT_ID();
        INSERT INTO compra_detalle (id_compra, id_contenido, precio_unitario) VALUES (v_id_compra, p_id_contenido, p_monto);
        INSERT INTO pago (id_compra, monto, metodo_pago, referencia_transaccion, fecha_pago) VALUES (v_id_compra, p_monto, p_metodo_pago, CONCAT('TRX-', UUID_SHORT()), NOW());
    COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_actualizar_rating AFTER INSERT ON resena FOR EACH ROW
BEGIN
    UPDATE contenido SET rating_promedio = (SELECT AVG(calificacion) FROM resena WHERE id_contenido = NEW.id_contenido),
    rating_count = (SELECT COUNT(*) FROM resena WHERE id_contenido = NEW.id_contenido) WHERE id_contenido = NEW.id_contenido;
END //
DELIMITER ;

CREATE OR REPLACE VIEW vw_consumo_mensual_institucion AS
SELECT i.nombre AS institucion, tc.nombre AS tipo_recurso, COUNT(cn.id_consumo) AS total_interacciones, AVG(cn.progreso_pct) AS progreso_medio, MONTHNAME(cn.fecha_hora) AS mes
FROM institucion i JOIN usuario u ON i.id_institucion = u.id_institucion JOIN consumo cn ON u.id_usuario = cn.id_usuario
JOIN contenido cont ON cn.id_contenido = cont.id_contenido JOIN tipo_contenido tc ON cont.id_tipo_contenido = tc.id_tipo_contenido GROUP BY i.id_institucion, tc.id_tipo_contenido, mes;


CREATE OR REPLACE VIEW vw_ingresos_mensuales AS
SELECT i.nombre AS institucion, SUM(p.monto) AS ingresos_totales, COUNT(c.id_compra) AS volumen_ventas, MONTHNAME(c.fecha_compra) AS mes
FROM institucion i JOIN usuario u ON i.id_institucion = u.id_institucion JOIN compra c ON u.id_usuario = c.id_usuario
JOIN pago p ON c.id_compra = p.id_compra WHERE c.estado_pago = 'Completado' GROUP BY i.id_institucion, mes;

SELECT i.nombre, cont.titulo, SUM(c.tiempo_reproducido_seg)/60 as minutos FROM consumo c 
JOIN contenido cont ON c.id_contenido = cont.id_contenido JOIN usuario u ON c.id_usuario = u.id_usuario
JOIN institucion i ON u.id_institucion = i.id_institucion GROUP BY i.id_institucion, cont.id_contenido ORDER BY minutos DESC LIMIT 10;