-- DIM PRODUCT
CREATE TABLE dim_product (
                             product_key INT PRIMARY KEY,
                             product_id VARCHAR(20),
                             title VARCHAR(255),
                             author VARCHAR(255),
                             genre VARCHAR(100),
                             price DECIMAL(10,2)
);

-- DIM CUSTOMER
CREATE TABLE dim_customer (
                              customer_key INT PRIMARY KEY,
                              customer_id VARCHAR(20),
                              name VARCHAR(255),
                              email VARCHAR(255),
                              loyalty_tier VARCHAR(50),
                              registration_date DATE
);

-- DIM DATE
CREATE TABLE dim_date (
                          date_key INT PRIMARY KEY,
                          date DATE,
                          year INT,
                          quarter INT,
                          month INT,
                          month_name VARCHAR(20),
                          day_of_week VARCHAR(20)
);

-- FACT SALES
CREATE TABLE fact_sales (
                            sales_key INT PRIMARY KEY,
                            order_id INT,
                            product_key INT,
                            customer_key INT,
                            date_key INT,
                            quantity INT,
                            unit_price DECIMAL(10,2),
                            revenue DECIMAL(10,2),

                            FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
                            FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
                            FOREIGN KEY (date_key) REFERENCES dim_date(date_key)
);