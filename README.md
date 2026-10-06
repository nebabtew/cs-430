# Local Service Insights

CS 284 / CS 430 database project for organizing source-supported local service
businesses and their offerings.

## Team

| Member | GitHub username | Responsibilities |
|---|---|---|
| Nebiyu Habtemariam | `Nebabtew` | Project coordination, database schema and relationships, build instructions, and final integration |
| Braiden Elsea | `Belsea05` | Source collection, data cleaning and normalization, corroboration notes, and evidence review |
| Mayowa Esan | `esanpelumi` | SQL loading and queries, validation tests, results interpretation, and presentation/report review |
| Cailin Ewing | `cewing` | ER diagram and normalization, documentation, presentation planning, and final quality review |

Responsibilities are shared: each teammate should review the complete database,
verify the SQL results, and be prepared to explain the work during the presentation.

## Project overview

The database records businesses, service categories, services, source pages, and
source-supported business/service offerings. The finalized sample contains:

- 15 businesses
- 35 controlled service types
- 7 service categories
- 42 business/service offerings

The project preserves raw observations, cleaning decisions, source
corroboration, SQL scripts, tests, query outputs, and presentation materials.

## Final submission

The complete packaged submission is in
[`mayowa_ai-build/P1_Local_Service_Insights/P1_Local_Service_Insights/`](mayowa_ai-build/P1_Local_Service_Insights/P1_Local_Service_Insights/).
Its README contains the detailed scope, schema, evidence trace, results, and
submission instructions.

Important files:

- [`README.md`](mayowa_ai-build/P1_Local_Service_Insights/P1_Local_Service_Insights/README.md):
  detailed project documentation
- [`sql/00_schema.sql`](mayowa_ai-build/P1_Local_Service_Insights/P1_Local_Service_Insights/sql/00_schema.sql):
  database and table definitions
- [`sql/01_load.sql`](mayowa_ai-build/P1_Local_Service_Insights/P1_Local_Service_Insights/sql/01_load.sql):
  source, business, category, service, and offering data
- [`sql/02_views.sql`](mayowa_ai-build/P1_Local_Service_Insights/P1_Local_Service_Insights/sql/02_views.sql):
  database views
- [`sql/03_queries.sql`](mayowa_ai-build/P1_Local_Service_Insights/P1_Local_Service_Insights/sql/03_queries.sql):
  required project queries
- [`tests/`](mayowa_ai-build/P1_Local_Service_Insights/P1_Local_Service_Insights/tests/):
  validation scripts
- [`evidence/`](mayowa_ai-build/P1_Local_Service_Insights/P1_Local_Service_Insights/evidence/):
  query outputs, test logs, and verification notes
- [`presentation/`](mayowa_ai-build/P1_Local_Service_Insights/P1_Local_Service_Insights/presentation/):
  slides, recording script, and demonstration SQL

## Build order

The finalized submission targets MySQL 8.0+. From the packaged project
directory, execute the files in this order:

1. `sql/00_schema.sql`
2. `sql/01_load.sql`
3. `sql/02_views.sql`
4. `sql/03_queries.sql`

The schema script resets only the dedicated project database. Run the test
scripts separately as described in the packaged README; the foreign-key and
duplicate-key tests intentionally produce errors.

## AI disclosure

AI assistance was used for source discovery, data cleaning support, SQL
development, debugging, validation, and documentation. The team reviewed the
source records, SQL, test evidence, and final results.
