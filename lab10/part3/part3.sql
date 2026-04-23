ALTER TABLE dim_customer
    ADD COLUMN start_date DATE,
ADD COLUMN end_date DATE,
ADD COLUMN is_current BOOLEAN;


-- 1. Old row жабу
UPDATE dim_customer
SET end_date = '2024-03-31',
    is_current = FALSE
WHERE customer_id = 'C1001'
  AND is_current = TRUE;

-- 2. New row қосу
INSERT INTO dim_customer (
    customer_key,
    customer_id,
    name,
    email,
    loyalty_tier,
    registration_date,
    start_date,
    end_date,
    is_current
)
VALUES (
           999, -- new key
           'C1001',
           'Alice Johnson',
           'alice@email.com',
           'Platinum',
           '2023-01-01',
           '2024-04-01',
           NULL,
           TRUE
       );