-- Procedure to add a new customer
CREATE OR REPLACE PROCEDURE add_customer(name TEXT, phone TEXT)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO customers (name, phone)
    VALUES (name, phone);
END;
$$;

-- Procedure to add a new order
CREATE OR REPLACE PROCEDURE add_order(customer_id INTEGER, order_date DATE)
LANGUAGE plpgsql AS $$
DECLARE
    order_id INTEGER;
BEGIN
    INSERT INTO orders (customer_id, order_date)
    VALUES (customer_id, order_date)
    RETURNING id INTO order_id;