USE walmart_db;
SELECT product_id, product_name
FROM products
LIMIT 10;

USE walmart_db;

DROP PROCEDURE IF EXISTS sp_get_product_by_id;

DELIMITER //

CREATE PROCEDURE sp_get_product_by_id (
    IN p_product_id BIGINT
)
BEGIN
    SELECT
        p.product_id,
        p.product_name,
        p.sku,
        p.gtin,
        p.upc,
        p.brand,
        p.description
    FROM products p
    WHERE p.product_id = p_product_id;
END //

DELIMITER ;
CALL sp_get_product_by_id(10291017);

SELECT DISTINCT category_name
FROM products
WHERE category_name IS NOT NULL
ORDER BY category_name
LIMIT 20;

DROP PROCEDURE IF EXISTS sp_get_products_by_category;

DELIMITER //

CREATE PROCEDURE sp_get_products_by_category (
    IN p_category_name VARCHAR(255)
)
BEGIN
    SELECT
        product_id,
        product_name,
        brand,
        category_name,
        rating
    FROM products
    WHERE category_name = p_category_name
    ORDER BY product_name;
END //

DELIMITER ;

CALL sp_get_products_by_category('3 Piece Patio Dining Set');
DESCRIBE products;

DROP PROCEDURE IF EXISTS sp_get_products_by_category;

DELIMITER //

CREATE PROCEDURE sp_get_products_by_category (
    IN p_category_name VARCHAR(255)
)
BEGIN
    SELECT
        product_id,
        product_name,
        brand,
        category_name
    FROM products
    WHERE category_name = p_category_name
    ORDER BY product_name;
END //

DELIMITER ;

CALL sp_get_products_by_category('3 Piece Patio Dining Set');

USE walmart_db;
SELECT DISTINCT brand
FROM products
WHERE brand IS NOT NULL
ORDER BY brand
LIMIT 20;

DROP PROCEDURE IF EXISTS sp_get_products_by_brand;

DELIMITER //

CREATE PROCEDURE sp_get_products_by_brand (
    IN p_brand VARCHAR(255)
)
BEGIN
    SELECT
        product_id,
        product_name,
        brand,
        category_name
    FROM products
    WHERE brand = p_brand
    ORDER BY product_name;
END //

DELIMITER ;

CALL sp_get_products_by_brand('Disney');

DESCRIBE rating_summary;
DESCRIBE product_reviews;
DESCRIBE rating_summary;
SELECT
    p.product_id,
    p.product_name,
    p.brand,
    p.category_name,
    rs.rating,
    rs.review_count
FROM products p
JOIN rating_summary rs
    ON p.product_id = rs.product_id
LIMIT 10;
DROP PROCEDURE IF EXISTS sp_get_products_by_min_rating;

DELIMITER //

CREATE PROCEDURE sp_get_products_by_min_rating (
    IN p_min_rating DECIMAL(3,1)
)
BEGIN
    SELECT
        p.product_id,
        p.product_name,
        p.brand,
        p.category_name,
        rs.rating,
        rs.review_count
    FROM products p
    JOIN rating_summary rs
        ON p.product_id = rs.product_id
    WHERE rs.rating >= p_min_rating
    ORDER BY rs.rating DESC, p.product_name;
END //

DELIMITER ;
CALL sp_get_products_by_min_rating(4.5);
DESCRIBE product_prices;
SELECT *
FROM product_prices
LIMIT 10;
SELECT
    p.product_id,
    p.product_name,
    p.brand,
    p.category_name,
    pp.final_price
FROM products p
JOIN product_prices pp
    ON p.product_id = pp.product_id
LIMIT 10;
DROP PROCEDURE IF EXISTS sp_get_products_by_price_range;

DELIMITER //

CREATE PROCEDURE sp_get_products_by_price_range (
    IN p_min_price DECIMAL(10,2),
    IN p_max_price DECIMAL(10,2)
)
BEGIN
    SELECT
        p.product_id,
        p.product_name,
        p.brand,
        p.category_name,
        pp.final_price
    FROM products p
    JOIN product_prices pp
        ON p.product_id = pp.product_id
    WHERE pp.final_price BETWEEN p_min_price AND p_max_price
    ORDER BY pp.final_price ASC;
END //

DELIMITER ;
CALL sp_get_products_by_price_range(10.00, 50.00);
CALL sp_get_products_by_price_range(10.00, 50.00);



------------------- ETL STAGING---------------------

DESCRIBE rating_summary;
SHOW COLUMNS FROM rating_summary;
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
TRUNCATE TABLE etl_product_staging;

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
    TRIM(p.product_name),
    TRIM(p.brand),
    pp.final_price,
    rs.rating,
    TRIM(p.category_name)
FROM products p
LEFT JOIN product_prices pp
    ON p.product_id = pp.product_id
LEFT JOIN rating_summary rs
    ON p.product_id = rs.product_id;
    SELECT COUNT(*) AS staging_row_count
FROM etl_product_staging;
SELECT *
FROM etl_product_staging
LIMIT 10;
SELECT 
    product_id,
    COUNT(*) AS duplicate_count
FROM etl_product_staging
GROUP BY product_id
HAVING COUNT(*) > 1;
SELECT
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS null_product_name,
    SUM(CASE WHEN brand IS NULL THEN 1 ELSE 0 END) AS null_brand,
    SUM(CASE WHEN final_price IS NULL THEN 1 ELSE 0 END) AS null_final_price,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS null_rating,
    SUM(CASE WHEN category_name IS NULL THEN 1 ELSE 0 END) AS null_category
FROM etl_product_staging;

SELECT
    COUNT(*) AS products_without_price
FROM products p
LEFT JOIN product_prices pp
    ON p.product_id = pp.product_id
WHERE pp.product_id IS NULL;
SELECT *
FROM etl_product_staging
WHERE final_price < 0;
SELECT *
FROM etl_product_staging
WHERE rating < 0 OR rating > 5;
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(final_price) AS products_with_price,
    SUM(final_price IS NULL) AS products_without_price,
    MIN(rating) AS minimum_rating,
    MAX(rating) AS maximum_rating
FROM etl_product_staging;