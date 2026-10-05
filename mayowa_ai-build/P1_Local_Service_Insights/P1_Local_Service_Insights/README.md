# Local Service Insights — Project 1
CS 284 / CS 430, Fall 2026. Columbia, Missouri automotive services.
Team: Mayowa, Cailin, Nebiyu, Braiden.
The instructor has approved this four-person team.
Team name: Local Service Insights.

## Submission status
The database, source records, SQL queries, tests, report, and slides are complete.
The instructor has approved the four-person roster. The remaining deliverable is one
20-minute team video. Follow presentation/recording_script.md and upload the MP4 with
this ZIP, or provide an accessible link if the submission system allows it. Replace the
planned timestamps below with the actual recording times before submitting.

## User question and sample
Which recorded businesses offer a chosen automotive service in Columbia, and what source
supports each offering? One selected physical street location per business brand. The saved
sample has 15 businesses, 4 service types, 2 categories, 20 unique offerings, 20 source pages,
and 18 distinct publisher labels. The three independent-publisher checks compare All-Star
with AAA, Midas with Michelin, and Walt's with BBB. Publisher labels do not establish that
all provider brands have unrelated corporate owners. The sample deliberately bounds the
recorded offering set and does not describe all services available in the city.

## Software and exact build order
Validated engine: MySQL 8.0.46-0ubuntu0.24.04.3 (Ubuntu), InnoDB, FK enforcement active.
The SQL targets MySQL 8.0+. Normal rebuild requires only your MySQL client/server and the
submitted SQL files. No network, Python, live sources, CSV importer or third-party library
is necessary. Record SELECT VERSION() when demonstrating on your own server.

In MySQL Workbench, open and execute each WHOLE file in this order:
1. sql/00_schema.sql
2. sql/01_load.sql
3. sql/02_views.sql
4. sql/03_queries.sql
Then refresh Schemas and expand p1_local_services. Run tests/T1_counts_sources.sql.
00_schema.sql drops only the dedicated p1_local_services database, then rebuilds it. A second
clean run repeats all four scripts and must reproduce the same counts/results. Do not rename
the reset to any unrelated existing database. SQL explicitly aligns the session and database
UTF-8 collation. BusinessDirectory uses SQL SECURITY INVOKER.

For the mysql command-line client, start it in the unzipped project folder and run:

    SOURCE sql/00_schema.sql;
    SOURCE sql/01_load.sql;
    SOURCE sql/02_views.sql;
    SOURCE sql/03_queries.sql;
    SOURCE tests/T1_counts_sources.sql;

SOURCE is a mysql-client command, not SQL to paste into Workbench. If running each file
from a terminal instead: mysql -u YOUR_USER -p < sql/00_schema.sql, and likewise for the
remaining files in the order above. Enter your own password at the prompt, never in this ZIP.

## Tests
T1: real minimum counts/source and required-value checks. All failure counts should be 0.
T2_invalid_foreign_key.sql: run separately; expected FK rejection (normally client error 1452).
T3_duplicate_pair.sql: run separately; expected composite-PK rejection (normally 1062).
T2/T3 require the populated real snapshot. Capture the error, then run ROLLBACK separately
if the client stops before the file's final ROLLBACK. They are deliberately excluded from
the successful build sequence.
T4_fixture.sql: creates/tests/drops only p1_validation_fixture; real sample remains separate.
After T4, rerun T1 against p1_local_services. Fixture businesses are synthetic and never counted.
Individual before/after demos also passed actual MySQL (evidence/demo_checks.md).
Actual engine logs, outputs and expected/actual checks are in evidence/test_log.md and its
referenced files. This execution environment blocked sockets, so validation used real MySQL's
offline initialization SQL execution with matching SELECT exports through INTO OUTFILE.
This is disclosed in the log; no normal-client screenshots or error output were fabricated.
The normal submitted build scripts do not rely on that validation harness.

## Tables, purpose, and keys
| Table | Purpose | Primary key | Foreign keys |
|---|---|---|---|
| Source | Publisher/page URL/date/raw file locator | source_id | None |
| ServiceCategory | Meaningful category names | category_id | None |
| Service | Controlled service type | service_id | category_id → ServiceCategory |
| Business | Identity and one selected location | business_id | identity_source_id, location_source_id → Source |
| BusinessService | Source-supported business/service pair | (business_id, service_id) | business_id → Business, service_id → Service, source_id → Source |

All essential values are NOT NULL; website alone is optional. All FKs use ON DELETE RESTRICT
and ON UPDATE RESTRICT. Referenced parents/evidence cannot be removed without explicitly
handling dependents. UNIQUE business name/address/city prevents exact repeated selected
locations; manual review catches variants and extra branches. T1 checks one-or-more offerings
for each final business because ordinary child FKs do not enforce that parent inclusion rule.

## File map and evidence trace
- data/raw/observations.csv: 45 unchanged manual observations with raw IDs, wording, URLs,
  dates, and collector information.
- data/clean/sources.csv: source register and Source loading input.
- data/clean/: all five loading CSVs; 01_load.sql already contains offline INSERTs.
- data/cleaning_note.md, cleaning_examples.csv, corroboration.csv, source_reuse_notes.csv:
  rules, five real examples, duplicates/exclusions, three fact checks and rights notes.
- sql/: four ordered scripts. Query parameters are fixed to verified real values.
- tests/: T1–T4. evidence/: six output CSVs, checks, actual test log and engine exports.
- report.pdf: two main-text pages plus one complete ER-diagram page.
- presentation/slides.pdf and slides.pptx: four slides; editable deck supplied for recording.
- presentation/recording_script.md: complete 20-minute plan, actual-data explanations and
  one separate graded design/query-modification segment for each listed member.
- presentation/demo.sql: source trace and individual before/after query demonstrations.
- tools/: scripts used to assemble/classify observations, generate offline INSERTs and verify.
  Optional verify_offline_mysql.py requires --server PATH --basedir PATH and, if necessary,
  --library-path PATH; it creates fresh temporary MySQL instances and replaces evidence files.
  It is not needed for the normal four-file build.

Example offering trace: BusinessService (business 10, service 3) → source_id 10 →
Source exact Jiffy Lube location URL → data/raw/observations.csv raw_row_id O19 →
observed Tire Rotation heading. Identity and location are independently traceable via B10.
Original wording is the observation; Tire rotation and Routine maintenance are classifications.
General brand service pages support a business offering; branch availability unverified.

## Results
Q1 Auto fragment: 9 providers. Q2 Columbia/Oil change: 13 distinct providers.
Q3 threshold 2: Oil change 13; Brake service 5. Q4 Oil change not recorded: Midwest Autoworx
and GAPS Automotive. Q5 Jiffy Lube: four rows, two matches and two NULLs.
Q6 missing website: no real rows, because all 15 retained businesses have verified websites.
T4 tests missing-data behavior in a separate fixture. Details and checks: evidence/query_checks.md.

## Team responsibilities and AI disclosure
Mayowa supplied the project request and team roster. Presentation responsibilities are:

| Member | Main section | Individual explanation and query change |
|---|---|---|
| Mayowa | Model, keys, and normalization | Composite key; Q3 threshold from 1 to 2 |
| Cailin | Sources and cleaning | Category relationship; Q2 oil change to brakes |
| Nebiyu | Build and validation | Foreign key; Q1 Auto to Jiffy |
| Braiden | Query results and limitations | NULL and LEFT JOIN; Q5 business 10 to 15 |

These are assigned responsibilities. Add each member's completed reviews, corrections,
and recording work before submitting.

ChatGPT assisted with source discovery and collection, cleaning, SQL, debugging,
validation, and writing. Business and service facts were checked against original public
pages; SQL results were checked in MySQL and against the saved CSV data. Sources, raw
observations, and execution logs are included so the results can be checked. Each member
is responsible for understanding the schema and explaining their own query change.

## Planned video timestamp index
00:00–03:00 Cailin: scope, source/raw trace, cleaning decision.
03:00–07:00 Mayowa: ER model, keys, relationships and normalization.
07:00–11:00 Nebiyu: build steps, real T1 counts and intentional FK rejection.
11:00–15:00 Braiden: Q2, Q3, supported finding and limitations.
15:00–16:15 Mayowa: individual design explanation and Q3 modification.
16:15–17:30 Cailin: individual design explanation and Q2 modification.
17:30–18:45 Nebiyu: individual design explanation and Q1 modification.
18:45–20:00 Braiden: individual design explanation and Q5 modification.
Use actual recording timestamps in this index before submission. Each member must appear,
identify themselves, speak substantively, and show their own query modification results.

## Submission
P1_Local_Service_Insights.zip plus one 20-minute MP4 through Brightspace by October 6, 2026,
11:59 p.m. Central Time. Verify playback/readable SQL/audible speech, all individual segments,
and access to any link. Keep credentials and downloaded dependencies out of the submission.
