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
/*
Cleaning Data in SQL Queries
*/


Select *
From housinginfo

-- Standardize Date Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From housinginfo


Update housinginfo
SET SaleDate = CONVERT(Date,SaleDate)

-- Populate Property Address data

Select *
From housinginfo
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From housinginfo as a
JOIN housinginfo as b
	on a.ParcelID = b.ParcelID
	AND a.uniqueid != b.uniqueid
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From housinginfo as a
JOIN housinginfo as b
	on a.ParcelID = b.ParcelID
   AND a.uniqueid != b.uniqueid
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From housinginfo
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From housinginfo


ALTER TABLE housinginfo
Add PropertySplitAddress Nvarchar(255);

Update housinginfo
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE housinginfo
Add PropertySplitCity Nvarchar(255);

Update housinginfo
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From housinginfo

--owner's address

Select OwnerAddress
From housinginfo


Select
    split_part(owner_address, ',',  1) as Onwers_Address,
    split_part(owner_address, ',',  2) as Onwers_City,
    split_part(owner_address, ',',  3) as Onwers_State
From housinginfo



ALTER TABLE housinginfohousinginfo
Add OwnerSplitAddress Nvarchar(255);

Update housinginfohousinginfo
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE housinginfohousinginfo
Add OwnerSplitCity Nvarchar(255);

Update housinginfohousinginfo
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE housinginfo
Add OwnerSplitState Nvarchar(255);

Update housinginfo
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From housinginfo


-- Change Y and N to Yes and No in "Sold as Vacant" field

--To see the mismatch
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From housinginfo
Group by SoldAsVacant
order by 2

--To MOdify the mismatch
Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From housinginfo


Update housinginfo
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
      
-- Remove Duplicates

WITH Remove_Dup AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From housinginfo
--order by ParcelID
)
Select *
From Remove_Dup
Where row_num > 1
Order by PropertyAddress

Select *
From housinginfo

-- Delete Unused Columns
Select *
From housinginfo


ALTER TABLE housinginfo
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
