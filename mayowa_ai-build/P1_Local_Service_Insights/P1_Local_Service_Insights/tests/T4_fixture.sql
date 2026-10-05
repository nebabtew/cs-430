-- Dedicated project database only. This reset deletes its previous contents.
-- Intended for MySQL 8.0+. Record SELECT VERSION() from your actual server.
DROP DATABASE IF EXISTS p1_validation_fixture;
CREATE DATABASE p1_validation_fixture CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE p1_validation_fixture;
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET SESSION FOREIGN_KEY_CHECKS = 1;
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,ONLY_FULL_GROUP_BY,NO_ENGINE_SUBSTITUTION';

-- A source is one cited page/dataset, not an entire publisher.
CREATE TABLE Source (
 source_id INT PRIMARY KEY,
 publisher VARCHAR(255) NOT NULL,
 title VARCHAR(500) NOT NULL,
 url TEXT NOT NULL,
 collection_date DATE NOT NULL,
 raw_file_path VARCHAR(500) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE ServiceCategory (
 category_id INT PRIMARY KEY,
 category_name VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE Service (
 service_id INT PRIMARY KEY,
 service_name VARCHAR(150) NOT NULL UNIQUE,
 category_id INT NOT NULL,
 CONSTRAINT fk_service_category FOREIGN KEY (category_id)
 REFERENCES ServiceCategory(category_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

-- One selected physical location per distinct business.
-- Identity/location can cite the same source or two different sources.
CREATE TABLE Business (
 business_id INT PRIMARY KEY,
 business_name VARCHAR(255) NOT NULL,
 address VARCHAR(500) NOT NULL,
 city VARCHAR(100) NOT NULL,
 website TEXT NULL,
 identity_source_id INT NOT NULL,
 identity_raw_row_id VARCHAR(100) NOT NULL,
 location_source_id INT NOT NULL,
 location_raw_row_id VARCHAR(100) NOT NULL,
 CONSTRAINT uq_business_location UNIQUE (business_name, address, city),
 CONSTRAINT fk_business_identity FOREIGN KEY (identity_source_id)
 REFERENCES Source(source_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
 CONSTRAINT fk_business_location FOREIGN KEY (location_source_id)
 REFERENCES Source(source_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

-- One source-supported offering per business/service combination.
CREATE TABLE BusinessService (
 business_id INT NOT NULL,
 service_id INT NOT NULL,
 source_id INT NOT NULL,
 raw_row_id VARCHAR(100) NOT NULL,
 PRIMARY KEY (business_id, service_id),
 CONSTRAINT fk_offering_business FOREIGN KEY (business_id)
 REFERENCES Business(business_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
 CONSTRAINT fk_offering_service FOREIGN KEY (service_id)
 REFERENCES Service(service_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
 CONSTRAINT fk_offering_source FOREIGN KEY (source_id)
 REFERENCES Source(source_id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

-- SYNTHETIC DATA: isolated correctness fixture, never real collection evidence.
INSERT INTO Source VALUES (1,'Synthetic Test Publisher','Fixture','https://example.invalid/fixture','2026-10-04','tests/T4_fixture.sql');
INSERT INTO ServiceCategory VALUES (1,'Fixture Category');
INSERT INTO Service VALUES (1,'Fixture Service A',1),(2,'Fixture Service B',1);
INSERT INTO Business VALUES
(1,'Fixture Alpha','1 Synthetic Street','Fixture City',NULL,1,'fixture_1',1,'fixture_1'),
(2,'Fixture Beta','2 Synthetic Street','Fixture City','https://example.invalid/beta',1,'fixture_2',1,'fixture_2');
INSERT INTO BusinessService VALUES
(1,1,1,'fixture_3'),(2,1,1,'fixture_4'),(2,2,1,'fixture_5');
CREATE SQL SECURITY INVOKER VIEW BusinessDirectory AS SELECT business_id,business_name,address,city,website FROM Business;
SET @selected_service_id = 2;
SET @selected_business_id = 1;
SET @minimum_providers = 1;
SELECT 'T4 Q4: expected Fixture Alpha only' AS expected;
SELECT b.business_id,b.business_name FROM Business AS b
WHERE NOT EXISTS (SELECT 1 FROM BusinessService AS bs
 WHERE bs.business_id=b.business_id AND bs.service_id=@selected_service_id)
ORDER BY b.business_name,b.business_id;
SELECT 'T4 Q5: expected A=1, B=NULL, two rows' AS expected;
SELECT s.service_id,s.service_name,bs.business_id AS matched_business_id
FROM Service AS s LEFT JOIN BusinessService AS bs
 ON bs.service_id=s.service_id AND bs.business_id=@selected_business_id
ORDER BY s.service_name,s.service_id;
SELECT 'T4 Q6: expected Fixture Alpha only' AS expected;
SELECT business_id,business_name,city FROM BusinessDirectory
WHERE website IS NULL ORDER BY business_name,business_id;
SELECT 'T4 Q3 threshold 1: expected A=2, B=1' AS expected;
SELECT s.service_id,s.service_name,COUNT(DISTINCT bs.business_id) AS provider_count
FROM Service AS s INNER JOIN BusinessService AS bs ON bs.service_id=s.service_id
GROUP BY s.service_id,s.service_name
HAVING COUNT(DISTINCT bs.business_id)>=@minimum_providers
ORDER BY provider_count DESC,s.service_name,s.service_id;
SET @minimum_providers=2;
SELECT 'T4 Q3 threshold 2: expected A=2 only' AS expected;
SELECT s.service_id,s.service_name,COUNT(DISTINCT bs.business_id) AS provider_count
FROM Service AS s INNER JOIN BusinessService AS bs ON bs.service_id=s.service_id
GROUP BY s.service_id,s.service_name
HAVING COUNT(DISTINCT bs.business_id)>=@minimum_providers
ORDER BY provider_count DESC,s.service_name,s.service_id;
-- Clean up only the separate fixture database.
DROP DATABASE p1_validation_fixture;
USE p1_local_services;
