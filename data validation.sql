USE walmart_db;

SHOW TABLES;
SELECT COUNT(*) AS total_products
FROM products;
SELECT product_id, COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;
SELECT COUNT(*) AS null_product_ids
FROM products
WHERE product_id IS NULL;

SELECT COUNT(*) AS unmatched_rating_products
FROM rating_summary r
LEFT JOIN products p
    ON r.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS unmatched_ingredient_products
FROM product_ingredients pi
LEFT JOIN products p
    ON pi.product_id = p.product_id
WHERE p.product_id IS NULL;
SELECT COUNT(*) AS unmatched_review_products
FROM product_reviews pr
LEFT JOIN products p
    ON pr.product_id = p.product_id
WHERE p.product_id IS NULL;
SELECT COUNT(*) AS unmatched_image_products
FROM product_images pi
LEFT JOIN products p
    ON pi.product_id = p.product_id
WHERE p.product_id IS NULL;
SELECT COUNT(*) AS unmatched_category_products
FROM product_categories pc
LEFT JOIN products p
    ON pc.product_id = p.product_id
WHERE p.product_id IS NULL;
SELECT COUNT(*) AS unmatched_variant_products
FROM product_variants pv
LEFT JOIN products p
    ON pv.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS unmatched_attribute_products
FROM product_attributes pa
LEFT JOIN products p
    ON pa.product_id = p.product_id
WHERE p.product_id IS NULL;
SELECT COUNT(*) AS unmatched_availability_products
FROM availability a
LEFT JOIN products p
    ON a.product_id = p.product_id
WHERE p.product_id IS NULL;
