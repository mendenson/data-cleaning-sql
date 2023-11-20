Certainly! Below is the SQL data cleaning journey transformed into a `README.md` format:

---

# SQL Data Cleaning Journey

Hey GitHub community! 👋 I wanted to share a snippet of my recent SQL adventure in cleaning up data in a xlsx file, in this project example, I used the Nashville Housing data. 🧹💼 Check out some of the cool transformations I made:

## 1. Standardizing Date Format

```sql
SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM PortfolioProject..NashvilleHousing;

-- Update and set the SaleDateConverted column
UPDATE PortfolioProject..NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate);

-- Adding a new SaleDateConverted column
ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

-- Update the new column with converted SaleDate values
UPDATE PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);
```

## 2. Populating Property Address Data

```sql
-- Update PropertyAddress where it's null
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
ON a.ParcelID = b.ParcelID AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;
```

## 3. Breaking out Address into Individual Columns (Address, City, State)

```sql
-- Adding new columns for split address
ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitAddress Nvarchar(255),
    PropertySplitCity Nvarchar(255);

-- Updating the new columns with split values
UPDATE PortfolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1),
    PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));
```

## 4. Breaking out Owner Address into Individual Columns (Address, City, Estate)

```sql
-- Adding new columns for split owner address
ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255),
    OwnerSplitCity Nvarchar(255),
    OwnerSplitEstate Nvarchar(255);

-- Updating the new columns with split values
UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
    OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    OwnerSplitEstate = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);
```

## 5. Changing 'Y' and 'N' to 'Yes' and 'No' in "Sold as Vacant" Field

```sql
-- Updating SoldAsVacant values
UPDATE PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE
                    WHEN SoldAsVacant = 'Y' THEN 'Yes'
                    WHEN SoldAsVacant = 'N' THEN 'No'
                    ELSE SoldAsVacant
                  END;
```

## 6. Removing Duplicates

```sql
-- Removing duplicates based on specified columns
WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
               ORDER BY UniqueID
           ) row_num
    FROM PortfolioProject..NashvilleHousing
)
DELETE FROM RowNumCTE
WHERE row_num > 1;
```

## 7. Deleting Unused Columns

```sql
-- Dropping unused columns
ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress;
```

Data cleanup can be fun and challenging! If you have any tips or tricks to share, feel free to comment below. Let's make our data journeys even more exciting! 🚀📊 #SQL #DataCleaning #DataTransformation #GitHubActions
