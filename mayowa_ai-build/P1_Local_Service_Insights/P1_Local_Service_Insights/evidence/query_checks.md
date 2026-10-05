# Six query outputs and checks

Parameters: Q1 name fragment Auto; Q2/Q4 service ID 1 (Oil change); Q2 city Columbia; Q3 minimum providers 2; Q5 business ID 10 (Jiffy Lube). Q6 has no parameter.

Q1: PASS. Auto fragment matches IDs [1, 2, 4, 5, 6, 8, 11, 14, 15] (9 rows). Checked against saved business names.

Q2: PASS. Columbia/Oil change matches IDs [2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 15] (13 unique providers). Complete set matches cleaned offerings; O02 traces Tom oil to source 2 and raw saved observation.

Q3: PASS. Manual provider counts from offerings.csv are {1: 13, 2: 5, 3: 1, 4: 1}; threshold 2 returns Oil change=13 and Brake service=5.

Q4: PASS. Oil change not recorded for IDs [1, 8]: Midwest Autoworx and GAPS Automotive. Set equals all 15 businesses minus the 13 oil providers.

Q5: PASS. Jiffy Lube (ID 10) has four service rows: Oil change and Tire rotation match 10; Brake service and Wheel alignment are NULL. Count equals all four Service rows.

Q6: PASS. Zero rows. All 15 real business website cells contain verified URLs; missing-website behavior passes in T4.

Outputs: Q1.csv through Q6.csv. NULL in Q5.csv denotes SQL NULL, not an offering. Absence is not proof a business lacks a service. Business offering; branch availability unverified when sources cover multiple locations.
