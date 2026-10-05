SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
-- Run separately AFTER a populated real build. An error is expected.
USE p1_local_services;
SELECT COUNT(*) AS must_be_at_least_one FROM BusinessService;
START TRANSACTION;
INSERT INTO BusinessService (business_id, service_id, source_id, raw_row_id)
SELECT business_id, service_id, source_id, raw_row_id
FROM BusinessService ORDER BY business_id, service_id LIMIT 1;
-- Expected: ERROR 1062, duplicate PRIMARY KEY, no new offering.
-- In Workbench run ROLLBACK separately if execution stops at the expected error.
ROLLBACK;
