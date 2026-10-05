# Team recording script — 20 minutes
Team: Mayowa, Cailin, Nebiyu, Braiden. The instructor has approved this four-person roster.
Each member will explain a design choice and show a query change during their individual segment.

Use these notes to prepare, then explain the ideas in your own words. Keep SQL and results
large enough to read. Each person should appear on camera and introduce themselves.

## Before recording
Unzip and build the four SQL files on your MySQL server. Have report.pdf page 3, the four
slides, raw observations.csv, all six queries, T1, T2 and demo.sql already open. Test microphone
and camera. Keep the actual FK error separate from the successful build. After the expected
error issue ROLLBACK. Use one continuous recording or join separate segments into one MP4.

## 00:00–03:00 Cailin — purpose and evidence
Introduce yourself and the project. Suggested narration:
“We built a database for students and residents looking for automotive services in Columbia,
Missouri. The saved sample has 15 different businesses, four services, two categories and 20
recorded business-service pairs. We kept one physical location per business, so additional
branches do not increase the count. The observations file includes the original service
wording and source URLs, so each offering can be traced back to its evidence.”

Run the first SELECT in demo.sql. Open raw O19 and B10 in observations.csv.
“Here is Jiffy Lube's recorded tire rotation offering. The offering references source 10 and
raw row O19. Source 10 contains the exact Jiffy Lube location URL and the saved file locator.
The original heading was Tire Rotation. We classified it as Tire rotation within Routine
maintenance. The heading is an observed fact; the category is our classification.”

Show cleaning_examples.csv and cleaning_note.md.
“We standardized 7 North 1st Street to 7 N 1st St without changing the location. Oil & Filter
Change maps to Oil change. We did not invent a missing service to satisfy a count. For Tom's,
a general list mentions alignment but the FAQ denies offering it, so we excluded that pair.
Provider-confirmed rebrands let us merge Custom Complete into Dobbs and Mutrux into Norris.
We cross-checked three selected addresses using AAA, Michelin and BBB.”

## 03:00–07:00 Mayowa — model and normalization
Introduce yourself. Show report page 3 and slide 2. Explain each table's purpose.
“Business stores identity and one selected location. ServiceCategory stores two category
names. Service stores each controlled service and exactly one required category ID. Source
stores the cited page and its publisher, URL, collection date and raw-file locator.
BusinessService connects businesses to services. This gives us one-to-many category/service
modeling and many-to-many business/service modeling without storing a repeating list.”

Explain every key. “The offering primary key is business_id and service_id together. Neither
alone is unique because a business can offer several services and a service can have several
providers. Source foreign keys preserve the evidence connection. Identity and location can
use the same page or different pages. Required fields are NOT NULL; an unknown website
would be NULL. RESTRICT prevents deleting referenced evidence or parent records accidentally.
The final sample also requires every business to have an offering; T1 checks that condition.”

Explain the combined relation and dependencies from report page 2.
“In a combined business-service row, the business ID determines the name and selected address,
the service ID determines its name and category, and the category ID determines its name.
The business/service pair determines the chosen offering evidence. A source ID determines
its page metadata. We separated those facts into five 3NF tables. An address now changes in
one Business row instead of many offering rows, avoiding an update anomaly. Foreign-key
joins reconnect the facts. These rules apply to the deduplicated offering relation; the raw
capture can keep several observations for one business.”

## 07:00–11:00 Nebiyu — execution and validation
Introduce yourself. Show the actual MySQL server version and the four required scripts.
“Build order is schema, load, view, queries. The reset only affects p1_local_services. The
submitted INSERT snapshot makes the build work offline. Our validation ran in real MySQL
8.0.46 using offline initialization because the preparation environment blocked sockets.
Today I am demonstrating these normal client scripts in our Workbench connection.”
Say the last sentence only if you actually use Workbench. Show tables/view and run T1.
“Counts are 15 businesses, four services, two categories, 20 distinct offerings and 18 publisher
labels. All source/parent/required-value failure counts are zero. The publisher count does
not alone prove independence; our three corroborations document separate publishers.
Two clean builds produced identical table data and query outputs.”

Run T2 separately and show the actual FK error. “This attempted offering references a business
ID that does not exist. The foreign key rejects it, which is the expected behavior. This is an
intentional test, not a failed real build.” Roll back, then show that T1 real counts still agree.
Briefly show T3 rejection evidence and T4 output. Explain Alpha/Beta, NULL website, absent B,
manual A=2/B=1 counts, and that the fixture is isolated and removed.

## 11:00–15:00 Braiden — actual SQL and findings
Introduce yourself. Execute Q2 with Columbia and service ID 1 (Oil change).
“The inner joins connect a business to its offering, service definition and source. The city
and selected service filters narrow the rows. Thirteen recorded businesses match. Every row
has a source URL and raw-row ID, and the composite offering key prevents a repeated pair.
We count providers only within this collected sample. A general business page does not prove
that every branch has the service, so branch availability can remain unverified.”

Execute Q3 with threshold 2. “GROUP BY forms one group per service. COUNT DISTINCT counts
each business once. HAVING retains groups with at least two providers. Oil change has 13
and Brake service has five. Tire rotation and Wheel alignment each have one recorded provider,
so they do not pass this threshold. These are bounded collection counts, not citywide service
coverage or evidence of unmet demand.”

Discuss Q4/Q5/Q6 briefly. “Oil change is not recorded for Midwest Autoworx and GAPS. That
does not prove they do not offer it. Q5 keeps all four service rows because its business filter
is in ON. Q6 returns no rows because all retained businesses have verified websites; T4
checks the missing-website behavior separately. A useful follow-up is whether collecting a
complete service inventory for each provider changes this recorded distribution.”

## 15:00–16:15 Mayowa — individual segment
Appear and identify yourself. Explain the composite key in your own words, including why
business_id alone and service_id alone are insufficient and why duplicate pairs inflate results.
Run both Mayowa Q3 SELECTs in demo.sql. Threshold 1 returns four services with counts
13, 5, 1, 1. Threshold 2 returns only Oil change 13 and Brake service 5. Explain that the
new HAVING threshold removes both one-provider service groups and leaves counts unchanged.

## 16:15–17:30 Cailin — individual segment
Appear and identify yourself. Explain the Service.category_id FK and exactly-one category
per service, with several services per category. Run both Cailin Q2 SELECTs. Oil returns 13;
brakes returns five: Midwest Autoworx, Tom's, All-Star, GAPS, Midas. City stays Columbia.
Explain that changing the service condition changes the matched offering/provider set and
associated evidence rows, rather than changing the underlying data.

## 17:30–18:45 Nebiyu — individual segment
Appear and identify yourself. Explain why BusinessService.business_id must reference an
existing Business and relate it to T2. Run the two Q1 SELECTs. Auto matches nine names;
Jiffy matches only Jiffy Lube. Explain LIKE and the surrounding % wildcards. Stable ordering
uses name and business ID as a tie-breaker. Replacing the fragment changes the predicate,
not any stored name.

## 18:45–20:00 Braiden — individual segment
Appear and identify yourself. Explain website NULL and LEFT JOIN's unmatched row behavior.
Run the two Q5 SELECTs. Jiffy matches Oil change and Tire rotation; Dobbs matches Oil change
and Wheel alignment. Both have four output rows. Brake service remains NULL for both in
this bounded snapshot. Explain why the filter is in ON: placing bs.business_id in WHERE
would remove unmatched NULL rows and fail to list every service.

## After recording
Check duration, camera appearances, names, sound and readable SQL. Update README with the
ACTUAL timestamps and actual completed student contributions. Upload one combined MP4
alongside P1_Local_Service_Insights.zip, or use an instructor-accessible link if required.
No website, app, paid API, advanced feature or extra query portfolio is needed.
