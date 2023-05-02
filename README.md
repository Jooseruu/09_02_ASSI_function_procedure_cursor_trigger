# 09_02_ASSI_function_procedure_cursor_trigger
# Customer and Order Database Schema
This project contains SQL code to create a database schema for managing customers and orders. The project has two branches: `sql` and `jdbc`.

## SQL Branch
The `sql` branch contains the SQL code for creating the database schema and managing the data.

### Tables
The schema includes the following tables:

`customers:` stores information about customers, including their name and phone number.
`orders:` stores information about orders, including the customer who placed the order, the date of the order, and the total price of the order.
`order_items:` stores information about the items in an order, including the name and price of each item and the quantity ordered.

### Functions and Procedures
The schema includes several functions and procedures to help manage the data:

`calculate_total_price(order_id INTEGER):` calculates the total price of an order by summing the price of all items in the order.
`get_most_popular_item():` returns the name of the most popular item based on the total quantity ordered.
`add_customer(name TEXT, phone TEXT):` adds a new customer to the customers table.
`add_order(customer_id INTEGER, order_date DATE):` adds a new order to the orders table and updates the total price of the order using the `calculate_total_price` function.

### Cursors
The schema includes two cursors to help retrieve data:

`all_orders:` retrieves all orders for a specific customer.
`all_items:` retrieves all items for a specific order.

### Triggers
The schema includes two triggers to help maintain data integrity:

`update_total_price_trigger:` updates the total price of an order when a new item is added to the order_items table.
`log_customers_changes_trigger:` logs changes to the customers table, including inserts, updates, and deletes.

## JDBC Branch
The `jdbc` branch contains code for connecting to the database using JDBC (Java Database Connectivity). This allows you to interact with the database using Java code.
