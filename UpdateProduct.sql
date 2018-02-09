CREATE OR REPLACE FUNCTION updateproductfunc()
RETURNS TRIGGER AS $updateproductfunc$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		IF (SELECT (CASE WHEN NEW.quantity > p.quantity THEN 1 ELSE 0 END) AS 				greaterThan
		FROM Product p
		WHERE p.pid = NEW.pid) THEN
			RAISE NOTICE 'Not enough in stock!';
		ELSE
			UPDATE Product
			SET quantity = quantity - NEW.quantity
			WHERE pid = NEW.pid;
			RETURN NEW;
		END IF;
		ELSEIF (TG_OP = 'UPDATE') THEN
			UPDATE Product
			SET quantity = quantity + OLD.quantityKept - NEW.quantityKept
			WHERE pid = NEW.pid;
			RETURN NEW;
		ELSEIF (TG_OP = 'DELETE') THEN
			UPDATE Product
			SET quantity = quantity + OLD.quantityKept
			WHERE pid = OLD.pid;
			RETURN OLD;
	END IF;
	RETURN NULL;
END;
$updateproductfunc$ LANGUAGE plpgsql;

CREATE TRIGGER UpdateProduct
BEFORE INSERT OR DELETE OR UPDATE ON Transaction
FOR EACH ROW
EXECUTE PROCEDURE updateproductfunc();