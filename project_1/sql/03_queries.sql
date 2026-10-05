USE cs430_project1;

-- Q1: Find businesses whose names contain "Auto"
SELECT business_id, name, city
FROM Business
WHERE name LIKE '%Auto%'
ORDER BY business_id;

-- Q2: Find St. Louis businesses with a recorded Oil change offering.
SELECT b.business_id, b.name, b.city, s.service_name,
       src.url, bs.raw_row_id
FROM Business b
INNER JOIN BusinessService bs ON b.business_id = bs.business_id
INNER JOIN Service s ON bs.service_id = s.service_id
INNER JOIN Source src ON bs.source_id = src.source_id
WHERE b.city = 'St. Louis'
  AND s.service_name = 'Oil change'
ORDER BY b.business_id;

-- Q3: Count distinct businesses per service; keep services with 2+ providers.
SELECT s.service_id, s.service_name,
       COUNT(DISTINCT bs.business_id) AS business_count
FROM Service s
INNER JOIN BusinessService bs ON s.service_id = bs.service_id
GROUP BY s.service_id, s.service_name
HAVING COUNT(DISTINCT bs.business_id) >= 2
ORDER BY s.service_id;

-- Q4: Find businesses with no recorded Oil change offering.
SELECT b.business_id, b.name, b.city
FROM Business b
WHERE NOT EXISTS (
    SELECT 1
    FROM BusinessService bs
    INNER JOIN Service s ON bs.service_id = s.service_id
    WHERE bs.business_id = b.business_id
      AND s.service_name = 'Oil change'
)
ORDER BY b.business_id;

-- Q5: Show ALL service types and whether Fit City Gym (business 5) has one.
SELECT s.service_id, s.service_name, bs.business_id
FROM Service s
LEFT JOIN BusinessService bs
    ON s.service_id = bs.service_id
   AND bs.business_id = 5
ORDER BY s.service_id;

-- Q6: Use the directory view to find businesses with no recorded website.
SELECT business_id, name, city
FROM BusinessDirectory
WHERE website IS NULL
ORDER BY business_id;
