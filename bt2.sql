USE ss14;

DELIMITER $$

CREATE PROCEDURE sp_place_order (
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_stock INT;
    DECLARE v_price DECIMAL(10,2);

    -- Bắt đầu transaction
    START TRANSACTION;

    -- Lấy số lượng tồn kho và giá sản phẩm
    SELECT stock, price INTO v_stock, v_price
    FROM products
    WHERE product_id = p_product_id
    FOR UPDATE;

    -- Kiểm tra tồn kho
    IF v_stock IS NULL THEN
        -- Nếu product_id không tồn tại
        ROLLBACK;
    ELSEIF v_stock < p_quantity THEN
        -- Không đủ hàng -> rollback
        ROLLBACK;
    ELSE
        -- Đủ hàng -> tạo đơn hàng
        INSERT INTO orders (product_id, quantity, total_price)
        VALUES (p_product_id, p_quantity, v_price * p_quantity);

        -- Cập nhật tồn kho
        UPDATE products
        SET stock = stock - p_quantity
        WHERE product_id = p_product_id;

        -- Commit transaction
        COMMIT;
    END IF;
END$$

DELIMITER ;
