--viewing the data as found in the excel file
select*
from ..nashville
order by 2

--fixing up the date format
select SaleDate, convert(date, saledate) as fixed_Sale_Date
from ..nashville

--updating the table with the fixed date format
ALTER TABLE nashville 
add fixed_Sale_Date date; 

update nashville 
set fixed_Sale_Date = convert(date, saledate)

--checking the format 
select fixed_sale_date 
from ..nashville

--checking for the added column
select*
from ..nashville

--filling null values in the 'PropertyAddress' column 
select PropertyAddress
from ..nashville
where PropertyAddress is null

--using self join to find the null values for the duplicated parcel id and adding
--a column that has the same property address for the duplicated parcel id
select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from ..nashville a 
join ..nashville b
	on a.ParcelID = b.ParcelID 
	and a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is null 

--updating the table 
Update a 
SET PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from ..nashville a 
join ..nashville b
	on a.ParcelID = b.ParcelID 
	and a.[UniqueID ] <> b.[UniqueID ] 
where a.PropertyAddress is null

--checking the updated table 
select*
from ..nashville
where PropertyAddress is null 

--splitting owner address to (address , city , state)
select 
parsename(replace(owneraddress, ',','.'),3) as OwnerSplitAddress
,parsename(replace(owneraddress, ',','.'),2) as OwnerSplitCity
,parsename(replace(owneraddress, ',','.'),1) as OwnerSplitState
from ..nashville

alter table nashville
add OwnerSplitAddress nvarchar(255);

alter table nashville
add OwnerSplitCity nvarchar(255);

alter table nashville
add OwnerSplitState nvarchar(255);

update nashville
set OwnerSplitAddress = parsename(replace(owneraddress, ',','.'),3)

update nashville
set OwnerSplitCity = parsename(replace(owneraddress, ',','.'),2) 

update nashville
set OwnerSplitState = parsename(replace(owneraddress, ',','.'),1)

--checking the updated table 
select*
from ..nashville

--splitting property address to (address , city)

select
parsename(replace(propertyaddress, ',','.'),2) as propertySplitaddress
,parsename(replace(propertyaddress, ',','.'),1) as propertySplitcity
from ..nashville


alter table nashville
add propertySplitaddress nvarchar(255); 

alter table nashville
add propertySplitcity nvarchar(255); 

update nashville
set propertySplitaddress = parsename(replace(propertyaddress, ',','.'),2)

update nashville
set propertySplitcity = parsename(replace(propertyaddress, ',','.'),1) 

--checking for updated table
select*
from ..nashville


--replacing 'y' and 'n' with 'yes' and 'no' in the 'SoldAsVacant' column 

update nashville
set SoldAsVacant = case when SoldAsVacant = 'y' then 'Yes'
						when SoldAsVacant = 'n' then 'No'
						else SoldAsVacant
						end 
								
--checking updated table 
select distinct(soldasvacant), count(soldasvacant)
from ..nashville
group by SoldAsVacant


--removing duplicates using a CTE and the ROW_NUM window function 
--firstly find the duplicates. they are the rows having a higher value than 1
--in the 'row_num' column 

with RowNumCTE as ( 
select* , ROW_NUMBER() over (
		partition by parcelid,
					 propertyaddress,
					 saleprice,
					 saledate,
					 legalreference
					 order by
					 uniqueid
					 ) row_num 

from ..nashville
)
--deleting the duplicate rows
DELETE
from RowNumCTE
where row_num > 1

--deleting unused columns 

alter table ..nashville 
drop column saledate










