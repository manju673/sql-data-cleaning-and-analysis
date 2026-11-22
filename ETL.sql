CREATE TABLE IF NOT EXISTS etl_product_staging (
    product_id BIGINT PRIMARY KEY,
    product_name VARCHAR(500),
    brand VARCHAR(255),
    final_price DECIMAL(10,2),
    rating DECIMAL(3,2),
    category_name VARCHAR(255),
    load_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
DESCRIBE etl_product_staging;
DESCRIBE products;
DESCRIBE product_prices;

SELECT
    p.product_id,
    p.product_name,
    p.brand,
    pp.final_price,
    p.category_name
FROM products p
LEFT JOIN product_prices pp
    ON p.product_id = pp.product_id
LIMIT 10;

DESCRIBE rating_summary;

SELECT
    p.product_id,
    p.product_name,
    p.brand,
    pp.final_price,
    rs.rating,
    p.category_name
FROM products p
LEFT JOIN product_prices pp
    ON p.product_id = pp.product_id
LEFT JOIN rating_summary rs
    ON p.product_id = rs.product_id
LIMIT 10;

INSERT INTO etl_product_staging
(
    product_id,
    product_name,
    brand,
    final_price,
    rating,
    category_name
)
SELECT
    p.product_id,
    p.product_name,
    p.brand,
    pp.final_price,
    rs.rating,
    p.category_name
FROM products p
LEFT JOIN product_prices pp
    ON p.product_id = pp.product_id
LEFT JOIN rating_summary rs
    ON p.product_id = rs.product_id;
    
    SELECT *
FROM etl_product_staging
LIMIT 10;

-- 1. Total staging rows
SELECT COUNT(*) AS total_rows
FROM etl_product_staging;

-- 2. Check duplicate product IDs
SELECT product_id, COUNT(*) AS duplicate_count
FROM etl_product_staging
GROUP BY product_id
HAVING COUNT(*) > 1;

-- 3. Check important NULL values
SELECT
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS null_product_name,
    SUM(CASE WHEN brand IS NULL THEN 1 ELSE 0 END) AS null_brand,
    SUM(CASE WHEN final_price IS NULL THEN 1 ELSE 0 END) AS null_final_price,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS null_rating,
    SUM(CASE WHEN category_name IS NULL THEN 1 ELSE 0 END) AS null_category
FROM etl_product_staging;
-- Total rows
SELECT COUNT(*) AS total_rows
FROM etl_product_staging;

-- Duplicate IDs
SELECT product_id, COUNT(*) AS duplicate_count
FROM etl_product_staging
GROUP BY product_id
HAVING COUNT(*) > 1;
SELECT COUNT(*) AS total_rows
FROM etl_product_staging;