-- Function to calculate the total price of an order
CREATE OR REPLACE FUNCTION calculate_total_price(order_id INTEGER)
RETURNS NUMERIC(6,2) AS $$
DECLARE
    total_price NUMERIC(6,2);
BEGIN
    SELECT SUM(item_price * quantity) INTO total_price
    FROM order_items
    WHERE order_id = $1;
    
    RETURN total_price;
END;
$$ LANGUAGE plpgsql;

-- Function to get the most popular item
CREATE OR REPLACE FUNCTION get_most_popular_item()
RETURNS TEXT AS $$
DECLARE
    most_popular_item TEXT;
BEGIN
    SELECT item_name INTO most_popular_item
    FROM order_items
    GROUP BY item_name
    ORDER BY SUM(quantity) DESC
    LIMIT 1;
    
    RETURN most_popular_item;
END;
$$ LANGUAGE plpgsql;

-- Function to get all orders for a specific customer
CREATE OR REPLACE FUNCTION get_all_orders(customer_id INTEGER)
RETURNS SETOF orders AS $$
DECLARE
    cur_orders CURSOR FOR 
        SELECT * FROM orders WHERE customer_id = $1;
    row_order orders%ROWTYPE;
BEGIN
    OPEN cur_orders;
    LOOP
        FETCH cur_orders INTO row_order;
        EXIT WHEN NOT FOUND;
        RETURN NEXT row_order;
    END LOOP;
    CLOSE cur_orders;
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- Function to get all items for a specific order
CREATE OR REPLACE FUNCTION get_all_items(order_id INTEGER)
RETURNS SETOF order_items AS $$
DECLARE
    cur_items CURSOR FOR 
        SELECT * FROM order_items WHERE order_id = $1;
    row_item order_items%ROWTYPE;
BEGIN
    OPEN cur_items;
    LOOP
        FETCH cur_items INTO row_item;
        EXIT WHEN NOT FOUND;
        RETURN NEXT row_item;
    END LOOP;
    CLOSE cur_items;
    RETURN;
END;
$$ LANGUAGE plpgsql;

-- Update the total price of the order using the calculate_total_price function
    UPDATE orders SET total_price = calculate_total_price(order_id)
    WHERE id = order_id;
END;
$$;
