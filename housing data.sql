select * from housing_data..housing

-- standardize date format 
Select SaleDate ,convert (date,SaleDate)
from housing_data..housing

update housing_data..housing
set SaleDate= CONVERT(Date,SaleDate)

ALTER table housing_data..housing
add SaleDate_converted Date

UPDATE  housing_data..housing
set SaleDate_converted= CONVERT(Date,SaleDate)

--finding null property address data 
select *from housing_data..housing
where PropertyAddress is null
order by ParcelID

--self join table to match parcelID for propertyAddress
select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress , ISNULL (a.PropertyAddress,b.PropertyAddress)
from housing_data..housing a
join  housing_data..housing b
  on a.ParcelID=b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--populating null property address
update a
set propertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
from housing_data..housing a
join housing_data..housing b 
 on a.ParcelID =b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--breaking out address into individual columns 

select PropertyAddress
from housing_data..housing
Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
from housing_data..housing

ALTER table housing_data..housing
add PropertySplitAddress Nvarchar(225);

UPDATE  housing_data..housing
set PropertySplitAddress= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER table housing_data..housing
add PropertySplitCity Nvarchar(225);

UPDATE  housing_data..housing
set PropertySplitCity= SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select * from housing_data..housing

--updating owner address column
select OwnerAddress from housing_data..housing

select 
PARSENAME (replace(OwnerAddress,',','.'),3),
PARSENAME (replace(OwnerAddress,',','.'),2),
PARSENAME (replace(OwnerAddress,',','.'),1)
from housing_data..housing


ALTER table housing_data..housing
add OwnerSplitAddress Nvarchar(225);

UPDATE  housing_data..housing
set OwnerSplitAddress= PARSENAME (replace(OwnerAddress,',','.'),3)



ALTER table housing_data..housing
add OwnerSplitCity Nvarchar(225);

UPDATE  housing_data..housing
set OwnerSplitCity= PARSENAME (replace(OwnerAddress,',','.'),2)


ALTER table housing_data..housing
add OwnerSplitState Nvarchar(225);

UPDATE  housing_data..housing
set OwnerSplitState= PARSENAME (replace(OwnerAddress,',','.'),1)

select* from housing_data..housing


--change Y to yes and N to no in "sold as vacant" field

select Distinct(SoldASVacant),count(SoldAsVacant)
from housing_data..housing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant='Y' then 'Yes'
       when SoldAsVacant='N' then 'No'
       else SoldAsVacant
	   end
from housing_data..housing


UPDATE  housing_data..housing
set SoldAsVacant= case when SoldAsVacant='Y' then 'Yes'
       when SoldAsVacant='N' then 'No'
       else SoldAsVacant
	   end

--remove duplicates

with RowNumCTE as(
select*,
   ROW_NUMBER() over (
   partition by parcelId,
                propertyAddress,
				SalePrice,
				Saledate,
				LegalReference
				order by 
				  UniqueID
				  ) row_num
from housing_data..housing)
delete
from RowNumCTE
where row_num>1

-- delete unused columns


alter table housing_data..housing
Drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table housing_data..housing
Drop column SaleDate



















