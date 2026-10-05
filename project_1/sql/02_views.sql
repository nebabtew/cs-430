-- Run after 00_schema.sql and 01_load.sql.
USE cs430_project1;

CREATE VIEW BusinessDirectory AS
SELECT business_id, name, address, city, website
FROM Business;
