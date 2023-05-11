CREATE OR REPLACE FUNCTION get_customer_orders(customer_id INTEGER)
RETURNS SETOF orders AS $$
DECLARE 
    order_row orders%ROWTYPE;
    all_orders CURSOR FOR 
        SELECT * FROM orders WHERE customer_id = $1;
BEGIN 
    OPEN all_orders;
    LOOP 
        FETCH all_orders INTO order_row;
        EXIT WHEN NOT FOUND;
        RETURN NEXT order_row;
    END LOOP;
    CLOSE all_orders;
END;
$$ LANGUAGE plpgsql;

-- Cursor to get all items for a specific order
CREATE OR REPLACE FUNCTION get_order_items(order_id INTEGER)
RETURNS SETOF order_items AS $$
DECLARE 
    item_row order_items%ROWTYPE;
    all_items CURSOR FOR 
        SELECT * FROM order_items WHERE order_id = $1;
BEGIN 
    OPEN all_items;
    LOOP 
        FETCH all_items INTO item_row;
        EXIT WHEN NOT FOUND;
        RETURN NEXT item_row;
    END LOOP;
    CLOSE all_items;
END;
$$ LANGUAGE plpgsql;
