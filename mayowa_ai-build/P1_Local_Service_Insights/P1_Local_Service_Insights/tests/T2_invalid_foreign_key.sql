SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
-- Run separately AFTER a populated real build. An error is expected.
USE p1_local_services;
SET SESSION FOREIGN_KEY_CHECKS = 1;
-- Real identifiers must be positive; -999999 is reserved as nonexistent.
SELECT COUNT(*) AS must_be_zero FROM Business WHERE business_id = -999999;
SELECT COUNT(*) AS must_be_at_least_one FROM BusinessService;
START TRANSACTION;
INSERT INTO BusinessService (business_id, service_id, source_id, raw_row_id)
SELECT -999999, service_id, source_id, raw_row_id
FROM BusinessService ORDER BY business_id, service_id LIMIT 1;
-- Expected: ERROR 1452, fk_offering_business, no new offering.
-- In Workbench run ROLLBACK separately if execution stops at the expected error.
ROLLBACK;
