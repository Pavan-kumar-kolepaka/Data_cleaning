--DATA CLEANING


--STANDARDISE DATE FORMAT

select SaleDateConverted, CONVERT(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)




--POPULATE PROPERTY ADDRESS DATA


select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing  a
join PortfolioProject.dbo.NashvilleHousing  b
   on a.ParcelID = b.ParcelID 
   AND a.[uniqueID] <> b.[uniqueID] 
where a.PropertyAddress is  null 

UPDATE a 
SET propertyaddress =ISNULL(a.PropertyAddress,b.PropertyAddress) 
from PortfolioProject.dbo.NashvilleHousing  a
join PortfolioProject.dbo.NashvilleHousing  b
   on a.ParcelID = b.ParcelID 
   AND a.[uniqueID] <> b.[uniqueID] 
where a.PropertyAddress is  null 

select *
from PortfolioProject.dbo.NashvilleHousing

--BREAKING OUT INDIVIDUAL COLUMNS (ADDRESS,CITY,) BY USING SUBSTRING 

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress))



--BREAKING OUT INDIVIDUAL COLUMNS (ADDRESS,CITY,STATE) BY USING PARSNAME


select *
from PortfolioProject.dbo.NashvilleHousing


select 
PARSENAME(REPLACE(OwnerAddress,',', '.'),3),
PARSENAME(REPLACE(OwnerAddress,',', '.'),2),
PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
from PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing 
SET OwnerSplitAddress =  PARSENAME(REPLACE(OwnerAddress,',', '.'),3)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing 
SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress,',', '.'),2)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing 
SET OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress,',', '.'),1)



-- Change Y and N to Yes and No in "Sold as Vacant" field



Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant,
CASE when SoldAsVacant = 'y' then 'yes'
     when SoldAsVacant = 'N' then 'NO'
	 ELSE SoldAsVacant 
	 END
From PortfolioProject.dbo.NashvilleHousing


UPDATE PortfolioProject.dbo.NashvilleHousing 
SET SoldAsVacant = CASE when SoldAsVacant = 'y' then 'yes'
     when SoldAsVacant = 'N' then 'NO'
	 ELSE SoldAsVacant 
	 END


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

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing


-- Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

















