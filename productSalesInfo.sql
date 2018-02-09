CREATE OR REPLACE VIEW productSalesInfo AS
WITH CTE_Info AS
(SELECT p.pid, p.name, SUM(t.quantity) AS totalpurchased, SUM(t.quantity - t.quantityKept) AS totalReturned, ABS(ROUND(p.currentPrice - p.originalPrice,2)) AS priceDifference, CASE WHEN (p.currentPrice - p.originalPrice) < 0 THEN 'Discounted' WHEN (p.currentPrice - p.originalPrice) > 0 THEN 'Increased' WHEN (p.currentPrice - p.originalPrice) = 0 THEN 'Static' ELSE 'N/A' END AS typeOfDifference, s.cid AS sellerID, s.name AS sellerName, pa.country AS productOrigin
FROM Transaction t RIGHT OUTER JOIN Product
 p ON p.pid = t.pid JOIN Sellers s ON p.sellerid = s.cid JOIN PostalAddress pa ON p.sellerid = pa.cid
WHERE t.quantity IS NOT NULL
GROUP BY p.pid, p.name, s.cid, s.name, pa.country
UNION ALL
SELECT p.pid, p.name, 0 AS totalpurchased, 0 AS totalReturned, ROUND(0, 2) AS priceDifference, 'N/A' AS typeOfDifference, s.cid AS sellerID, s.name AS sellerName, pa.country AS productOrigin
FROM Transaction t RIGHT OUTER JOIN Product
 p ON p.pid = t.pid JOIN Sellers s ON p.sellerid = s.cid JOIN PostalAddress pa ON p.sellerid = pa.cid
WHERE t.quantity IS NULL)
SELECT * FROM CTE_Info ORDER BY PID;