CREATE DATABASE walmart_db;
USE walmart_db;
SELECT DATABASE();

CREATE TABLE brands (
    brand_id INT NOT NULL,
    brand_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (brand_id),
    UNIQUE (brand_name)
);
SHOW TABLES;
DESCRIBE brands;
SELECT *
FROM brands
LIMIT 20;

SELECT COUNT(*) AS total_brands
FROM brands;

SELECT *
FROM brands
WHERE brand_name IS NULL
   OR TRIM(brand_name) = '';

SELECT * FROM brands LIMIT 20;

SELECT COUNT(*) AS total_brands
FROM brands;

CREATE TABLE sellers (
    seller_id INT NOT NULL,
    seller_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (seller_id),
    UNIQUE (seller_name)
);

DESCRIBE sellers;
SELECT * FROM sellers LIMIT 20;

SELECT COUNT(*) AS total_sellers
FROM sellers;

SELECT seller_id, COUNT(*)
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

CREATE TABLE products(
    product_id VARCHAR(255) NOT NULL,
    sku VARCHAR(50),
    gtin VARCHAR(50),
    upc VARCHAR(50),

    product_name VARCHAR(500),
    brand VARCHAR(255),
    seller VARCHAR(255),

    category_name VARCHAR(255),
    root_category_name VARCHAR(255),
    category_path VARCHAR(1000),

    url TEXT,
    product_discription TEXT,

    free_returns VARCHAR(100),
    product_timestamp DATETIME,

    PRIMARY KEY (product_id)
);
DESCRIBE products;
USE walmart_db;

SET GLOBAL local_infile = ON;
SHOW GLOBAL VARIABLES LIKE 'local_infile';

TRUNCATE TABLE products;

SELECT COUNT(*) AS total_products
FROM products;

LOAD DATA LOCAL INFILE 'C:/Users/manju/Downloads/products_mysql.csv'
INTO TABLE products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    product_id,
    sku,
    gtin,
    upc,
    product_name,
    description,
    currency,
    url,
    main_image,
    category_name,
    category_path,
    root_category_name,
    brand_id,
    seller_id
);
SELECT COUNT(*) AS total_brands FROM brands;
SELECT COUNT(*) AS total_sellers FROM sellers;
SELECT COUNT(*) AS total_categories FROM categories;

USE walmart_db;

SHOW TABLES;
SELECT DATABASE();
USE walmart_db;

DROP TABLE IF EXISTS products;

CREATE TABLE products(
    product_id VARCHAR(50) NOT NULL,
    sku VARCHAR(50),
    gtin VARCHAR(50),
    upc VARCHAR(50),

    product_name VARCHAR(1000),
    description LONGTEXT,

    currency VARCHAR(10),
    url TEXT,
    main_image TEXT,

    category_name VARCHAR(255),
    category_path VARCHAR(1000),
    root_category_name VARCHAR(255),

    brand_id INT,
    seller_id INT,

    PRIMARY KEY (product_id)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;
DESCRIBE products;

USE walmart_db;

CREATE TABLE product_prices(
    product_id VARCHAR(50) NOT NULL,
    final_price DECIMAL(12,2),
    initial_price DECIMAL(12,2),
    discount DECIMAL(12,2),
    unit_price DECIMAL(12,2),
    unit VARCHAR(100),
    currency VARCHAR(10)
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;
DESCRIBE product_prices;
SELECT COUNT(*) AS total_rows
FROM product_prices;
SELECT COUNT(*) AS total_product_prices
FROM product_prices;
SELECT *
FROM product_prices
LIMIT 10;




USE walmart_db;

DROP TABLE IF EXISTS products;

CREATE TABLE products(
    product_id BIGINT NOT NULL,
    sku BIGINT NOT NULL,
    gtin VARCHAR(50) NOT NULL,
    upc VARCHAR(50) NOT NULL,
    product_name VARCHAR(1000) NOT NULL,
    brand VARCHAR(255) NOT NULL,
    seller VARCHAR(255) NOT NULL,
    category_name VARCHAR(255) NOT NULL,
    root_category_name VARCHAR(255) NOT NULL,
    category_path VARCHAR(500) NOT NULL,
    url TEXT NOT NULL,
    description TEXT NOT NULL,
    free_returns VARCHAR(255) NOT NULL,
    timestamp DATETIME(3) NOT NULL,

    PRIMARY KEY (product_id)
);
DESCRIBE products;
SHOW GLOBAL VARIABLES LIKE 'local_infile';
USE walmart_db;

TRUNCATE TABLE products;

LOAD DATA LOCAL INFILE 'C:/Users/manju/Downloads/products_sql_wizard_clean.csv'
INTO TABLE products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    product_id,
    sku,
    gtin,
    upc,
    product_name,
    brand,
    seller,
    category_name,
    root_category_name,
    category_path,
    url,
    description,
    free_returns,
    timestamp
);
SELECT COUNT(*) AS total_rows
FROM products;

USE walmart_db;

DROP TABLE IF EXISTS product_variants;

CREATE TABLE product_variants (
    variant_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT NOT NULL,
    variant_type VARCHAR(100) NOT NULL,
    variant_value VARCHAR(500) NOT NULL,

    CONSTRAINT fk_variants_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
DESCRIBE product_variants;
SELECT COUNT(*) AS total_variants
FROM product_variants;
SELECT *
FROM product_variants
LIMIT 10;


USE walmart_db;

DROP TABLE IF EXISTS product_categories;

CREATE TABLE product_categories (
    product_category_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT NOT NULL,
    category_level INT NOT NULL,
    category_name VARCHAR(255) NOT NULL,

    CONSTRAINT fk_product_categories_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
DESCRIBE product_categories;
SELECT COUNT(*) AS total_categories
FROM product_categories;
SELECT *
FROM product_categories
LIMIT 10;

USE walmart_db;

USE walmart_db;

DROP TABLE IF EXISTS product_images;

CREATE TABLE product_images (
    image_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT NOT NULL,
    image_order INT NOT NULL,
    image_url TEXT NOT NULL,
    is_main TINYINT(1) NOT NULL,

    CONSTRAINT fk_product_images_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
DESCRIBE product_images;
SELECT COUNT(*) AS total_images
FROM product_images;

SELECT *
FROM product_images
LIMIT 10;


USE walmart_db;

DROP TABLE IF EXISTS product_attributes;

CREATE TABLE product_attributes (
    attribute_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT NOT NULL,
    attribute_name VARCHAR(255) NOT NULL,
    attribute_value TEXT NOT NULL,

    CONSTRAINT fk_product_attributes_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

USE walmart_db;

DROP TABLE IF EXISTS availability;

CREATE TABLE availability (
    product_id BIGINT NOT NULL,
    available_for_delivery TINYINT(1) NOT NULL,
    available_for_pickup TINYINT(1) NOT NULL,
    free_returns VARCHAR(255) NOT NULL,

    PRIMARY KEY (product_id),

    CONSTRAINT fk_availability_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
DESCRIBE availability;
SELECT COUNT(*) AS total_availability
FROM availability;
SELECT *
FROM  availability
LIMIT 10;

USE walmart_db;

DROP TABLE IF EXISTS product_reviews;

CREATE TABLE product_reviews (
    review_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT NOT NULL,
    review_no INT NOT NULL,
    reviewer_name VARCHAR(255) NOT NULL,
    rating DECIMAL(3,1) NOT NULL,
    review_title VARCHAR(500) NOT NULL,
    review_text TEXT NOT NULL,

    CONSTRAINT fk_product_reviews_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
DESCRIBE product_reviews;

SELECT COUNT(*) AS total_reviews
FROM product_reviews;

SELECT *
FROM product_reviews
LIMIT 10;


USE walmart_db;

DROP TABLE IF EXISTS rating_summary;

CREATE TABLE rating_summary (
    product_id BIGINT NOT NULL,
    rating DECIMAL(3,1) NOT NULL,
    review_count INT NOT NULL,
    five_stars INT NOT NULL,
    four_stars INT NOT NULL,
    three_stars INT NOT NULL,
    two_stars INT NOT NULL,
    one_star INT NOT NULL,

    PRIMARY KEY (product_id),

    CONSTRAINT fk_rating_summary_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
DESCRIBE rating_summary;

USE walmart_db;

DROP TABLE IF EXISTS product_ingredients;

CREATE TABLE product_ingredients (
    ingredient_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT NOT NULL,
    ingredients TEXT NOT NULL,

    CONSTRAINT fk_product_ingredients_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
SELECT COUNT(*) AS total_ingredients
FROM product_ingredients;

SELECT *
FROM product_ingredients
LIMIT 10;


