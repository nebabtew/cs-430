USE cs430_project1;

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

INSERT INTO ServiceCategory (category_id, name)
VALUES
    (1, 'Automotive services'),
    (2, 'Fitness and wellness services');

INSERT INTO Business (business_id, name, address, city, website, source_id, raw_row_id)
VALUES
    (1, 'St. Louis Auto & Truck Repair', '2701 Delmar Boulevard, St. Louis, MO 63103', 'St. Louis', 'https://www.saintlouisauto.com/', 1, 'R001'),
    (2, 'AutoMax of St. Louis', '9525 Saint Charles Rock Rd, Saint Louis, MO 63114', 'St. Louis', 'https://www.automaxstl.com/', 3, 'R003'),
    (3, 'Car-X Tire & Auto - St. Louis', '3460 S Kingshighway, St. Louis, MO 63109', 'St. Louis', 'https://www.carxstlouis.com/', 4, 'R005'),
    (4, 'Meineke - Shop #30', '4426 South Kingshighway, St. Louis, MO 63109-2425', 'St. Louis', 'https://www.meineke.com/', 5, 'R007'),
    (5, 'Fit City Gym', '1601 S Jefferson Ave, St. Louis, MO 63104', 'St. Louis', 'https://fitcitystl.com/', 6, 'R009'),
    (6, 'Club Fitness - Hampton', '12 Hampton Village, St. Louis, MO 63109', 'St. Louis', 'https://www.clubfitness.us/', 7, 'R013'),
    (7, 'The L.A.B. Gym', '3738 Chouteau Ave, St. Louis, MO 63110', 'St. Louis', 'https://labgym.com/', 8, 'R015');

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

