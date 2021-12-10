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
