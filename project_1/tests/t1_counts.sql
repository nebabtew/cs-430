-- T1: Check the real data
USE cs430_project1;

-- Expected 15 businesses
SELECT COUNT(*) FROM Business;

-- Expected 35 services
SELECT COUNT(*) FROM Service;

-- Expected: 7 categories
SELECT COUNT(*) FROM ServiceCategory;

-- Expected 42 offerings. The primary key prevents duplicate pairs
SELECT COUNT(*) FROM BusinessService;

-- Expected 16 publishers
SELECT COUNT(DISTINCT publisher) FROM Source;

-- Expected 0 businesses with missing sources or empty evidence references
SELECT COUNT(*)
FROM Business b
LEFT JOIN Source s ON b.source_id = s.source_id
WHERE s.source_id IS NULL OR s.url = ''
   OR s.raw_file_path = '' OR b.raw_row_id = '';

-- Expected 0 offerings with missing sources or empty evidence references
SELECT COUNT(*)
FROM BusinessService bs
LEFT JOIN Source s ON bs.source_id = s.source_id
WHERE s.source_id IS NULL OR s.url = ''
   OR s.raw_file_path = '' OR bs.raw_row_id = '';

-- Expected 0 businesses without an offering.
SELECT COUNT(*)
FROM Business b
LEFT JOIN BusinessService bs ON b.business_id = bs.business_id
WHERE bs.business_id IS NULL;