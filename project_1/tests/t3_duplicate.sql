-- T3: Epecting a duplicate-key error 1062 since business 1 already has service 1
USE cs430_project1;

START TRANSACTION;
INSERT INTO BusinessService (business_id, service_id, source_id, raw_row_id)
VALUES (1, 1, 1, 'R001');
ROLLBACK;

-- The error also means it passes