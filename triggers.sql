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