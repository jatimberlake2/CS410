CREATE OR REPLACE VIEW NationProducts AS
SELECT c.country, c.name AS Seller, c.cid AS SellerID, p.name AS item, p.pid AS itemID, p.currentPrice AS itemCost
FROM contactInfo c JOIN Product p ON c.cid = p.sellerID
ORDER BY country;