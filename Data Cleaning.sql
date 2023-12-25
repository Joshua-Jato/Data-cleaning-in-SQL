/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[NashvilleHousing]

  select *
  from [PortfolioProject].[dbo].[NashvilleHousing]


--Standardise Date Format

Select SaleDateConverted
 from [PortfolioProject].[dbo].[NashvilleHousing]

 alter table NashvilleHousing
 add saleDateConverted date;

 update NashvilleHousing
 Set saledateconverted = CONVERT(date, SaleDate)
 



 --populate property address

 Select *
 from [PortfolioProject].[dbo].[NashvilleHousing] a
 join [PortfolioProject].[dbo].[NashvilleHousing] b
      on a.ParcelID = b.ParcelID
	  and a. [UniqueID ] <> b.[UniqueID ]


--Breaking out Address into individual column (Address, City, State)

select PropertyAddress
from [PortfolioProject].[dbo].[NashvilleHousing]

select
substring (PropertyAddress, 1, CHARINDEX( ',', propertyaddress) -1) as Address,
substring (PropertyAddress, CHARINDEX( ',', propertyaddress) +1, LEN (propertyaddress)) as Address
from [PortfolioProject].[dbo].[NashvilleHousing]

 alter table NashvilleHousing
 add PropertySplitAddress nvarchar (255)

 update NashvilleHousing
 set PropertySplitAddress = substring (PropertyAddress, 1, CHARINDEX( ',', propertyaddress) -1) 


 alter table NashvilleHousing
 add PropertySplitCity nvarchar (255)

update NashvilleHousing
set PropertySplitCity = substring (PropertyAddress, CHARINDEX( ',', propertyaddress) +1, LEN (propertyaddress))

select OwnerAddress
from [PortfolioProject].[dbo].[NashvilleHousing]



--alternative way of breaking out address into single column

select 
parsename (replace(owneraddress, ',', '.'), 3) as Address,
parsename (replace(owneraddress, ',', '.'), 2) as City,
parsename (replace(owneraddress, ',', '.'), 1) as State
from [PortfolioProject].[dbo].[NashvilleHousing]

select *
from [PortfolioProject].[dbo].[NashvilleHousing]

Alter table NashvilleHousing
add OwnerSplitAddress nvarchar (255)

update NashvilleHousing
set OwnerSplitAddress = parsename (replace(owneraddress, ',', '.'), 3)

Alter table NashvilleHousing
add OwnerSplitCity nvarchar (255)

update NashvilleHousing
set OwnerSplitCity = parsename (replace(owneraddress, ',', '.'), 2)

Alter table NashvilleHousing
add OwnerSplitState nvarchar (255)

update NashvilleHousing
set OwnerSplitState = parsename (replace(owneraddress, ',', '.'), 1)


--Remove Duplicate 

with Row_NumCTE as
(
select *, ROW_NUMBER () over (partition by
							parcelid,
							propertyaddress,
							saleprice,
							saledate,
							legalreference
							order by uniqueid) row_num
from [PortfolioProject].[dbo].[NashvilleHousing]
													)

delete
from Row_NumCTE
where row_num > 1




--Change Y and N to Yes and No respectively in 'Sold As Vacant' field

select SoldAsVacant,
case
    when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else soldasvacant end
from [PortfolioProject].[dbo].[NashvilleHousing]

update NashvilleHousing
set SoldAsVacant = case
    when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else soldasvacant end

	select distinct SoldAsVacant, count(SoldAsVacant)
	from [PortfolioProject].[dbo].[NashvilleHousing]
	group by SoldAsVacant
	order by 2 desc

--Delete unused colums

alter table [PortfolioProject].[dbo].[NashvilleHousing]
drop column owneraddress, taxdistrict, propertyaddress

alter table [PortfolioProject].[dbo].[NashvilleHousing]
drop column saledate, convertedsaledate





