-- Cursor to get all orders for a specific customer
DECLARE all_orders CURSOR FOR 
SELECT * FROM orders WHERE customer_id = 1;

-- Cursor to get all items for a specific order
DECLARE all_items CURSOR FOR 
SELECT * FROM order_items WHERE order_id = 1;