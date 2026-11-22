USE walmart_db;
SHOW TABLES;
SHOW FULL TABLES
WHERE Table_type = 'VIEW';
SHOW PROCEDURE STATUS
WHERE Db = DATABASE();

SELECT COUNT(*) AS products_count FROM products;
SELECT COUNT(*) AS brands_count FROM brands;
SELECT COUNT(*) AS sellers_count FROM sellers;
SELECT COUNT(*) AS prices_count FROM product_prices;
SELECT COUNT(*) AS variants_count FROM product_variants;
SELECT COUNT(*) AS categories_count FROM product_categories;
SELECT COUNT(*) AS images_count FROM product_images;
SELECT COUNT(*) AS attributes_count FROM product_attributes;
SELECT COUNT(*) AS availability_count FROM availability;
SELECT COUNT(*) AS reviews_count FROM product_reviews;
SELECT COUNT(*) AS ratings_count FROM rating_summary;
SELECT COUNT(*) AS ingredients_count FROM product_ingredients;

SELECT product_id, COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS orphan_records
FROM product_prices pp
LEFT JOIN products p
    ON pp.product_id = p.product_id
WHERE p.product_id IS NULL;