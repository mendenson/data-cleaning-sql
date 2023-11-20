/* 

Cleaning Data in SQL Queries

*/

Select*
From PortifolioProject..NashvilleHousing

----------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select saleDateConverted, CONVERT(Date,SaleDate)
From PortifolioProject..NashvilleHousing

Update PortifolioProject..NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update PortifolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

----------------------------------------------------------------------------------------------------------------------------

-- Populate Property Addres data

Select PropertyAddress
From PortifolioProject..NashvilleHousing 
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortifolioProject..NashvilleHousing a
JOIN PortifolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortifolioProject..NashvilleHousing a
JOIN PortifolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


----------------------------------------------------------------------------------------------------------------------------

--Breaking out address into Individual columns (Address, City, State)

Select PropertyAddress
From PortifolioProject..NashvilleHousing 

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address
From PortifolioProject..NashvilleHousing

ALTER TABLE PortifolioProject..NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortifolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE PortifolioProject..NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortifolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

Select *
From PortifolioProject..NashvilleHousing 

Select OwnerAddress
From PortifolioProject..NashvilleHousing 

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PortifolioProject..NashvilleHousing 

ALTER TABLE PortifolioProject..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortifolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE PortifolioProject..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortifolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE PortifolioProject..NashvilleHousing
Add OwnerSplitEstate Nvarchar(255);

Update PortifolioProject..NashvilleHousing
SET OwnerSplitEstate = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select *
From PortifolioProject..NashvilleHousing 


----------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldASVacant)
From PortifolioProject..NashvilleHousing 
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, Case When SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
	END
From PortifolioProject..NashvilleHousing 

Update PortifolioProject..NashvilleHousing
SET SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant = 'N' then 'No'
	ELSE SoldAsVacant
	END


----------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
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

From PortifolioProject..NashvilleHousing 
--order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1



----------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From PortifolioProject..NashvilleHousing

ALTER TABLE PortifolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

