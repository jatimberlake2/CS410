CREATE VIEW refundPricing AS
SELECT r.returnid, r.pid AS returnedItemID, r.quantity AS quantityReturned, p.currentPrice AS marketPrice, ROUND(.75*r.quantity*p.currentprice, 2) AS refundValue
FROM Returns r JOIN Product p ON r.pid = p.pid
ORDER BY returnID;