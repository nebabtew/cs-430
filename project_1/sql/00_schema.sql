-- Run once against an empty project database. Assign IDs when inserting data.
-- Default deletion rule: remove referencing rows before referenced rows.

CREATE DATABASE IF NOT EXISTS cs430_project1;
USE cs430_project1;

CREATE TABLE Source (
    source_id INT PRIMARY KEY,
    publisher VARCHAR(255) NOT NULL,
    page_title VARCHAR(255) NOT NULL,
    url VARCHAR(2048) NOT NULL,
    collection_date DATE NOT NULL,
    raw_file_path VARCHAR(512) NOT NULL
);

CREATE TABLE ServiceCategory (
    category_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Business (
    business_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    website VARCHAR(2048),
    source_id INT NOT NULL,
    raw_row_id VARCHAR(100) NOT NULL,
    FOREIGN KEY (source_id) REFERENCES Source(source_id)
);

CREATE TABLE Service (
    service_id INT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES ServiceCategory(category_id)
);

CREATE TABLE BusinessService (
    business_id INT NOT NULL,
    service_id INT NOT NULL,
    source_id INT NOT NULL,
    raw_row_id VARCHAR(100) NOT NULL,
    PRIMARY KEY (business_id, service_id),
    FOREIGN KEY (business_id) REFERENCES Business(business_id),
    FOREIGN KEY (service_id) REFERENCES Service(service_id),
    FOREIGN KEY (source_id) REFERENCES Source(source_id)
);
