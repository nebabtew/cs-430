from pathlib import Path
import csv, shutil
r=Path(__file__).resolve().parents[1]
r.mkdir(exist_ok=True)
for name in ['data/raw','data/clean','evidence','presentation']:(r/name).mkdir(parents=True,exist_ok=True)
def csvwrite(path,fields,rows):
 with (r/path).open('w',newline='',encoding='utf-8') as f:
  d=csv.DictWriter(f,fieldnames=fields);d.writeheader();d.writerows(rows)
specs=[
(1,'Midwest Autoworx','Our Services','https://www.midwestautoworx.com/services'),
(2,"Tom's Auto & Imports",'Auto Services','https://www.tomsauto.net/'),
(3,'Columbia Car Care and Fleet Specialties','Services We Offer','https://www.automobilerepaircolumbia.net/'),
(4,'All-Star Automotive','All-Star Automotive West','https://www.allstarcolumbia.com/all-star-automotive-west'),
(5,'A to Z Auto Repair','Vehicle Repairs, Maintenance, and Inspections','https://www.atozautorepaircolumbia.com/'),
(6,'Automotive Specialist','Get Directions','https://www.automotivespecialistmo.com/get-directions/'),
(7,'Automotive Specialist','Services','https://automotivespecialistmo.net/services/'),
(8,'GAPS Automotive','Brake Service','https://gapsautomotiveinc.com/brake-service-repair/'),
(9,'Midas','MIDAS COLUMBIA','https://www.midas.com/store/mo/columbia/1201-business-loop-70-east-65201?shopnum=5750'),
(10,'Jiffy Lube','W Worley St','https://www.jiffylube.com/locations/mo/columbia/1113'),
(11,'Firestone Complete Auto Care','Columbia, MO - 703 Business Loop 70 W','https://www.firestonecompleteautocare.com/missouri/columbia/703-business-loop-70-w/'),
(12,'Big O Tires','Big O Tires - Columbia, MO','https://www.bigotires.com/location/mo/columbia/2300-business-loop-70-e-65201/025001'),
(13,"Walt's Service Inc.",'Quick Lube Services in Columbia','https://www.waltsserviceinc.net/Columbia-quick-lube-services.html'),
(14,'Norris Full Service Automotive LLC','Our Services','https://norrisfullserviceauto.com/services/'),
(15,'Dobbs Tire & Auto Centers','Columbia Downtown','https://www.gotodobbs.com/locations/providence-rd-columbia/'),
(16,'Dobbs Tire & Auto Centers','Complete Auto Service','https://www.gotodobbs.com/auto-service/'),
(17,'Plaza Tire Service','Plaza Tire Service Columbia','https://www.plazatireservice.com/locations/mo/columbia/auto-repair-419-e-broadway'),
(18,'AAA','All Star Automotive','https://www.aaa.com/autorepair/shop/all-star-automotive-110735'),
(19,'Michelin North America','MIDAS','https://www.michelinman.com/auto/dealer-locator/columbia/yglglhv-midas'),
(20,'Better Business Bureau',"Walt's Service Inc",'https://www.bbb.org/us/mo/columbia/profile/auto-repair/walts-service-inc-0734-110204473')]
sources=[dict(source_id=i,publisher=p,title=t,url=u,collection_date='2026-10-04',raw_file_path='data/raw/observations.csv') for i,p,t,u in specs]
csvwrite('data/clean/sources.csv',list(sources[0]),sources)
source={i:row for i,row in zip([x[0] for x in specs],sources)}
# id, cleaned name, address, identity/location source id, observed name, observed address
business_spec=[
(1,'Midwest Autoworx','2001 Rangeline St',1,'Midwest Autoworx','2001 Rangeline St'),
(2,"Tom's Auto & Imports",'1200 Coats Street',2,"Tom’s Auto & Imports",'1200 Coats Street'),
(3,'Columbia Car Care and Fleet Specialties','900 Old 63 North',3,'Columbia Car Care and Fleet Specialties','900 Old 63 North'),
(4,'All-Star Automotive','7 N 1st St',4,'All-Star Automotive West','7 North 1st Street'),
(5,'A to Z Auto Repair','1001 Business Loop 70 East',5,'A to Z Auto Repair','1001 Business Loop 70 East'),
(6,'Automotive Specialist','1201 Old 63 N',6,'Automotive Specialist','1201 Old 63 N'),
(7,'Plaza Tire Service','419 E Broadway',17,'Plaza Tire Service Columbia','419 E Broadway'),
(8,'GAPS Automotive','1909 Vandiver Dr',8,'GAPS Automotive','1909 Vandiver Dr'),
(9,'Midas','1201 Business Loop 70 East',9,'MIDAS COLUMBIA','1201 Business Loop 70 East'),
(10,'Jiffy Lube','2107 W Worley St',10,'Jiffy Lube','2107 W Worley St'),
(11,'Firestone Complete Auto Care','703 Business Loop 70 W',11,'Firestone Complete Auto Care','703 Business Loop 70 W'),
(12,'Big O Tires','2300 Business Loop 70 E',12,'Big O Tires - Columbia, MO','2300 Business Loop 70 E'),
(13,"Walt's Service Inc.",'1204 N College Ave',13,"Walt's Service Inc.",'1204 N College Ave'),
(14,'Norris Full Service Automotive LLC','2100 West Rollins Rd',14,'Norris Full Service Automotive LLC','2100 West Rollins Rd'),
(15,'Dobbs Tire & Auto Centers','215 S Providence Rd',15,'Dobbs Tire & Auto Centers','215 S. Providence Rd.')]
raw=[]
def observe(rawid,bid,sid,wording='',name=None,address=None,city='Columbia',kind='identity_location',note=''):
 b=next(x for x in business_spec if x[0]==bid)
 raw.append(dict(raw_row_id=rawid,business_name_observed=name or b[4],address_observed=address or b[5],city_observed=city,service_wording_observed=wording,source_id=sid,source_url=source[sid]['url'],collection_date='2026-10-04',collector='ChatGPT (AI-assisted collection)',observation_kind=kind,observation_note=note))
businesses=[]
for bid,name,address,sid,observed_name,observed_address in business_spec:
 rawid=f'B{bid:02d}'
 observe(rawid,bid,sid)
 businesses.append(dict(business_id=bid,business_name=name,address=address,city='Columbia',website=source[sid]['url'],identity_source_id=sid,identity_raw_row_id=rawid,location_source_id=sid,location_raw_row_id=rawid))
csvwrite('data/clean/businesses.csv',list(businesses[0]),businesses)
categories=[dict(category_id=1,category_name='Routine maintenance'),dict(category_id=2,category_name='Repair and adjustment')]
services=[dict(service_id=1,service_name='Oil change',category_id=1),dict(service_id=2,service_name='Brake service',category_id=2),dict(service_id=3,service_name='Tire rotation',category_id=1),dict(service_id=4,service_name='Wheel alignment',category_id=2)]
csvwrite('data/clean/categories.csv',list(categories[0]),categories)
csvwrite('data/clean/services.csv',list(services[0]),services)
# Twenty intentionally bounded offerings, not an exhaustive service inventory.
off_spec=[(1,2,1,'Brake service'),(2,1,2,'Oil Changes'),(3,1,3,'Oil Change'),(4,1,4,'Oil Changes & Preventative Maintenance'),(5,1,5,'Oil Changes'),(6,1,7,'Oil Change'),(7,1,17,'Oil Change'),(8,2,8,'Brake Service'),(9,1,9,'oil change'),(10,1,10,'Oil Change'),(11,1,11,'Oil & Filter Change'),(12,1,12,'Oil Change, Lube and Filters'),(13,1,13,'Oil Changes'),(14,1,14,'Oil & Filter Service'),(15,1,16,'Oil Changes'),(2,2,2,'Brake Service'),(4,2,4,'Brake Repair & Replacement'),(9,2,9,'brake repair'),(10,3,10,'Tire Rotation'),(15,4,16,'Alignments')]
offerings=[]
for i,(bid,serviceid,sourceid,wording) in enumerate(off_spec,1):
 rawid=f'O{i:02d}'
 note='Business offering; branch availability unverified.' if bid in (5,6,8,12,15) else 'Provider page supports a business offering; appointments and current availability require confirmation.'
 # A service-only source does not support an address; keep that raw field unknown.
 location_known=sourceid in (1,2,3,4,5,8,9,10,11,12,13,14,17)
 observe(rawid,bid,sourceid,wording,kind='offering',note=note)
 if not location_known:raw[-1]['address_observed']=''
 offerings.append(dict(business_id=bid,service_id=serviceid,source_id=sourceid,raw_row_id=rawid))
csvwrite('data/clean/offerings.csv',list(offerings[0]),offerings)
corrobs=[]
for rawid,bid,sid,observed_name,address,val1,val2,first in [
('C01',4,18,'All Star Automotive','7 N 1st Street','7 North 1st Street, Columbia, MO 65203','7 N 1st Street, Columbia, MO 65203',4),
('C02',9,19,'MIDAS','1201 BUSINESS LOOP 70 E','1201 Business Loop 70 East, Columbia, MO 65201','1201 BUSINESS LOOP 70 E, COLUMBIA, Missouri - 65201',9),
('C03',13,20,"Walt's Service Inc",'1204 N College Ave','1204 N College Ave, Columbia, MO 65201','1204 N College Ave, Columbia, MO 65201-4759',13)]:
 observe(rawid,bid,sid,name=observed_name,address=address,kind='corroboration',note='Selected street address and city agree after direction/street abbreviation normalization. Publisher is organizationally separate from provider; no copied upstream citation is identified on the cited listing. Independent field measurement is not claimed.')
 corrobs.append(dict(business_id=bid,fact_checked='Selected street address and city',source_1_url=source[first]['url'],publisher_1=source[first]['publisher'],source_2_url=source[sid]['url'],publisher_2=source[sid]['publisher'],value_1=val1,value_2=val2,agreement_or_resolution='Same street location/city after abbreviation normalization. ZIP+4 differs in format only where present.',raw_row_1=f'B{bid:02d}',raw_row_2=rawid))
csvwrite('data/corroboration.csv',list(corrobs[0]),corrobs)
observe('E01',15,15,name='Custom Complete Automotive',kind='legacy_alias',note='Provider explicitly reports rebranding to Dobbs. Merge into business 15, not an additional business.')
observe('E02',14,14,name='Mutrux Auto',kind='legacy_alias',note='Provider explicitly reports ownership/name change to Norris. Merge into business 14.')
observe('E03',2,2,'Wheel Alignments',kind='conflicting_offering',note='General service list mentions alignment, but FAQ explicitly denies currently offering alignment. Excluded.')
observe('E04',2,2,'do not offer wheel alignment services',kind='conflicting_offering',note='Specific FAQ contradicts general service list; do not load a Tom wheel-alignment offering.')
observe('E05',4,4,address='7 N 1st St',kind='duplicate_identity',note='Same selected address repeated in footer with abbreviated wording. Do not create another business.')
observe('E06',4,4,name='All-Star Automotive East',address='222 North 9th Street',kind='excluded_branch',note='Additional branch of business 4. Excluded from business count and location scope.')
observe('E07',5,5,address='806 FAY ST',kind='excluded_branch',note='Additional branch of business 5. Selected location is Business Loop; Fay Street is excluded.')
csvwrite('data/raw/observations.csv',list(raw[0]),raw)
examples=[
 dict(raw_row_id='B04',field='address',before='7 North 1st Street',after='7 N 1st St',rule='R1 text and location standardization',reason='North/Street abbreviations identify the same verified selected location.'),
 dict(raw_row_id='O11',field='service_wording',before='Oil & Filter Change',after='Oil change',rule='R2 controlled service classification',reason='Explicit oil/filter change is included in the Oil change type.'),
 dict(raw_row_id='O17',field='service_wording',before='Brake Repair & Replacement',after='Brake service',rule='R2 controlled service classification',reason='Explicit repair/replacement supports the Brake service type.'),
 dict(raw_row_id='E01',field='business identity',before='Custom Complete Automotive',after='Dobbs Tire & Auto Centers (business_id 15)',rule='R1 identity consolidation',reason='Current provider explicitly confirms rebranding; old name does not add a business.'),
 dict(raw_row_id='E02',field='business identity',before='Mutrux Auto',after='Norris Full Service Automotive LLC (business_id 14)',rule='R1 identity consolidation',reason='Current provider explicitly confirms ownership/name change.')]
csvwrite('data/cleaning_examples.csv',list(examples[0]),examples)
notes=[]
for s in sources:
 note='Public factual listing. No open-data reuse license is asserted. Only short service labels and factual identity/location observations are included; page content and images are not reproduced.'
 if s['source_id']==5:note+=' Provider states content belongs to it/licensors and prohibits copying without consent.'
 elif s['source_id']==20:note+=' BBB states profiles do not guarantee third-party accuracy and do not endorse providers.'
 else:note+=' Copyright/terms or rights notices appear on the cited provider/directory pages.'
 notes.append(dict(source_id=s['source_id'],published_attribution_or_reuse_notes=note))
csvwrite('data/source_reuse_notes.csv',list(notes[0]),notes)
query=(r/'sql/03_queries.sql').read_text().replace('REPLACE_WITH_REAL_FRAGMENT','Auto').replace('REPLACE_WITH_REAL_CITY','Columbia')
query=query.replace('-- Replace these values with values in YOUR verified snapshot.','-- Parameters fixed for the submitted Columbia snapshot.').replace('SET @selected_business_id = 1;','SET @selected_business_id = 10;')
(r/'sql/03_queries.sql').write_text(query)
# Adapt existing generator because raw manual capture has additional audit columns (supported).
(r/'data/cleaning_note.md').write_text('''# Collection, cleaning, and corroboration\n\nSnapshot accessed October 4, 2026 (America/Chicago). Collector: ChatGPT, acting as an AI assistant for the team. Public provider pages were opened, not inferred from search snippets. Short factual manual observations are preserved unchanged in data/raw/observations.csv. The source register and raw observations preserve the evidence for each classification.\n\n## Scope and counts\nThe intended user is a student or resident seeking routine automotive maintenance or brake/adjustment services in Columbia, Missouri. Include only a verifiable business identity, a physical Columbia street location, and at least one explicit offering. Keep one selected location per distinct business brand. This is a convenience sample and a bounded offering sample, not an exhaustive local directory.\n\n45 raw observation rows were collected: 15 primary identity/location rows (B01-B15), 20 offering rows (O01-O20), 3 independent-publisher address checks (C01-C03), and 7 review/exclusion rows (E01-E07). Final data: 15 businesses, 4 services, 2 categories, 20 unique business/service pairs, 20 cited pages and 18 distinct publisher names. The three external directory publishers are AAA, Michelin North America, and Better Business Bureau. Distinct provider brand labels are not a claim that all providers have unrelated corporate owners. The independent-publisher minimum is supported by the provider/directory pairs in the corroboration register, regardless of shared corporate ownership among other brands.\n\n## Two rules\nR1: Standardize identity/location wording and merge records confirmed to describe the same business. Preserve the original name/address. Use North/N and Street/St consistently where the selected street location is unchanged. Use the current provider-confirmed name after a rebrand. Do not infer identity just from similar names.\nR2: Map explicit observed service wording to four controlled service types. Oil/filter/lube headings map to Oil change; brake repair/replacement/service headings map to Brake service; Tire Rotation maps to Tire rotation; Alignments maps to Wheel alignment. Ambiguous tire services alone do not establish tire rotation. Conflicting claims are excluded rather than guessed.\n\nFive actual before/after examples, including the required three, are in data/cleaning_examples.csv. Raw captures remain unchanged. Trim is a routine implementation detail, not a manufactured cleaning example.\n\n## Duplicate handling and exclusions\nE01 confirms that Custom Complete Automotive is now Dobbs. E02 confirms Mutrux Auto is now Norris. Neither old alias is counted as an additional business. E05 repeats the same All-Star selected location in its footer, so one Business row remains. E06 (All-Star East) and E07 (A to Z Fay Street) are additional branches; they do not add businesses. The raw records represent 17 encountered location records for the 15 retained brands, of which two branches are excluded.\nE03/E04 preserve Tom's conflicting alignment claims. A generic service list mentions Wheel Alignments, but the specific FAQ says it does not offer wheel alignment services. No alignment pair is loaded for Tom. The affirmative oil and brake claims are retained. The 20 retained pairs were deliberately bounded; other affirmative services on the pages were outside this collected offering sample and are not counted.\n\n## Three corroborations\nC01 checks All-Star's 7 N 1st Street address against its own West page and AAA. C02 checks Midas's 1201 Business Loop 70 East address against its own location page and Michelin. C03 checks Walt's 1204 N College Ave address against its own service page and BBB. Each external publisher is organizationally separate from the provider, with no explicit shared-upstream citation identified in the opened record. These are cross-publisher corroborations, not a claim of independent on-site measurement. Direction abbreviations/case and Walt's ZIP+4 format differ without changing the street location. Values, raw IDs, and both exact URLs appear in data/corroboration.csv. Phone numbers/hours were not modeled, so differing directory values for those fields were not treated as verified project facts.\n\n## Evidence and reuse\nSource IDs resolve to data/clean/sources.csv and MySQL Source. All sources locate saved manual observations in data/raw/observations.csv. Original service labels are observations; the controlled name and category are our database classifications. A Source FK validates the parent record, while tools/make_load.py validates raw ID/source/URL consistency. The captured wording is manually checked against the opened pages.\nProvider pages sometimes describe the brand or multiple locations, especially Dobbs's general service page, Automotive Specialist's services page, A to Z, GAPS and Big O's caveat. Interpret these as business offerings; branch availability unverified. Contact a provider before relying on an appointment or current service. All 15 retained businesses have a verified website, so Q6 returns no rows for the real sample. Synthetic missing websites appear only in T4's isolated database.\nPublished rights/attribution notes are recorded in data/source_reuse_notes.csv. Full copyrighted pages, logos, reviews, prices and images are not copied into this package. Source facts reflect the accessible pages at collection, and no live website is needed for rebuilding the database.\n''')
print('Final data collected:',len(businesses),'businesses,',len(offerings),'offerings,',len(raw),'raw observations,',len(sources),'sources,',len({x['publisher'] for x in sources}),'publisher labels')
