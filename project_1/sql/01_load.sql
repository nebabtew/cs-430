USE cs430_project1;

-- Sources: the numbers identify the pages used as evidence.
INSERT INTO Source (source_id, publisher, page_title, url, collection_date, raw_file_path)
VALUES
    (1, 'St. Louis Auto & Truck Repair', 'Oil Change in St Louis, MO', 'https://www.saintlouisauto.com/services/oil-change', '2026-10-05', 'data/raw/observations_2026-10-05.csv'),
    (2, 'St. Louis Auto & Truck Repair', 'Brake Repair and Service in St Louis, MO', 'https://www.saintlouisauto.com/services/brakes', '2026-10-05', 'data/raw/observations_2026-10-05.csv'),
    (3, 'AutoMax of St. Louis', 'Services - AutoMax of St. Louis', 'https://www.automaxstl.com/services/', '2026-10-05', 'data/raw/observations_2026-10-05.csv'),
    (4, 'Car-X Tire & Auto', 'Car-X Tire & Auto - St. Louis', 'https://www.carxstlouis.com/', '2026-10-05', 'data/raw/observations_2026-10-05.csv'),
    (5, 'Meineke', 'Auto Repair & Mechanic Shop in St. Louis, MO #30', 'https://www.meineke.com/locations/mo/st-louis-30/', '2026-10-05', 'data/raw/observations_2026-10-05.csv'),
    (6, 'Fit City Gym', 'Contact Our Gyms', 'https://fitcitystl.com/contact-our-gyms-in-st-peters-and-st-louis/', '2026-10-05', 'data/raw/observations_2026-10-05.csv'),
    (7, 'Club Fitness', 'Hampton', 'https://www.clubfitness.us/location/hampton/', '2026-10-05', 'data/raw/observations_2026-10-05.csv'),
    (8, 'The L.A.B. Gym', 'Personal Training', 'https://labgym.com/programs/personal-training/', '2026-10-05', 'data/raw/observations_2026-10-05.csv'),
    (9, 'The L.A.B. Gym', 'Group Training', 'https://labgym.com/programs/group-training/', '2026-10-05', 'data/raw/observations_2026-10-05.csv'),
    (10, 'Fit City Gym', 'Locations', 'https://fitcitystl.com/locations/', '2026-10-05', 'data/raw/observations_2026-10-05.csv'),
    (11, 'Fit City Gym', 'About Our Gyms', 'https://fitcitystl.com/about-our-gyms-in-st-louis-and-st-peters/', '2026-10-05', 'data/raw/observations_2026-10-05.csv');

-- Categories: automotive and fitness/wellness.
INSERT INTO ServiceCategory (category_id, name)
VALUES
    (1, 'Automotive services'),
    (2, 'Fitness and wellness services');

-- Businesses: one selected location per business.
INSERT INTO Business (business_id, name, address, city, website, source_id, raw_row_id)
VALUES
    (1, 'St. Louis Auto & Truck Repair', '2701 Delmar Boulevard, St. Louis, MO 63103', 'St. Louis', 'https://www.saintlouisauto.com/', 1, 'R001'),
    (2, 'AutoMax of St. Louis', '9525 Saint Charles Rock Rd, Saint Louis, MO 63114', 'St. Louis', 'https://www.automaxstl.com/', 3, 'R003'),
    (3, 'Car-X Tire & Auto - St. Louis', '3460 S Kingshighway, St. Louis, MO 63109', 'St. Louis', 'https://www.carxstlouis.com/', 4, 'R005'),
    (4, 'Meineke - Shop #30', '4426 South Kingshighway, St. Louis, MO 63109-2425', 'St. Louis', 'https://www.meineke.com/', 5, 'R007'),
    (5, 'Fit City Gym', '1601 S Jefferson Ave, St. Louis, MO 63104', 'St. Louis', 'https://fitcitystl.com/', 6, 'R009'),
    (6, 'Club Fitness - Hampton', '12 Hampton Village, St. Louis, MO 63109', 'St. Louis', 'https://www.clubfitness.us/', 7, 'R013'),
    (7, 'The L.A.B. Gym', '3738 Chouteau Ave, St. Louis, MO 63110', 'St. Louis', 'https://labgym.com/', 8, 'R015');

-- Services: reuse these IDs when multiple businesses offer the same service.
INSERT INTO Service (service_id, service_name, category_id)
VALUES
    (1, 'Oil change', 1),
    (2, 'Brake repair', 1),
    (3, 'Tire rotation', 1),
    (4, 'Wheel alignment', 1),
    (5, 'Gym access', 2),
    (6, 'Tanning', 2),
    (7, 'Sauna access', 2),
    (8, 'Personal training', 2),
    (9, 'Group exercise classes', 2);

-- Offerings: connect each business to a service and its supporting observation.
INSERT INTO BusinessService (business_id, service_id, source_id, raw_row_id)
VALUES
    (1, 1, 1, 'R001'),
    (1, 2, 2, 'R002'),
    (2, 1, 3, 'R003'),
    (2, 3, 3, 'R004'),
    (3, 2, 4, 'R005'),
    (3, 4, 4, 'R006'),
    (4, 1, 5, 'R007'),
    (4, 3, 5, 'R008'),
    (5, 5, 10, 'R010'),
    (5, 6, 11, 'R011'),
    (5, 7, 11, 'R012'),
    (6, 8, 7, 'R013'),
    (6, 9, 7, 'R014'),
    (7, 8, 8, 'R015'),
    (7, 9, 9, 'R016');

INSERT INTO Source (source_id, publisher, page_title, url, collection_date, raw_file_path)
VALUES
    (12, 'Hoffman Plumbing', 'Hoffman Plumbing St Louis - Serving You Since 1949', 'https://www.hoffmanplbg.com/', '2026-10-05', 'data/raw/additional_observations_2026-10-05.csv'),
    (13, 'Mercy', 'Mercy Hospital St. Louis', 'https://www.mercy.net/practice/mercy-hospital-st-louis/', '2026-10-05', 'data/raw/additional_observations_2026-10-05.csv'),
    (14, 'Affinia Healthcare', 'Locations - Affinia Healthcare', 'https://affiniahealthcare.org/locations/', '2026-10-05', 'data/raw/additional_observations_2026-10-05.csv'),
    (15, 'ArchWell Health', 'North Kingshighway', 'https://archwellhealth.com/locations/north-kingshighway/', '2026-10-05', 'data/raw/additional_observations_2026-10-05.csv'),
    (16, 'BJC Health', 'Missouri Baptist Medical Center', 'https://www.bjc.org/locations/missouri-baptist-medical-center', '2026-10-05', 'data/raw/additional_observations_2026-10-05.csv'),
    (17, 'Wolfgang''s Pet Stop', 'Best Grooming St Louis | Wolfgang''s Pet Stop', 'https://www.wolfgangspetstop.com/', '2026-10-05', 'data/raw/additional_observations_2026-10-05.csv'),
    (18, 'C & C Quality Printing', 'Home - Printing, Signs, Shirts, Design', 'https://printingstl.com/', '2026-10-05', 'data/raw/additional_observations_2026-10-05.csv'),
    (19, 'Landscape St. Louis', 'Landscape Design & Maintenance | Landscape St. Louis', 'https://landscapestlouis.com/', '2026-10-05', 'data/raw/additional_observations_2026-10-05.csv'),
    (20, 'Landscape St. Louis', 'Garden Maintenance Services St. Louis', 'https://landscapestlouis.com/garden-maintenance-program/garden-maintenance/', '2026-10-05', 'data/raw/additional_observations_2026-10-05.csv'),
    (21, 'Bradford White', 'HOFFMAN PLUMBING - Contractor Finder', 'https://contractorfinder.bradfordwhite.com/contractors/hoffman-plumbing-387-saint-louis-mo', '2026-10-05', 'data/raw/additional_observations_2026-10-05.csv');

INSERT INTO ServiceCategory (category_id, name)
VALUES
    (3, 'Plumbing services'),
    (4, 'Healthcare services'),
    (5, 'Pet services'),
    (6, 'Printing services'),
    (7, 'Landscaping services');

INSERT INTO Business (business_id, name, address, city, website, source_id, raw_row_id)
VALUES
    (8, 'Hoffman Plumbing', '2619 Salena St, St. Louis, MO 63118', 'St. Louis', 'https://www.hoffmanplbg.com/', 21, 'R044'),
    (9, 'Mercy Hospital St. Louis', '615 S New Ballas Rd, St. Louis, MO 63141', 'St. Louis', 'https://www.mercy.net/practice/mercy-hospital-st-louis/', 13, 'R017'),
    (10, 'Affinia Healthcare', '1717 Biddle St, St. Louis, MO 63106', 'St. Louis', 'https://affiniahealthcare.org/', 14, 'R020'),
    (11, 'ArchWell Health', '1315 Aubert Ave, St. Louis, MO 63113', 'St. Louis', 'https://archwellhealth.com/locations/north-kingshighway/', 15, 'R023'),
    (12, 'Missouri Baptist Medical Center', '3015 N. Ballas Road, St. Louis, MO 63131', 'St. Louis', 'https://www.bjc.org/locations/missouri-baptist-medical-center', 16, 'R029'),
    (13, 'Wolfgang''s Pet Stop', '3419 Papin St., St. Louis, MO 63103', 'St. Louis', 'https://www.wolfgangspetstop.com/', 17, 'R032'),
    (14, 'C & C Quality Printing', '4636 Gravois Road, St. Louis, MO 63116', 'St. Louis', 'https://printingstl.com/', 18, 'R035'),
    (15, 'Landscape St. Louis', '2601 McCausland Ave, St. Louis, MO 63143', 'St. Louis', 'https://landscapestlouis.com/', 19, 'R039');

INSERT INTO Service (service_id, service_name, category_id)
VALUES
    (10, 'Water heater installation', 3),
    (11, 'Water heater service', 3),
    (12, 'Drain cleaning', 3),
    (13, 'Emergency care', 4),
    (14, 'Burn care', 4),
    (15, 'Stroke care', 4),
    (16, 'Health outreach', 4),
    (17, 'Laboratory services', 4),
    (18, 'Dental care', 4),
    (19, 'Primary care', 4),
    (20, 'Cardiology telehealth', 4),
    (21, 'Care management', 4),
    (22, 'Vaccinations', 4),
    (23, 'Preventive health screenings', 4),
    (24, 'Cancer care', 4),
    (25, 'Heart and vascular care', 4),
    (26, 'Neurosciences', 4),
    (27, 'Dog grooming', 5),
    (28, 'Dog daycare', 5),
    (29, 'Dog training classes', 5),
    (30, 'Commercial printing', 6),
    (31, 'Custom signs', 6),
    (32, 'Apparel printing', 6),
    (33, 'Embroidery', 6),
    (34, 'Landscape design and build', 7),
    (35, 'Garden maintenance', 7);

INSERT INTO BusinessService (business_id, service_id, source_id, raw_row_id)
VALUES
    (8, 10, 12, 'R41'),
    (8, 11, 12, 'R42'),
    (8, 12, 12, 'R43'),
    (9, 13, 13, 'R017'),
    (9, 14, 13, 'R018'),
    (9, 15, 13, 'R019'),
    (10, 16, 14, 'R020'),
    (10, 17, 14, 'R021'),
    (10, 18, 14, 'R022'),
    (11, 17, 15, 'R025'),
    (11, 19, 15, 'R023'),
    (11, 20, 15, 'R024'),
    (11, 21, 15, 'R026'),
    (11, 22, 15, 'R027'),
    (11, 23, 15, 'R028'),
    (12, 24, 16, 'R029'),
    (12, 25, 16, 'R030'),
    (12, 26, 16, 'R031'),
    (13, 27, 17, 'R032'),
    (13, 28, 17, 'R033'),
    (13, 29, 17, 'R034'),
    (14, 30, 18, 'R035'),
    (14, 31, 18, 'R036'),
    (14, 32, 18, 'R037'),
    (14, 33, 18, 'R038'),
    (15, 34, 19, 'R039'),
    (15, 35, 20, 'R040');
