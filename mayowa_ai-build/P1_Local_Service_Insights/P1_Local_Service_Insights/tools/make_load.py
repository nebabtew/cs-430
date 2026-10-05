"""Generate offline 01_load.sql from verified CSVs; standard-library Python only.
Run from any folder: python tools/make_load.py (path adjusted as needed).
Do not modify raw observations. Generator never downloads anything.
"""
import csv
from datetime import date
from pathlib import Path
BASE = Path(__file__).resolve().parents[1]
SPECS = [
 ('sources.csv','Source',['source_id']),
 ('categories.csv','ServiceCategory',['category_id']),
 ('services.csv','Service',['service_id','category_id']),
 ('businesses.csv','Business',['business_id','identity_source_id','location_source_id']),
 ('offerings.csv','BusinessService',['business_id','service_id','source_id'])]
def read(path):
 with path.open(encoding='utf-8-sig',newline='') as f:return list(csv.DictReader(f))
def require(ok,msg):
 if not ok:raise ValueError(msg)
def quote(value):
 # Hex text literals avoid dependence on SQL backslash modes/quote escaping.
 return "CONVERT(X'%s' USING utf8mb4)" % value.encode('utf-8').hex()
def main():
 data={table:read(BASE/'data/clean'/filename) for filename,table,_ in SPECS}
 for filename,table,integer_fields in SPECS:
  require(data[table],f'{filename} has no rows; collect real data first.')
  for row in data[table]:
   require(None not in row and all(v is not None for v in row.values()),f'Malformed CSV row in {filename}')
   for field,value in row.items():
    require(value.strip() or (table=='Business' and field=='website'),f'Blank required {table}.{field}')
   for field in integer_fields:
    require(int(row[field])>0,f'{table}.{field} must be a positive integer')
   if table=='Source':date.fromisoformat(row['collection_date'])
 def keyed(table,fields):
  keys=[tuple(int(row[f]) for f in fields) for row in data[table]]
  require(len(keys)==len(set(keys)),f'Duplicate key in {table}')
  return set(keys)
 sourceids=keyed('Source',['source_id']);catids=keyed('ServiceCategory',['category_id'])
 serviceids=keyed('Service',['service_id']);businessids=keyed('Business',['business_id'])
 keyed('BusinessService',['business_id','service_id'])
 for row in data['Service']:require((int(row['category_id']),) in catids,'Unknown service category')
 for row in data['Business']:
  for field in ['identity_source_id','location_source_id']:
   require((int(row[field]),) in sourceids,'Unknown business source')
 for row in data['BusinessService']:
  require((int(row['business_id']),) in businessids,'Unknown offering business')
  require((int(row['service_id']),) in serviceids,'Unknown offering service')
  require((int(row['source_id']),) in sourceids,'Unknown offering source')
 require(len(businessids)>=15,'Need at least 15 distinct businesses')
 require(len(serviceids)>=4,'Need at least 4 services')
 require(len(catids)>=2,'Need at least 2 categories')
 require(len(data['BusinessService'])>=20,'Need at least 20 offerings')
 require(len({row['publisher'].strip().casefold() for row in data['Source']})>=2,'Need at least two publishers; also check organizational independence manually')
 offered={int(row['business_id']) for row in data['BusinessService']}
 require(offered=={k[0] for k in businessids},'Every business needs at least one offering')
 raw=read(BASE/'data/raw/observations.csv')
 rawids=[row['raw_row_id'] for row in raw]
 require(len(rawids)==len(set(rawids)),'Raw-row IDs must be unique')
 rawmap={row['raw_row_id']:row for row in raw}
 sourcemap={row['source_id']:row for row in data['Source']}
 refs=[]
 for row in data['Business']:
  refs.extend([(row['identity_raw_row_id'],row['identity_source_id']), (row['location_raw_row_id'],row['location_source_id'])])
 refs.extend((row['raw_row_id'],row['source_id']) for row in data['BusinessService'])
 for rawid,sourceid in refs:
  require(rawid in rawmap,f'Missing raw row {rawid}')
  require(rawmap[rawid]['source_id']==sourceid,f'Source/raw mismatch for {rawid}')
  require(rawmap[rawid]['source_url']==sourcemap[sourceid]['url'],f'URL mismatch for {rawid}')
  require(sourcemap[sourceid]['raw_file_path']=='data/raw/observations.csv','This generator expects the supplied manual raw CSV locator; adapt it if using multiple original files')
 lines=['-- Generated from the submitted cleaned CSVs. Real sources require manual verification.',
        'USE p1_local_services;','SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;','SET SESSION FOREIGN_KEY_CHECKS = 1;','START TRANSACTION;']
 for filename,table,integer_fields in SPECS:
  columns=list(data[table][0])
  for row in data[table]:
   values=[]
   for col in columns:
    if col in integer_fields:values.append(str(int(row[col])))
    elif table=='Business' and col=='website' and not row[col].strip():values.append('NULL')
    else:values.append(quote(row[col]))
   lines.append('INSERT INTO `%s` (%s) VALUES (%s);' % (table,', '.join('`'+c+'`' for c in columns),', '.join(values)))
 lines.append('COMMIT;')
 (BASE/'sql/01_load.sql').write_text('\n'.join(lines)+'\n',encoding='utf-8')
 print('Created sql/01_load.sql; no data were downloaded. Verify facts, then build in MySQL.')
if __name__=='__main__':main()
