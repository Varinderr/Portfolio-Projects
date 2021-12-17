#Create TABLE

create table housinginfo(
   UniqueID INT NOT NULL AUTO_INCREMENT,
   ParcelID VARCHAR(100) NOT NULL,
   LandUse VARCHAR(40) NOT NULL,
   PropertyAddress VARCHAR(40) NOT NULL,
   SaleDate DATE,
   SalePrice INT NOT NULL,
   LegalRefrence VARCHAR(40) NOT NULL,
   SoldasVacant VARCHAR(40) NOT NULL,
   OwnerName VARCHAR(40) NOT NULL,
   OwnerAddress VARCHAR(40) NOT NULL,
   Acreage INT NOT NULL,
   TaxDistrict VARCHAR(40) NOT NULL,
   landValue INT NOT NULL,
   BuildingValue INT NOT NULL,
   TotalValue INT NOT NULL,
   YearBuild INT NOT NULL,
   Bedrooms INT NOT NULL,
   FullBath INT NOT NULL,
   HalfBath INT NOT NULL,
   PRIMARY KEY ( UniqueID)
);

#Load data

LOAD DATA INFILE 'Nashville_Housing.csv'
INTO TABLE housinginfo
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS

#popunate Property Address using parcel_id

-- select a.parcel_id, a.property_address, b.parcel_id, b.property_address, isnull(a.property_address, b.property_address)
--     from housinginfo as a JOIN housinginfo as b
--     ON a.parcel_id = b.parcel_id and a.unique_id_ != b.unique_id_
--     where a.property_address is null
    
update a
    set property_address = isnull(a.property_address, b.property_address)
    from Final as a JOIN Final as b
    ON a.parcel_id = b.parcel_id and a.unique_id_ != b.unique_id_
    where a.property_address is null
    
#breaking down the address:
select 
substring(property_address,1,charindex(',', property_address) - 1) as Address,
substring(property_address,charindex(',', property_address) + 1) as City
    from Final

#breaking owner's address:
with owneraddressinfo as (
    select unique_id_ as unique_id_3,
    parcel_id as parcel_id3,
    split_part(owner_address, ',',  1) as Onwers_Address,
    split_part(owner_address, ',',  2) as Onwers_City,
    split_part(owner_address, ',',  3) as Onwers_State
    from Final)
    
select * from owneraddressinfo
