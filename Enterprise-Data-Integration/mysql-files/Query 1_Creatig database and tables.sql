CREATE DATABASE IF NOT EXISTS dw;
USE dw;

DROP TABLE IF EXISTS dw.dim_product_category;

CREATE TABLE dw.dim_product_category (
    product_category_sk     INT             NOT NULL AUTO_INCREMENT,  
    product_category        VARCHAR(50)     NOT NULL,                 
    description             VARCHAR(255)    NOT NULL,
    source_system_code      TINYINT         NOT NULL DEFAULT 0,
    create_timestamp        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_timestamp        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_dim_product_category PRIMARY KEY (product_category_sk),
    CONSTRAINT uq_dim_product_category UNIQUE (product_category)
);

-- -------------------------------------------------------------
-- STEP 3: DIM_PRODUCT_TYPE
-- Source: Product_Type [ERP System]
-- Columns: product_type_code, product_type, product_category
-- -------------------------------------------------------------
DROP TABLE IF EXISTS dw.dim_product_type;

CREATE TABLE dw.dim_product_type (
    product_type_sk         INT             NOT NULL AUTO_INCREMENT,  
    product_type_code       CHAR(2)         NOT NULL,                 
    product_type            VARCHAR(100)    NOT NULL,                 
    product_category_sk     INT             NOT NULL,                 
    product_category        VARCHAR(50)     NOT NULL,                 
    source_system_code      TINYINT         NOT NULL DEFAULT 0,
    create_timestamp        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_timestamp        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_dim_product_type PRIMARY KEY (product_type_sk),
    CONSTRAINT uq_dim_product_type UNIQUE (product_type_code),
    CONSTRAINT fk_dpt_category
        FOREIGN KEY (product_category_sk)
        REFERENCES dw.dim_product_category (product_category_sk)
);

-- -------------------------------------------------------------
-- STEP 4: DIM_PRODUCT
-- Source: Product [ERP System]
-- Columns: product_code, name, description, title,
--          artist_code, product_type_code, format,
--          unit_price, unit_cost, status, created,
--          last_updated
-- -------------------------------------------------------------
DROP TABLE IF EXISTS dw.dim_product;

CREATE TABLE dw.dim_product (
    product_sk              INT             NOT NULL AUTO_INCREMENT, 
    product_code            INT             NOT NULL,                
    name                    VARCHAR(255)    NOT NULL,                
    description             VARCHAR(255)    NOT NULL,
    title                   VARCHAR(255)    NOT NULL,
    artist_code             VARCHAR(20)     NOT NULL,
    product_type_code       CHAR(2)         NOT NULL,                
    product_type_sk         INT             NOT NULL,                
    product_type            VARCHAR(100)    NOT NULL,                
    product_category_sk     INT             NOT NULL,                
    product_category        VARCHAR(50)     NOT NULL,                
    format                  VARCHAR(20)     NOT NULL,                
    unit_price              DECIMAL(10,2)   NOT NULL,                
    unit_cost               DECIMAL(10,2)   NOT NULL,                
    status                  CHAR(2)         NOT NULL,                 
    source_system_code      TINYINT         NOT NULL DEFAULT 0,
    create_timestamp        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_timestamp        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_dim_product PRIMARY KEY (product_sk),
    CONSTRAINT uq_dim_product UNIQUE (product_code),
    CONSTRAINT fk_dp_product_type
        FOREIGN KEY (product_type_sk)
        REFERENCES dw.dim_product_type (product_type_sk),
    CONSTRAINT fk_dp_product_category
        FOREIGN KEY (product_category_sk)
        REFERENCES dw.dim_product_category (product_category_sk)
);

-- -------------------------------------------------------------
-- STEP 5: DIM_CURRENCY
-- Source: Currency + Currency_Rate [ERP System]
-- Currency columns    : currency_code, currency_name
-- Currency_Rate cols  : effective_date, currency_code,
--                       currency_rate
-- -------------------------------------------------------------
DROP TABLE IF EXISTS dw.dim_currency;

CREATE TABLE dw.dim_currency (
    currency_sk         INT             NOT NULL AUTO_INCREMENT,  
    currency_code       CHAR(3)         NOT NULL,                 
    currency_name       VARCHAR(50)     NOT NULL,                 
    effective_date      DATE            NOT NULL,                 
    currency_rate       DECIMAL(10,6)   NOT NULL,                 
    source_system_code  TINYINT         NOT NULL DEFAULT 0,
    create_timestamp    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_timestamp    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_dim_currency PRIMARY KEY (currency_sk),
    CONSTRAINT uq_dim_currency UNIQUE (currency_code, effective_date)
);

-- -------------------------------------------------------------
-- STEP 6: DIM_CUSTOMER
-- Source: Customer [Sales System]
-- Columns: customer_number, customer_type, name, gender,
--          date_of_birth, city, state, zipcode, country,
--          occupation, household_income, status, permission,
--          preferred_channel1, preferred_channel2,
--          interest1, interest2, interest3, Market
-- SCD Type 2 columns added:
--          effective_from, effective_to, is_current_flag
-- -------------------------------------------------------------
DROP TABLE IF EXISTS dw.dim_customer;

CREATE TABLE dw.dim_customer (
    customer_sk             INT             NOT NULL AUTO_INCREMENT,  
    customer_number         INT             NOT NULL,                 
    customer_type           CHAR(1)         NOT NULL,                 
    name                    VARCHAR(100)    NOT NULL,
    gender                  CHAR(1)         NOT NULL,                 
    date_of_birth           DATE            NOT NULL,
    age_group               VARCHAR(10)     NOT NULL,                 
    city                    VARCHAR(100)    NOT NULL,
    state                   CHAR(3)         NULL,                     
    zipcode                 INT             NOT NULL,
    country                 CHAR(2)         NOT NULL,
    occupation              VARCHAR(100)    NOT NULL,
    household_income        INT             NOT NULL,                 
    status                  CHAR(2)         NOT NULL,                 
    permission              CHAR(1)         NOT NULL,                 
    preferred_channel1      VARCHAR(20)     NOT NULL,
    preferred_channel2      VARCHAR(20)     NOT NULL,
    interest1               VARCHAR(50)     NOT NULL,
    interest2               VARCHAR(50)     NOT NULL,
    interest3               VARCHAR(50)     NOT NULL,
    market                  VARCHAR(30)     NOT NULL,                 
    effective_from          DATE            NOT NULL,                 
    effective_to            DATE            NOT NULL,                 
    is_current_flag         CHAR(1)         NOT NULL DEFAULT 'Y',     
    source_system_code      TINYINT         NOT NULL DEFAULT 0,
    create_timestamp        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_timestamp        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_dim_customer PRIMARY KEY (customer_sk)
);

-- -------------------------------------------------------------
-- STEP 7: DIM_STORE
-- Source: Store [Sales System]
-- Columns: store_number, store_name, store_type, city,
--          state, zipcode, country, region, division
-- -------------------------------------------------------------
DROP TABLE IF EXISTS dw.dim_store;

CREATE TABLE dw.dim_store (
    store_sk            INT             NOT NULL AUTO_INCREMENT,  
    store_number        INT             NOT NULL,                 
    store_name          VARCHAR(100)    NOT NULL,
    store_type          VARCHAR(30)     NOT NULL,                 
    city                VARCHAR(100)    NOT NULL,
    state               CHAR(3)         NULL,                     
    zipcode             VARCHAR(20)     NOT NULL,
    country             CHAR(2)         NOT NULL,
    region              VARCHAR(50)     NOT NULL,                 
    division            VARCHAR(10)     NOT NULL,                 
    source_system_code  TINYINT         NOT NULL DEFAULT 0,
    create_timestamp    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_timestamp    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_dim_store PRIMARY KEY (store_sk),
    CONSTRAINT uq_dim_store UNIQUE (store_number)
);

-- -------------------------------------------------------------
-- STEP 8: DIM_PACKAGE
-- Source: Package + Package_Type [Sales System]
-- Package cols     : Package_id, name, description,
--                    package_type, package_price
-- Package_Type cols: package_type_code, package_type
-- -------------------------------------------------------------
DROP TABLE IF EXISTS dw.dim_package;

CREATE TABLE dw.dim_package (
    package_sk          INT             NOT NULL AUTO_INCREMENT,  
    package_id          INT             NOT NULL,                 
    name                VARCHAR(100)    NOT NULL,                 
    description         VARCHAR(255)    NOT NULL,
    package_type        CHAR(2)         NOT NULL,                 
    package_type_desc   VARCHAR(50)     NOT NULL,                 
    package_price       DECIMAL(10,2)   NOT NULL,                 
    source_system_code  TINYINT         NOT NULL DEFAULT 0,
    create_timestamp    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_timestamp    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_dim_package PRIMARY KEY (package_sk),
    CONSTRAINT uq_dim_package UNIQUE (package_id)
);

-- -------------------------------------------------------------
-- STEP 9: FACT_PRODUCT_SALES
-- Source: Order_Header + Order_Details + Currency_Rate
-- Grain: one row per order line item (individual purchases)
-- Order_Header cols used : order_id, order_date,
--                          customer_number, store_number,
--                          currency
-- Order_Details cols used: order_id, line_no, product_code,
--                          qty, price, unit_cost
-- dim_date joined on     : sql_date = Order_Header.order_date
-- dim_currency joined on : currency_code + effective_date
--                          matching order month
-- -------------------------------------------------------------
DROP TABLE IF EXISTS dw.fact_product_sales;

CREATE TABLE dw.fact_product_sales (
    order_id            INT             NOT NULL,   
    line_no             INT             NOT NULL,   
    product_sk          INT             NOT NULL,   
    date_key            INT             NOT NULL,   
    customer_sk         INT             NOT NULL,   
    store_sk            INT             NOT NULL,   
    currency_sk         INT             NOT NULL,   
    qty                 INT             NOT NULL,   
    price               DECIMAL(10,2)   NOT NULL,   
    unit_cost           DECIMAL(10,2)   NOT NULL,   
    dollar_sales_usd    DECIMAL(12,2)   NOT NULL,   
    cost_usd            DECIMAL(12,2)   NOT NULL,   
    margin_usd          DECIMAL(12,2)   NOT NULL,   
    source_system_code  TINYINT         NOT NULL DEFAULT 0,
    create_timestamp    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_timestamp    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_fact_product_sales PRIMARY KEY (order_id, line_no),
    CONSTRAINT fk_fps_product
        FOREIGN KEY (product_sk)
        REFERENCES dw.dim_product (product_sk),
    CONSTRAINT fk_fps_date
        FOREIGN KEY (date_key)
        REFERENCES dw.dim_date (date_key),
    CONSTRAINT fk_fps_customer
        FOREIGN KEY (customer_sk)
        REFERENCES dw.dim_customer (customer_sk),
    CONSTRAINT fk_fps_store
        FOREIGN KEY (store_sk)
        REFERENCES dw.dim_store (store_sk),
    CONSTRAINT fk_fps_currency
        FOREIGN KEY (currency_sk)
        REFERENCES dw.dim_currency (currency_sk)
);

-- -------------------------------------------------------------
-- STEP 10: FACT_SUBSCRIPTION_REVENUE
-- Source: Subscription + Package
-- Grain: one row per active subscription per month
-- Subscription cols used: subscription_id, Customer_id,
--                         Store_Id, Package_id,
--                         start_date, end_date, status
-- Note: start_date and end_date in source are INT (YYYYMMDD)
--       ETL must convert to DATE before matching dim_date
-- dim_date joined on    : sql_date = snapshot month start
-- -------------------------------------------------------------
DROP TABLE IF EXISTS dw.fact_subscription_revenue;

CREATE TABLE dw.fact_subscription_revenue (
    subscription_id         INT             NOT NULL,   
    date_key                INT             NOT NULL,   
    package_sk              INT             NOT NULL,   
    customer_sk             INT             NOT NULL,   
    store_sk                INT             NOT NULL,   
    package_price           DECIMAL(12,2)   NOT NULL,   
    monthly_revenue_usd     DECIMAL(12,2)   NOT NULL,   
    status                  VARCHAR(20)     NOT NULL,   
    months_active           INT             NOT NULL,   
    source_system_code      TINYINT         NOT NULL DEFAULT 0,
    create_timestamp        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_timestamp        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_fact_subscription_revenue PRIMARY KEY (subscription_id, date_key),
    CONSTRAINT fk_fsr_date
        FOREIGN KEY (date_key)
        REFERENCES dw.dim_date (date_key),
    CONSTRAINT fk_fsr_package
        FOREIGN KEY (package_sk)
        REFERENCES dw.dim_package (package_sk),
    CONSTRAINT fk_fsr_customer
        FOREIGN KEY (customer_sk)
        REFERENCES dw.dim_customer (customer_sk),
    CONSTRAINT fk_fsr_store
        FOREIGN KEY (store_sk)
        REFERENCES dw.dim_store (store_sk)
);

-- -------------------------------------------------------------
-- INDEXES: Improve query performance on common join columns
-- -------------------------------------------------------------
CREATE INDEX idx_fps_product_sk   ON dw.fact_product_sales (product_sk);
CREATE INDEX idx_fps_date_key     ON dw.fact_product_sales (date_key);
CREATE INDEX idx_fps_customer_sk  ON dw.fact_product_sales (customer_sk);
CREATE INDEX idx_fps_store_sk     ON dw.fact_product_sales (store_sk);
CREATE INDEX idx_fps_currency_sk  ON dw.fact_product_sales (currency_sk);

CREATE INDEX idx_fsr_date_key     ON dw.fact_subscription_revenue (date_key);
CREATE INDEX idx_fsr_package_sk   ON dw.fact_subscription_revenue (package_sk);
CREATE INDEX idx_fsr_customer_sk  ON dw.fact_subscription_revenue (customer_sk);
CREATE INDEX idx_fsr_store_sk     ON dw.fact_subscription_revenue (store_sk);

CREATE INDEX idx_dp_product_type_sk     ON dw.dim_product (product_type_sk);
CREATE INDEX idx_dp_product_category_sk ON dw.dim_product (product_category_sk);
CREATE INDEX idx_dpt_category_sk        ON dw.dim_product_type (product_category_sk);

-- ============================================================
-- ICE Entertainment - Date Dimension
-- Database: dw
-- Compatible: MySQL 8.0+
-- Date Range: 1998-01-01 to 2026-12-31
-- ============================================================

CREATE DATABASE IF NOT EXISTS dw;
USE dw;

-- ── Drop and recreate table ──────────────────────────────────
DROP TABLE IF EXISTS dw.dim_date;

CREATE TABLE dw.dim_date (
    date_key            INT             NOT NULL AUTO_INCREMENT,
    date                CHAR(10)        NOT NULL,
    system_date         CHAR(10)        NOT NULL,
    sql_date            DATE            NOT NULL,
    julian_date         INT             NOT NULL,
    day                 TINYINT         NOT NULL,
    day_of_the_week     TINYINT         NOT NULL,
    day_name            VARCHAR(9)      NOT NULL,
    day_of_the_year     SMALLINT        NOT NULL,
    week_number         TINYINT         NOT NULL,
    month               TINYINT         NOT NULL,
    month_name          VARCHAR(9)      NOT NULL,
    short_month_name    CHAR(3)         NOT NULL,
    quarter             CHAR(2)         NOT NULL,
    year                SMALLINT        NOT NULL,
    fiscal_week         TINYINT         NULL,
    fiscal_period       CHAR(4)         NULL,
    fiscal_quarter      CHAR(3)         NULL,
    fiscal_year         CHAR(6)         NULL,
    week_day            TINYINT         NOT NULL,
    us_holiday          TINYINT         NULL,
    uk_holiday          TINYINT         NULL,
    month_end           TINYINT         NOT NULL,
    period_end          TINYINT         NULL,
    short_day           TINYINT         NULL,
    source_system_code  TINYINT         NOT NULL,
    create_timestamp    DATETIME        NOT NULL,
    update_timestamp    DATETIME        NOT NULL,
    CONSTRAINT pk_dim_date PRIMARY KEY (date_key)
);


-- ── Stored procedure to populate dim_date ───────────────────
DROP PROCEDURE IF EXISTS dw.populate_dim_date;

DELIMITER $$

CREATE PROCEDURE dw.populate_dim_date(
    IN p_start_date DATE,
    IN p_end_date   DATE
)
BEGIN
    -- Variables
    DECLARE v_date              DATE;
    DECLARE v_day               INT;
    DECLARE v_cday              CHAR(2);
    DECLARE v_day_of_the_week   INT;
    DECLARE v_day_name          VARCHAR(9);
    DECLARE v_day_of_the_year   INT;
    DECLARE v_week_number       INT;
    DECLARE v_month             INT;
    DECLARE v_cmonth            CHAR(2);
    DECLARE v_month_name        VARCHAR(9);
    DECLARE v_short_month       CHAR(3);
    DECLARE v_quarter           CHAR(2);
    DECLARE v_year              INT;
    DECLARE v_cyear             CHAR(4);
    DECLARE v_fiscal_week       INT;
    DECLARE v_fiscal_period     CHAR(4);
    DECLARE v_fiscal_quarter    CHAR(3);
    DECLARE v_fiscal_year       CHAR(6);
    DECLARE v_week_day          TINYINT;
    DECLARE v_month_end         TINYINT;
    DECLARE v_period_end        TINYINT;
    DECLARE v_fiscal_start      DATE;
    DECLARE v_weeks_since_sep   INT;
    DECLARE v_fp_num            INT;
    DECLARE v_period_num        INT;

    SET v_date = p_start_date;

    WHILE v_date <= p_end_date DO

        -- ── Basic date parts ────────────────────────────────
        SET v_day             = DAY(v_date);
        SET v_cday            = LPAD(v_day, 2, '0');
        -- MySQL: DAYOFWEEK() returns 1=Sun,2=Mon,...,7=Sat
        SET v_day_of_the_week = DAYOFWEEK(v_date);
        SET v_day_name        = DAYNAME(v_date);
        SET v_day_of_the_year = DAYOFYEAR(v_date);
        SET v_week_number     = WEEK(v_date, 3);   -- ISO week
        SET v_month           = MONTH(v_date);
        SET v_cmonth          = LPAD(v_month, 2, '0');
        SET v_month_name      = MONTHNAME(v_date);
        SET v_short_month     = LEFT(MONTHNAME(v_date), 3);
        SET v_quarter         = CONCAT('Q', QUARTER(v_date));
        SET v_year            = YEAR(v_date);
        SET v_cyear           = CAST(v_year AS CHAR);

        -- ── Fiscal week (weeks since Sep 1 of fiscal year) ──
        -- Sep-Dec: fiscal year starts Sep 1 of same calendar year
        -- Jan-Aug: fiscal year started Sep 1 of prior calendar year
        IF v_month >= 9 THEN
            SET v_fiscal_start = DATE(CONCAT(v_year, '-09-01'));
            SET v_fiscal_year  = CONCAT('FY', v_year + 1);
        ELSE
            SET v_fiscal_start = DATE(CONCAT(v_year - 1, '-09-01'));
            SET v_fiscal_year  = CONCAT('FY', v_year);
        END IF;

        SET v_weeks_since_sep = FLOOR(DATEDIFF(v_date, v_fiscal_start) / 7) + 1;
        SET v_fiscal_week     = v_weeks_since_sep;

        -- ── Fiscal period using 4-5-4 pattern ───────────────
        -- 13 periods per year based on week blocks: 4,5,4 | 4,5,4 | 4,5,4 | 4,5,4
        SET v_fp_num = CASE
            WHEN v_fiscal_week BETWEEN  1 AND  4  THEN 1
            WHEN v_fiscal_week BETWEEN  5 AND  9  THEN 2
            WHEN v_fiscal_week BETWEEN 10 AND 13  THEN 3
            WHEN v_fiscal_week BETWEEN 14 AND 17  THEN 4
            WHEN v_fiscal_week BETWEEN 18 AND 22  THEN 5
            WHEN v_fiscal_week BETWEEN 23 AND 26  THEN 6
            WHEN v_fiscal_week BETWEEN 27 AND 30  THEN 7
            WHEN v_fiscal_week BETWEEN 31 AND 35  THEN 8
            WHEN v_fiscal_week BETWEEN 36 AND 39  THEN 9
            WHEN v_fiscal_week BETWEEN 40 AND 43  THEN 10
            WHEN v_fiscal_week BETWEEN 44 AND 48  THEN 11
            WHEN v_fiscal_week BETWEEN 49 AND 52  THEN 12
            ELSE 13
        END;
        SET v_fiscal_period = CONCAT('FP', LPAD(v_fp_num, 2, '0'));

        -- ── Fiscal quarter (groups of 3 fiscal periods) ─────
        SET v_fiscal_quarter = CONCAT('FQ', FLOOR((v_fp_num - 1) / 3) + 1);

        -- ── Week day: 1 = Mon-Fri, 0 = Sat/Sun ──────────────
        -- DAYOFWEEK: 1=Sun, 2=Mon, 3=Tue, 4=Wed, 5=Thu, 6=Fri, 7=Sat
        IF v_day_of_the_week BETWEEN 2 AND 6 THEN
            SET v_week_day = 1;
        ELSE
            SET v_week_day = 0;
        END IF;

        -- ── Month end: 1 if tomorrow is a different month ────
        IF MONTH(DATE_ADD(v_date, INTERVAL 1 DAY)) <> v_month THEN
            SET v_month_end = 1;
        ELSE
            SET v_month_end = 0;
        END IF;

        -- ── Period end: 1 if tomorrow is a different fiscal period ──
        SET v_period_num = CASE
            WHEN (FLOOR(DATEDIFF(DATE_ADD(v_date, INTERVAL 1 DAY), v_fiscal_start) / 7) + 1)
                 BETWEEN  1 AND  4  THEN 1
            WHEN (FLOOR(DATEDIFF(DATE_ADD(v_date, INTERVAL 1 DAY), v_fiscal_start) / 7) + 1)
                 BETWEEN  5 AND  9  THEN 2
            WHEN (FLOOR(DATEDIFF(DATE_ADD(v_date, INTERVAL 1 DAY), v_fiscal_start) / 7) + 1)
                 BETWEEN 10 AND 13  THEN 3
            WHEN (FLOOR(DATEDIFF(DATE_ADD(v_date, INTERVAL 1 DAY), v_fiscal_start) / 7) + 1)
                 BETWEEN 14 AND 17  THEN 4
            WHEN (FLOOR(DATEDIFF(DATE_ADD(v_date, INTERVAL 1 DAY), v_fiscal_start) / 7) + 1)
                 BETWEEN 18 AND 22  THEN 5
            WHEN (FLOOR(DATEDIFF(DATE_ADD(v_date, INTERVAL 1 DAY), v_fiscal_start) / 7) + 1)
                 BETWEEN 23 AND 26  THEN 6
            WHEN (FLOOR(DATEDIFF(DATE_ADD(v_date, INTERVAL 1 DAY), v_fiscal_start) / 7) + 1)
                 BETWEEN 27 AND 30  THEN 7
            WHEN (FLOOR(DATEDIFF(DATE_ADD(v_date, INTERVAL 1 DAY), v_fiscal_start) / 7) + 1)
                 BETWEEN 31 AND 35  THEN 8
            WHEN (FLOOR(DATEDIFF(DATE_ADD(v_date, INTERVAL 1 DAY), v_fiscal_start) / 7) + 1)
                 BETWEEN 36 AND 39  THEN 9
            WHEN (FLOOR(DATEDIFF(DATE_ADD(v_date, INTERVAL 1 DAY), v_fiscal_start) / 7) + 1)
                 BETWEEN 40 AND 43  THEN 10
            WHEN (FLOOR(DATEDIFF(DATE_ADD(v_date, INTERVAL 1 DAY), v_fiscal_start) / 7) + 1)
                 BETWEEN 44 AND 48  THEN 11
            WHEN (FLOOR(DATEDIFF(DATE_ADD(v_date, INTERVAL 1 DAY), v_fiscal_start) / 7) + 1)
                 BETWEEN 49 AND 52  THEN 12
            ELSE 13
        END;

        IF v_period_num <> v_fp_num THEN
            SET v_period_end = 1;
        ELSE
            SET v_period_end = 0;
        END IF;

        -- ── Insert row ───────────────────────────────────────
        INSERT INTO dw.dim_date (
            date, system_date, sql_date, julian_date,
            day, day_of_the_week, day_name, day_of_the_year,
            week_number, month, month_name, short_month_name,
            quarter, year, fiscal_week, fiscal_period,
            fiscal_quarter, fiscal_year, week_day,
            us_holiday, uk_holiday, month_end,
            period_end, short_day, source_system_code,
            create_timestamp, update_timestamp
        )
        VALUES (
            CONCAT(v_cmonth, '/', v_cday, '/', v_cyear),   -- date  MM/DD/YYYY
            CONCAT(v_cyear, '-', v_cmonth, '-', v_cday),   -- system_date YYYY-MM-DD
            v_date,                                          -- sql_date
            DATEDIFF(v_date, '1900-01-01'),                  -- julian_date
            v_day,
            v_day_of_the_week,
            v_day_name,
            v_day_of_the_year,
            v_week_number,
            v_month,
            v_month_name,
            v_short_month,
            v_quarter,
            v_year,
            v_fiscal_week,
            v_fiscal_period,
            v_fiscal_quarter,
            v_fiscal_year,
            v_week_day,
            0,                  -- us_holiday (extend as needed)
            0,                  -- uk_holiday (extend as needed)
            v_month_end,
            v_period_end,
            0,                  -- short_day
            0,                  -- source_system_code
            NOW(),
            NOW()
        );

        SET v_date = DATE_ADD(v_date, INTERVAL 1 DAY);

    END WHILE;

END$$

DELIMITER ;


-- ── Execute: populate 1998-01-01 to 2026-12-31 ──────────────
CALL dw.populate_dim_date('1998-01-01', '2026-12-31');


-- ── Indexes ──────────────────────────────────────────────────
CREATE UNIQUE INDEX dim_date_sql_date
    ON dw.dim_date (sql_date);

CREATE UNIQUE INDEX dim_date_date
    ON dw.dim_date (date);

CREATE UNIQUE INDEX dim_date_system_date
    ON dw.dim_date (system_date);

CREATE INDEX dim_date_dow
    ON dw.dim_date (day_of_the_week);


-- ── Quick validation ─────────────────────────────────────────
SELECT
    COUNT(*)                        AS total_rows,
    MIN(sql_date)                   AS first_date,
    MAX(sql_date)                   AS last_date,
    SUM(week_day)                   AS total_weekdays,
    SUM(month_end)                  AS total_month_ends,
    COUNT(DISTINCT fiscal_year)     AS fiscal_years,
    COUNT(DISTINCT quarter)         AS distinct_quarters
FROM dw.dim_date;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'dw'
ORDER BY table_name;


USE dw;

DROP TABLE IF EXISTS dw.fact_product_sales;

CREATE TABLE dw.fact_product_sales (
    order_id            INT             NOT NULL,
    line_no             INT             NOT NULL,
    product_sk          INT             NOT NULL,
    date_key            INT             NOT NULL,
    customer_sk         INT             NOT NULL,
    store_sk            INT             NOT NULL,
    currency_sk         INT             NOT NULL,
    qty                 INT             NOT NULL,
    price               DECIMAL(10,2)   NOT NULL,
    unit_cost           DECIMAL(10,2)   NOT NULL,
    dollar_sales_usd    DECIMAL(12,2)   NOT NULL,
    cost_usd            DECIMAL(12,2)   NOT NULL,
    margin_usd          DECIMAL(12,2)   NOT NULL,
    source_system_code  TINYINT         NOT NULL DEFAULT 0,
    create_timestamp    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_timestamp    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_fact_product_sales PRIMARY KEY (order_id, line_no),
    CONSTRAINT fk_fps_product
        FOREIGN KEY (product_sk)
        REFERENCES dw.dim_product (product_sk),
    CONSTRAINT fk_fps_date
        FOREIGN KEY (date_key)
        REFERENCES dw.dim_date (date_key),
    CONSTRAINT fk_fps_customer
        FOREIGN KEY (customer_sk)
        REFERENCES dw.dim_customer (customer_sk),
    CONSTRAINT fk_fps_store
        FOREIGN KEY (store_sk)
        REFERENCES dw.dim_store (store_sk),
    CONSTRAINT fk_fps_currency
        FOREIGN KEY (currency_sk)
        REFERENCES dw.dim_currency (currency_sk)
);


DROP TABLE IF EXISTS dw.fact_subscription_revenue;

CREATE TABLE dw.fact_subscription_revenue (
    subscription_id         INT             NOT NULL,
    date_key                INT             NOT NULL,
    package_sk              INT             NOT NULL,
    customer_sk             INT             NOT NULL,
    store_sk                INT             NOT NULL,
    package_price           DECIMAL(12,2)   NOT NULL,
    monthly_revenue_usd     DECIMAL(12,2)   NOT NULL,
    status                  VARCHAR(20)     NOT NULL,
    months_active           INT             NOT NULL,
    source_system_code      TINYINT         NOT NULL DEFAULT 0,
    create_timestamp        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_timestamp        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_fact_subscription_revenue PRIMARY KEY (subscription_id, date_key),
    CONSTRAINT fk_fsr_date
        FOREIGN KEY (date_key)
        REFERENCES dw.dim_date (date_key),
    CONSTRAINT fk_fsr_package
        FOREIGN KEY (package_sk)
        REFERENCES dw.dim_package (package_sk),
    CONSTRAINT fk_fsr_customer
        FOREIGN KEY (customer_sk)
        REFERENCES dw.dim_customer (customer_sk),
    CONSTRAINT fk_fsr_store
        FOREIGN KEY (store_sk)
        REFERENCES dw.dim_store (store_sk)
);

CREATE INDEX idx_fps_product_sk    ON dw.fact_product_sales (product_sk);
CREATE INDEX idx_fps_date_key      ON dw.fact_product_sales (date_key);
CREATE INDEX idx_fps_customer_sk   ON dw.fact_product_sales (customer_sk);
CREATE INDEX idx_fps_store_sk      ON dw.fact_product_sales (store_sk);
CREATE INDEX idx_fps_currency_sk   ON dw.fact_product_sales (currency_sk);

CREATE INDEX idx_fsr_date_key      ON dw.fact_subscription_revenue (date_key);
CREATE INDEX idx_fsr_package_sk    ON dw.fact_subscription_revenue (package_sk);
CREATE INDEX idx_fsr_customer_sk   ON dw.fact_subscription_revenue (customer_sk);
CREATE INDEX idx_fsr_store_sk      ON dw.fact_subscription_revenue (store_sk);

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'dw'
ORDER BY table_name;