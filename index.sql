SHOW INDEX FROM products;
DESCRIBE products;
CREATE INDEX idx_products_brand
ON products (brand);

CREATE INDEX idx_products_sku
ON products (sku);
CREATE INDEX idx_products_gtin
ON products (gtin);
CREATE INDEX idx_products_upc
ON products (upc);
SHOW INDEX FROM products;
SHOW TABLES;
DESCRIBE availability;
SHOW INDEX FROM availability;
SHOW INDEX FROM brands;
SHOW INDEX FROM product_attributes;
SHOW INDEX FROM product_categories;
SHOW INDEX FROM product_images;
SHOW INDEX FROM product_ingredients;
SHOW TABLES;
SHOW INDEX FROM product_prices;
DESCRIBE product_prices;
CREATE INDEX idx_product_prices_product_id
ON product_prices (product_id);
SHOW CREATE TABLE product_prices;
SELECT COLUMN_NAME, HEX(COLUMN_NAME)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'walmart_db'
  AND TABLE_NAME = 'product_prices';
  ALTER TABLE product_prices
RENAME COLUMN `ï»¿product_id` TO product_id;
DESCRIBE product_prices;
CREATE INDEX idx_product_prices_product_id
ON product_prices (product_id);
SHOW INDEX FROM product_prices;
SHOW INDEX FROM product_reviews;
SHOW INDEX FROM products;
SHOW INDEX FROM sellers;
SHOW INDEX FROM categories;
SHOW TABLES;
SHOW INDEX FROM product_categories;
SHOW INDEX FROM product_images;
SHOW INDEX FROM product_ingredients;
SHOW INDEX FROM product_attributes;
SHOW INDEX FROM availability;
SHOW INDEX FROM brands;
SHOW TABLES;
