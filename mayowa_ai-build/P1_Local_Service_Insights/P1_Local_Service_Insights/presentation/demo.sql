SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
USE p1_local_services;
-- Source trace: Jiffy Lube tire rotation -> source 10 -> saved raw row O19.
SELECT b.business_name, s.service_name, bs.source_id, bs.raw_row_id,
       src.publisher, src.url, src.raw_file_path
FROM BusinessService bs JOIN Business b ON b.business_id=bs.business_id
JOIN Service s ON s.service_id=bs.service_id JOIN Source src ON src.source_id=bs.source_id
WHERE bs.business_id=10 AND bs.service_id=3;

-- Mayowa: Q3 threshold 1 -> 2. Four services -> two.
SET @minimum_providers=1;
SELECT s.service_name,COUNT(DISTINCT bs.business_id) AS provider_count
FROM Service s JOIN BusinessService bs ON bs.service_id=s.service_id
GROUP BY s.service_id,s.service_name HAVING COUNT(DISTINCT bs.business_id)>=@minimum_providers
ORDER BY provider_count DESC,s.service_name,s.service_id;
SET @minimum_providers=2;
SELECT s.service_name,COUNT(DISTINCT bs.business_id) AS provider_count
FROM Service s JOIN BusinessService bs ON bs.service_id=s.service_id
GROUP BY s.service_id,s.service_name HAVING COUNT(DISTINCT bs.business_id)>=@minimum_providers
ORDER BY provider_count DESC,s.service_name,s.service_id;

-- Cailin: Q2 oil (1) -> brake (2). Thirteen providers -> five.
SET @selected_city='Columbia';
SET @selected_service_id=1;
SELECT b.business_id,b.business_name,s.service_name,src.url,bs.raw_row_id
FROM Business b JOIN BusinessService bs ON bs.business_id=b.business_id
JOIN Service s ON s.service_id=bs.service_id JOIN Source src ON src.source_id=bs.source_id
WHERE b.city=@selected_city AND s.service_id=@selected_service_id
ORDER BY b.business_name,b.business_id;
SET @selected_service_id=2;
SELECT b.business_id,b.business_name,s.service_name,src.url,bs.raw_row_id
FROM Business b JOIN BusinessService bs ON bs.business_id=b.business_id
JOIN Service s ON s.service_id=bs.service_id JOIN Source src ON src.source_id=bs.source_id
WHERE b.city=@selected_city AND s.service_id=@selected_service_id
ORDER BY b.business_name,b.business_id;

-- Nebiyu: Q1 Auto -> Jiffy. Nine providers -> one.
SET @name_fragment='Auto';
SELECT business_id,business_name,city FROM Business
WHERE business_name LIKE CONCAT('%',@name_fragment,'%') ORDER BY business_name,business_id;
SET @name_fragment='Jiffy';
SELECT business_id,business_name,city FROM Business
WHERE business_name LIKE CONCAT('%',@name_fragment,'%') ORDER BY business_name,business_id;

-- Braiden: Q5 Jiffy (10) -> Dobbs (15). Four rows in both; matched types change.
SET @selected_business_id=10;
SELECT s.service_name,bs.business_id AS matched_business_id
FROM Service s LEFT JOIN BusinessService bs
 ON bs.service_id=s.service_id AND bs.business_id=@selected_business_id
ORDER BY s.service_name,s.service_id;
SET @selected_business_id=15;
SELECT s.service_name,bs.business_id AS matched_business_id
FROM Service s LEFT JOIN BusinessService bs
 ON bs.service_id=s.service_id AND bs.business_id=@selected_business_id
ORDER BY s.service_name,s.service_id;
