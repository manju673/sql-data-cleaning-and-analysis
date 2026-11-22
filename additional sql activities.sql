USE walmart_db;
----------- 1. DATA PROFILING AND QUALITY CHECKS ----------------------------;


SELECT 'products' AS table_name, COUNT(*) AS total_records
FROM products

UNION ALL

SELECT 'brands', COUNT(*)
FROM brands

UNION ALL

SELECT 'sellers', COUNT(*)
FROM sellers

UNION ALL

SELECT 'product_prices', COUNT(*)
FROM product_prices

UNION ALL

SELECT 'product_variants', COUNT(*)
FROM product_variants

UNION ALL

SELECT 'product_categories', COUNT(*)
FROM product_categories

UNION ALL

SELECT 'product_images', COUNT(*)
FROM product_images

UNION ALL

SELECT 'product_attributes', COUNT(*)
FROM product_attributes

UNION ALL

SELECT 'availability', COUNT(*)
FROM availability

UNION ALL

SELECT 'product_reviews', COUNT(*)
FROM product_reviews

UNION ALL

SELECT 'rating_summary', COUNT(*)
FROM rating_summary

UNION ALL

SELECT 'product_ingredients', COUNT(*)
FROM product_ingredients;

SELECT
    SUM(product_id IS NULL) AS null_product_ids,
    SUM(product_name IS NULL) AS null_product_names,
    SUM(sku IS NULL) AS null_skus,
    SUM(gtin IS NULL) AS null_gtins,
    SUM(brand IS NULL) AS null_brands,
    SUM(seller IS NULL) AS null_sellers,
    SUM(category_name IS NULL) AS null_categories
FROM products;

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT
    sku,
    COUNT(*) AS duplicate_count
FROM products
WHERE sku IS NOT NULL
GROUP BY sku
HAVING COUNT(*) > 1;
SELECT *
FROM product_prices
WHERE final_price < 0
   OR initial_price < 0
   OR discount < 0;
   
   SELECT *
FROM product_reviews
WHERE rating < 1
   OR rating > 5;
   
   SELECT
    MIN(rating) AS minimum_rating,
    MAX(rating) AS maximum_rating,
    AVG(rating) AS average_rating
FROM product_reviews;

SELECT pp.product_id
FROM product_prices pp
LEFT JOIN products p
    ON pp.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT pr.product_id
FROM product_reviews pr
LEFT JOIN products p
    ON pr.product_id = p.product_id
WHERE p.product_id IS NULL;

 --------------------- 2. DUPLICATE DATA HANDLING --------------;
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT
    sku,
    COUNT(*) AS duplicate_count
FROM products
WHERE sku IS NOT NULL
GROUP BY sku
HAVING COUNT(*) > 1;
SELECT
    gtin,
    COUNT(*) AS duplicate_count
FROM products
WHERE gtin IS NOT NULL
  AND TRIM(gtin) <> ''
GROUP BY gtin
HAVING COUNT(*) > 1;

SELECT
    product_name,
    COUNT(*) AS duplicate_count
FROM products
WHERE product_name IS NOT NULL
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM product_prices
GROUP BY product_id
HAVING COUNT(*) > 1;
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM rating_summary
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM availability
GROUP BY product_id
HAVING COUNT(*) > 1;
SELECT
    product_id,
    review_no,
    COUNT(*) AS duplicate_count
FROM product_reviews
GROUP BY product_id, review_no
HAVING COUNT(*) > 1;

SELECT
    product_id,
    image_order,
    COUNT(*) AS duplicate_count
FROM product_images
GROUP BY product_id, image_order
HAVING COUNT(*) > 1;
SELECT
    product_id,
    attribute_name,
    attribute_value,
    COUNT(*) AS duplicate_count
FROM product_attributes
GROUP BY
    product_id,
    attribute_name,
    attribute_value
HAVING COUNT(*) > 1;

SELECT
    product_id,
    variant_type,
    variant_value,
    COUNT(*) AS duplicate_count
FROM product_variants
GROUP BY
    product_id,
    variant_type,
    variant_value
HAVING COUNT(*) > 1;

SELECT
    product_id,
    category_level,
    category_name,
    COUNT(*) AS duplicate_count
FROM product_categories
GROUP BY
    product_id,
    category_level,
    category_name
HAVING COUNT(*) > 1;

-------------------- 3. AUDIT AND LOGGING --------------------;

DESCRIBE products;

SELECT
    product_id,
    product_name,
    created_at,
    updated_at
FROM products
LIMIT 5;
CREATE TABLE IF NOT EXISTS product_audit_log (
    audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id VARCHAR(50),
    action_type VARCHAR(20) NOT NULL,
    old_product_name TEXT,
    new_product_name TEXT,
    changed_by VARCHAR(255),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
DESCRIBE product_audit_log;

SELECT * FROM product_audit_log;
DELIMITER //

CREATE TRIGGER trg_products_after_update
AFTER UPDATE ON products
FOR EACH ROW
BEGIN

    INSERT INTO product_audit_log
    (
        product_id,
        action_type,
        old_product_name,
        new_product_name,
        changed_by,
        changed_at
    )
    VALUES
    (
        NEW.product_id,
        'UPDATE',
        OLD.product_name,
        NEW.product_name,
        CURRENT_USER(),
        CURRENT_TIMESTAMP
    );

END //

DELIMITER ;
SHOW TRIGGERS;
SELECT
    product_id,
    product_name
FROM products
LIMIT 1;
UPDATE products
SET product_name = product_name
WHERE product_id = '173530386';

SELECT
    audit_id,
    product_id,
    action_type,
    old_product_name,
    new_product_name,
    changed_by,
    changed_at
FROM product_audit_log
ORDER BY audit_id DESC;
DELIMITER //

CREATE TRIGGER trg_products_after_delete
AFTER DELETE ON products
FOR EACH ROW
BEGIN

    INSERT INTO product_audit_log
    (
        product_id,
        action_type,
        old_product_name,
        new_product_name,
        changed_by,
        changed_at
    )
    VALUES
    (
        OLD.product_id,
        'DELETE',
        OLD.product_name,
        NULL,
        CURRENT_USER(),
        CURRENT_TIMESTAMP
    );

END //

DELIMITER ;
SHOW TRIGGERS;
SELECT
    action_type,
    COUNT(*) AS total_actions
FROM product_audit_log
GROUP BY action_type;

------------------- 4. INCREMENTAL DATA LOADING ------------------------;
SHOW KEYS
FROM products
WHERE Key_name = 'PRIMARY';

CREATE TABLE IF NOT EXISTS products_incremental
LIKE products;

DESCRIBE products_incremental;
TRUNCATE TABLE products_incremental;

INSERT INTO products
(
    product_id,
    product_name,
    sku,
    gtin
)
SELECT
    product_id,
    product_name,
    sku,
    gtin
FROM products_incremental
AS incoming
WHERE product_id IS NOT NULL

ON DUPLICATE KEY UPDATE

    product_name = incoming.product_name,
    sku = incoming.sku,
    gtin = incoming.gtin;
    
    SHOW TABLES LIKE 'products_incremental';
    
    SELECT COUNT(*) AS incremental_rows
     FROM product_incremental;
     
     SEL*CT COUNT(*) AS existing_records
FR*M products_incremental i
JOIN prod*cts p
    ON i.product_id = p.prod*ct_id;
    
    SELECT COUNT(*) AS new_records
FR*M products_incremental i
LEFT JOIN*products p
    ON i.product_id = p*product_id
WHERE p.product_id IS N*LL;

SELECT
    product_id,
    product_name,
    created_at,
    updated_at
FROM products
ORDER BY updated_at DESC
LIMIT 10;

 ----------------------- 5. DATA AGGREGATION TABLES -----------------------
 
 DESCRIBE products;
DESCRIBE product_prices;
DESCRIBE product_categories;
DESCRIBE brands;
DESCRIBE sellers;
DROP TABLE IF EXISTS category_summary;

CREATE TABLE category_summary AS
SELECT
    category_name,
    COUNT(DISTINCT product_id) AS total_products
FROM products
WHERE category_name IS NOT NULL
  AND TRIM(category_name) <> ''
GROUP BY category_name;
SELECT *
FROM category_summary
ORDER BY total_products DESC
LIMIT 10;
DROP TABLE IF EXISTS brand_summary;

CREATE TABLE brand_summary AS
SELECT
    brand,
    COUNT(DISTINCT product_id) AS total_products
FROM products
WHERE brand IS NOT NULL
  AND TRIM(brand) <> ''
GROUP BY brand;
SELECT *
FROM brand_summary
ORDER BY total_products DESC
LIMIT 10;
DROP TABLE IF EXISTS seller_summary;

CREATE TABLE seller_summary AS
SELECT
    seller,
    COUNT(DISTINCT product_id) AS total_products
FROM products
WHERE seller IS NOT NULL
  AND TRIM(seller) <> ''
GROUP BY seller;
SELECT *
FROM seller_summary
ORDER BY total_products DESC
LIMIT 10;
DROP TABLE IF EXISTS root_category_summary;

CREATE TABLE root_category_summary AS
SELECT
    root_category_name,
    COUNT(DISTINCT product_id) AS total_products
FROM products
WHERE root_category_name IS NOT NULL
  AND TRIM(root_category_name) <> ''
GROUP BY root_category_name;
SELECT *
FROM root_category_summary
ORDER BY total_products DESC;
DROP TABLE IF EXISTS product_summary;

CREATE TABLE product_summary AS
SELECT
    COUNT(DISTINCT product_id) AS total_products,
    COUNT(DISTINCT brand) AS total_brands,
    COUNT(DISTINCT seller) AS total_sellers,
    COUNT(DISTINCT category_name) AS total_categories,
    COUNT(DISTINCT root_category_name) AS total_root_categories
FROM products;
SELECT *
FROM product_summary;
SELECT
    table_name
FROM information_schema.tables
WHERE table_schema = 'walmart_db'
  AND table_name IN (
      'category_summary',
      'brand_summary',
      'seller_summary',
      'root_category_summary',
      'product_summary'
  );
  SELECT COUNT(*) AS category_rows
FROM category_summary;

SELECT COUNT(*) AS brand_rows
FROM brand_summary;

SELECT COUNT(*) AS seller_rows
FROM seller_summary;

SELECT COUNT(*) AS root_category_rows
FROM root_category_summary;

SELECT COUNT(*) AS product_summary_rows
FROM product_summary;


-------------- 6. KPI CALCULATION QUERIES ---------------------------

SELECT 
    COUNT(DISTINCT product_id) AS total_products
FROM products;
DESCRIBE rating_summary;
SELECT
    ROUND(AVG(rating), 2) AS average_rating
FROM rating_summary
WHERE rating IS NOT NULL;
DESCRIBE rating_summary;
SELECT
    SUM(review_count) AS total_reviews
FROM rating_summary;
DESCRIBE product_prices;
SELECT
    ROUND(AVG(final_price), 2) AS average_product_price
FROM product_prices
WHERE final_price IS NOT NULL;
SELECT
    MAX(final_price) AS highest_product_price
FROM product_prices;
SELECT
    MIN(final_price) AS lowest_product_price
FROM product_prices
WHERE final_price > 0;
DESCRIBE product_prices;
SELECT
    ROUND(AVG(discount), 2) AS average_discount
FROM product_prices
WHERE discount IS NOT NULL;
DESCRIBE brands;
SELECT * 
FROM brands
LIMIT 5;
DESCRIBE products;
DESCRIBE brands;
SELECT
    b.brand_name,
    COUNT(DISTINCT p.product_id) AS total_products
FROM products p
JOIN brands b
    ON p.brand = b.brand_name
WHERE b.brand_name IS NOT NULL
GROUP BY b.brand_name
ORDER BY total_products DESC
LIMIT 10;
SELECT
    COUNT(*) AS unmatched_products
FROM products p
LEFT JOIN brands b
    ON p.brand = b.brand_name
WHERE b.brand_id IS NULL;

SELECT
    category_name,
    COUNT(DISTINCT product_id) AS total_products
FROM products
WHERE category_name IS NOT NULL
  AND TRIM(category_name) <> ''
GROUP BY category_name
ORDER BY total_products DESC
LIMIT 10;
SELECT
    seller,
    COUNT(DISTINCT product_id) AS total_products
FROM products
WHERE seller IS NOT NULL
  AND TRIM(seller) <> ''
GROUP BY seller
ORDER BY total_products DESC
LIMIT 10;
SELECT
    category_name,
    COUNT(DISTINCT product_id) AS total_products
FROM products
WHERE category_name IS NOT NULL
  AND TRIM(category_name) <> ''
GROUP BY category_name
ORDER BY total_products DESC
LIMIT 10;
DESCRIBE rating_summary;
SELECT
    p.product_id,
    p.product_name,
    rs.review_count
FROM products p
JOIN rating_summary rs
    ON p.product_id = rs.product_id
WHERE rs.review_count IS NOT NULL
ORDER BY rs.review_count DESC
LIMIT 10;
SELECT
    p.product_id,
    p.product_name,
    rs.rating,
    rs.review_count
FROM products p
JOIN rating_summary rs
    ON p.product_id = rs.product_id
WHERE rs.rating IS NOT NULL
ORDER BY rs.rating DESC, rs.review_count DESC
LIMIT 10;
DESCRIBE rating_summary;
SELECT
    p.product_id,
    p.product_name,
    rs.rating,
    rs.review_count
FROM products p
JOIN rating_summary rs
    ON p.product_id = rs.product_id
WHERE rs.rating IS NOT NULL
ORDER BY rs.rating DESC, rs.review_count DESC
LIMIT 10;