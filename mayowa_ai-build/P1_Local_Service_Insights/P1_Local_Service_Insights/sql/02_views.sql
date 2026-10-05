SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
USE p1_local_services;
CREATE OR REPLACE SQL SECURITY INVOKER VIEW BusinessDirectory AS
SELECT business_id, business_name, address, city, website
FROM Business;
