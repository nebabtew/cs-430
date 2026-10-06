-- T2: Expecting a foreign key error since business 999999 does not exist.
USE cs430_project1;

START TRANSACTION;
INSERT INTO BusinessService (business_id, service_id, source_id, raw_row_id)
VALUES (999999, 1, 1, 'TEST');
ROLLBACK;

-- The error means it passes