Select *
From Porfolio..Nashvillehousing

--Standardize Date Format 

Select SaleDateconverted, CONVERT(Date,Saledate)
From Porfolio..Nashvillehousing

Update Nashvillehousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Nashvillehousing
Add SaleDateConverted DATE;

Update Nashvillehousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--Populate Property Address data

Select * 
From Porfolio..Nashvillehousing
--Where PropertyAddress is null 
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNUll(a.PropertyAddress, b.PropertyAddress)
From Porfolio..Nashvillehousing a
JOIN Porfolio..Nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] 
Where a.PropertyAddress is null 

Update a
SET PropertyAddress = ISNUll(a.PropertyAddress, b.PropertyAddress)
From Porfolio..Nashvillehousing a
JOIN Porfolio..Nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ] 
Where a.PropertyAddress is null 

--Putting Address into Indivdual Columns (Address, City, State)

Select * 
From Porfolio..Nashvillehousing
--Where PropertyAddress is null 
--Order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) + 1, LEN (PropertyAddress)) as Address
From Porfolio..Nashvillehousing

ALTER TABLE Nashvillehousing
Add PropertySplitAddress Nvarchar(255);

Update Nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE Nashvillehousing
Add PropertySpiltCity Nvarchar(255);

Update Nashvillehousing
SET PropertySpiltCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress) + 1, LEN (PropertyAddress)) 


Select *
From Porfolio..Nashvillehousing

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From Porfolio..Nashvillehousing

ALTER TABLE Nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

Update Nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

ALTER TABLE Nashvillehousing
Add OwnerSpiltCity Nvarchar(255);

Update Nashvillehousing
SET OwnerSpiltCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

ALTER TABLE Nashvillehousing
Add OwnerSpiltState Nvarchar(255);

Update Nashvillehousing
SET OwnerSpiltState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


Select *
From Porfolio..Nashvillehousing

-- Change the Y and N values into "Yes" and "No" 

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Porfolio..Nashvillehousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From Porfolio..Nashvillehousing

UPDATE Nashvillehousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	 When SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END


-- Removing Duplicates


With RownNumCTE As(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
		
				
From Porfolio..Nashvillehousing
--Order by ParcelID
)

Select *
from RownNumCTE
Where row_num > 1
order by PropertyAddress

-- Remove Unused Columns 

Select * 
From Porfolio..Nashvillehousing

ALTER TABLE Porfolio..Nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

Alter TABLE Porfolio..Nashvillehousing
DROP COLUMN SaleDate
