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
