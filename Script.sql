-- Create table for customers
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    phone TEXT NOT NULL
);

-- Create table for orders
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(id),
    order_date DATE NOT NULL,
    total_price NUMERIC(6,2) NOT NULL
);

-- Create table for order items
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id),
    item_name TEXT NOT NULL,
    item_price NUMERIC(6,2) NOT NULL,
    quantity INTEGER NOT NULL
);

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
    
    -- Update the total price of the order using the calculate_total_price function
    UPDATE orders SET total_price = calculate_total_price(order_id)
    WHERE id = order_id;
END;
$$;

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

-- Trigger to update the total price of an order when a new item is added
CREATE OR REPLACE FUNCTION update_total_price()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE orders SET total_price = calculate_total_price(NEW.order_id)
    WHERE id = NEW.order_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_total_price_trigger
AFTER INSERT ON order_items
FOR EACH ROW EXECUTE FUNCTION update_total_price();

-- Trigger to log changes to the customers table
CREATE OR REPLACE FUNCTION log_customers_changes()
RETURNS TRIGGER AS $$
BEGIN
   IF TG_OP = 'INSERT' THEN 
      RAISE NOTICE 'Inserted customer with id % and name %', NEW.id, NEW.name; 
   ELSIF TG_OP = 'UPDATE' THEN 
      RAISE NOTICE 'Updated customer with id % and name %', NEW.id, NEW.name; 
   ELSIF TG_OP = 'DELETE' THEN 
      RAISE NOTICE 'Deleted customer with id % and name %', OLD.id, OLD.name; 
   END IF; 
   RETURN NEW; 
END; 
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_customers_changes_trigger 
AFTER INSERT OR UPDATE OR DELETE ON customers 
FOR EACH ROW EXECUTE FUNCTION log_customers_changes();
