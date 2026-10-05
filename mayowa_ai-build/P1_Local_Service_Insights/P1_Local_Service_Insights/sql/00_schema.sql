-- Dedicated project database only. This reset deletes its previous contents.
-- Intended for MySQL 8.0+. Record SELECT VERSION() from your actual server.
DROP DATABASE IF EXISTS p1_local_services;
CREATE DATABASE p1_local_services CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE p1_local_services;
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
