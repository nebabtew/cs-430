-- T4: We add two made-up businesses and services, then remove them at the end
-- START TRANSACTION allows ROLLBACK to undo everything we insert here
-- Source 1 and category 1 already exist, so we use them for the test records
USE cs430_project1;

START TRANSACTION;

INSERT INTO Business (business_id, name, address, city, website, source_id, raw_row_id)
VALUES
    (1001, 'TEST A', 'TEST Address A', 'TEST City', NULL, 1, 'TEST_A'),
    (1002, 'TEST B', 'TEST Address B', 'TEST City', 'https://example.invalid/', 1, 'TEST_B');

INSERT INTO Service (service_id, service_name, category_id)
VALUES (1001, 'TEST Service A', 1), (1002, 'TEST Service B', 1);

INSERT INTO BusinessService (business_id, service_id, source_id, raw_row_id)
VALUES (1001, 1001, 1, 'TEST_A'), (1002, 1001, 1, 'TEST_B');

-- Q3: Both test businesses offer service 1001, so we count two by hand
-- The query should also return service 1001 with a count of 2
SELECT s.service_id, COUNT(DISTINCT bs.business_id) AS business_count
FROM Service s
JOIN BusinessService bs ON s.service_id = bs.service_id
WHERE s.service_id IN (1001, 1002)
GROUP BY s.service_id
HAVING COUNT(DISTINCT bs.business_id) >= 2
ORDER BY s.service_id;

-- Q4: We did not record service 1002 for either business
-- Both business IDs, 1001 and 1002, should appear here
SELECT b.business_id
FROM Business b
WHERE b.business_id IN (1001, 1002)
  AND NOT EXISTS (
    SELECT 1 FROM BusinessService bs
    WHERE bs.business_id = b.business_id AND bs.service_id = 1002
)
ORDER BY b.business_id;

-- Q5: Business 1001 has service 1001, but no recorded service 1002
-- Both services should appear. The second row should have a NULL business ID
SELECT s.service_id, bs.business_id
FROM Service s
LEFT JOIN BusinessService bs
    ON s.service_id = bs.service_id AND bs.business_id = 1001
WHERE s.service_id IN (1001, 1002)
ORDER BY s.service_id;

-- Q6: We left business 1001's website blank using NULL
-- Only business 1001 should appear here
SELECT business_id
FROM BusinessDirectory
WHERE website IS NULL AND business_id IN (1001, 1002)
ORDER BY business_id;

-- Remove the test data by undoing the inserts
ROLLBACK;

-- Check that the test data is gone. Each count should be 0
SELECT COUNT(*) FROM Business WHERE business_id IN (1001, 1002);
SELECT COUNT(*) FROM Service WHERE service_id IN (1001, 1002);
SELECT COUNT(*) FROM BusinessService WHERE business_id IN (1001, 1002);
