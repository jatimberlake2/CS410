CREATE OR REPLACE VIEW paysWith AS
SELECT c.cid, c.name, cc.cardnum, cc.pin
FROM Customers c JOIN creditCard cc ON c.cid = cc.cid
ORDER BY c.cid;