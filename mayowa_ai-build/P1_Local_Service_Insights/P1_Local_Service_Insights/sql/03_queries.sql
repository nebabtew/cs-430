SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
USE p1_local_services;
-- Parameters fixed for the submitted Columbia snapshot.
-- Q1: use a fragment with at least one real match.
SET @name_fragment = 'Auto';
SET @selected_city = 'Columbia';
SET @selected_service_id = 1;
SET @minimum_providers = 2;
SET @selected_business_id = 10;

-- Q1: matched business identity/city; stable order includes a tie-breaker.
SELECT 'Q1' AS query_label;
SELECT business_id, business_name, city
FROM Business
WHERE business_name LIKE CONCAT('%', @name_fragment, '%')
ORDER BY business_name, business_id;

-- Q2: source-supported offering in selected city. One row per provider.
-- If the evidence is business-wide: business offering; branch availability unverified.
SELECT 'Q2' AS query_label;
SELECT b.business_id, b.business_name, s.service_name,
       src.url AS source_url, bs.raw_row_id,
       src.raw_file_path
FROM Business AS b
INNER JOIN BusinessService AS bs ON bs.business_id = b.business_id
INNER JOIN Service AS s ON s.service_id = bs.service_id
INNER JOIN Source AS src ON src.source_id = bs.source_id
WHERE b.city = @selected_city AND s.service_id = @selected_service_id
ORDER BY b.business_name, b.business_id;

-- Q3: number of distinct sampled providers; threshold is @minimum_providers.
SELECT 'Q3' AS query_label;
SELECT s.service_id, s.service_name,
       COUNT(DISTINCT bs.business_id) AS provider_count
FROM Service AS s
INNER JOIN BusinessService AS bs ON bs.service_id = s.service_id
GROUP BY s.service_id, s.service_name
HAVING COUNT(DISTINCT bs.business_id) >= @minimum_providers
ORDER BY provider_count DESC, s.service_name, s.service_id;

-- Q4: NOT RECORDED does not establish that a business lacks the service.
SELECT 'Q4' AS query_label;
SELECT b.business_id, b.business_name
FROM Business AS b
WHERE NOT EXISTS (
 SELECT 1 FROM BusinessService AS bs
 WHERE bs.business_id = b.business_id
   AND bs.service_id = @selected_service_id
)
ORDER BY b.business_name, b.business_id;

-- Q5: business condition belongs in ON; all service types survive the join.
SELECT 'Q5' AS query_label;
SELECT s.service_id, s.service_name, bs.business_id AS matched_business_id
FROM Service AS s
LEFT JOIN BusinessService AS bs
 ON bs.service_id = s.service_id
 AND bs.business_id = @selected_business_id
ORDER BY s.service_name, s.service_id;

-- Q6: NULL means no website recorded, not proven absence of a website.
SELECT 'Q6' AS query_label;
SELECT business_id, business_name, city
FROM BusinessDirectory
WHERE website IS NULL
ORDER BY business_name, business_id;
