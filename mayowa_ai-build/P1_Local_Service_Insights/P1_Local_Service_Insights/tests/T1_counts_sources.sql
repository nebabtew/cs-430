SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
USE p1_local_services;
SELECT VERSION() AS actual_mysql_version, @@SESSION.foreign_key_checks AS fk_checks;
SELECT 'businesses' AS measure, COUNT(*) AS actual, 15 AS minimum, COUNT(*) >= 15 AS pass FROM Business
UNION ALL SELECT 'services', COUNT(*), 4, COUNT(*) >= 4 FROM Service
UNION ALL SELECT 'categories', COUNT(*), 2, COUNT(*) >= 2 FROM ServiceCategory
UNION ALL SELECT 'distinct_offerings', COUNT(*), 20, COUNT(*) >= 20 FROM BusinessService
UNION ALL SELECT 'publishers', COUNT(DISTINCT publisher), 2, COUNT(DISTINCT publisher) >= 2 FROM Source;
-- Composite PK guarantees each counted offering is a distinct pair.
-- All following counts must be zero. Also inspect the actual saved raw rows manually.
SELECT 'business_missing_identity_evidence' AS check_name, COUNT(*) AS failures
FROM Business AS b LEFT JOIN Source AS s ON s.source_id = b.identity_source_id
WHERE s.source_id IS NULL OR TRIM(b.identity_raw_row_id) = ''
UNION ALL
SELECT 'business_missing_location_evidence', COUNT(*)
FROM Business AS b LEFT JOIN Source AS s ON s.source_id = b.location_source_id
WHERE s.source_id IS NULL OR TRIM(b.location_raw_row_id) = ''
UNION ALL
SELECT 'offering_missing_source_evidence', COUNT(*)
FROM BusinessService AS bs LEFT JOIN Source AS s ON s.source_id = bs.source_id
WHERE s.source_id IS NULL OR TRIM(bs.raw_row_id) = ''
UNION ALL
SELECT 'offering_missing_business', COUNT(*)
FROM BusinessService AS bs LEFT JOIN Business AS b ON b.business_id = bs.business_id
WHERE b.business_id IS NULL
UNION ALL
SELECT 'offering_missing_service', COUNT(*)
FROM BusinessService AS bs LEFT JOIN Service AS s ON s.service_id = bs.service_id
WHERE s.service_id IS NULL
UNION ALL
SELECT 'business_without_offering', COUNT(*) FROM Business AS b
WHERE NOT EXISTS (SELECT 1 FROM BusinessService AS bs WHERE bs.business_id = b.business_id)
UNION ALL
SELECT 'missing_required_business_text', COUNT(*) FROM Business
WHERE TRIM(business_name) = '' OR TRIM(address) = '' OR TRIM(city) = ''
UNION ALL
SELECT 'missing_source_fields', COUNT(*) FROM Source
WHERE TRIM(publisher) = '' OR TRIM(title) = '' OR TRIM(url) = '' OR TRIM(raw_file_path) = '';
