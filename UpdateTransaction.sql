CREATE OR REPLACE FUNCTION updatetransactionfunc()
RETURNS TRIGGER AS $updatetransactionfunc$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		IF (SELECT (CASE WHEN NEW.date < t.date THEN 1 ELSE 0 END) AS before
		FROM (SELECT t.pid, t.transactionid, b.date
			FROM Transaction t JOIN billingInfo b ON t.transactionid = b.transactionid ) t
		WHERE t.pid = NEW.pid AND t.transactionID = NEW.transactionID) THEN
			RAISE NOTICE 'A return cannot occur before a purchase!';
			RETURN NULL;
			END IF;
		IF (SELECT (CASE WHEN NEW.quantity > t.quantityKept THEN 1 ELSE 0 END) AS 				greaterThan
		FROM Transaction t
		WHERE t.pid = NEW.pid AND t.transactionID = NEW.transactionID) THEN
			RAISE NOTICE 'Cannot return more than owned!';
			ELSE
				UPDATE Transaction
				SET quantityKept = quantityKept - NEW.quantity
				WHERE pid = NEW.pid AND transactionID = NEW.transactionID;
				RETURN NEW;
		END IF;
		ELSEIF (TG_OP = 'UPDATE' OR TG_OP = 'DELETE') THEN
			RAISE NOTICE 'All returns final! No modifications allowed!';
	END IF;
	RETURN NULL;
END;
$updatetransactionfunc$ LANGUAGE plpgsql;

CREATE TRIGGER UpdateTransaction
BEFORE INSERT OR DELETE OR UPDATE ON Returns
FOR EACH ROW
EXECUTE PROCEDURE updatetransactionfunc();