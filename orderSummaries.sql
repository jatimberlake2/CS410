CREATE OR REPLACE VIEW orderSummaries AS
SELECT t.transactionid, c.name, t.buyerid, c.areaCode, c.phonenum, t.date, ROUND(SUM(tc.totalcost),2) AS total, t.cardNum AS creditCard, t.streetAddress, t.city, t.zip, t.country
FROM (SELECT DISTINCT t.TransactionID, b.buyerid, b.streetAddress, b.city, b.zip, b.country, b.cardnum, b.date FROM Transaction t JOIN billingInfo b ON t.transactionID = b.transactionID) t
JOIN totalCosts tc ON tc.transactionID = t.transactionID
JOIN Customers c ON t.buyerid = c.cid
GROUP BY c.name, c.areaCode, c.phonenum, t.buyerid, t.transactionid, t.date, t.buyerid, t.cardNum, t.streetAddress, t.city, t.zip, t.country
ORDER BY transactionID;