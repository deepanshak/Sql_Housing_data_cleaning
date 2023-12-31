# Sql_Housing_data_cleaning
![house-model-compass-plan-background-real-estate-concept_1423-179](https://github.com/deepanshak/Sql_Housing_data_cleaning/assets/139687677/3c558a84-b417-4a14-a19e-654af60594e4)



## Project Overview
This SQL project is designed for data cleaning tasks on a housing dataset. The script covers various operations such as standardizing date formats, handling null property addresses, performing self-joins, breaking down addresses into individual columns, updating owner address columns, changing values in the "SoldAsVacant" field, removing duplicates, and deleting unused columns.
## Data Source
The data has been imported from a secondary data source as a csv file.

## Tools Used
Ms Sql server : Data imported into the sql server then ran through various queries to get desired output
## Steps for data cleaning 
- Standardize Date Format:
The script converts the SaleDate column to a standardized date format and creates a new column called "SaleDate_converted."

- Finding Null Property Address Data:
Identifies records with null PropertyAddress and orders them by ParcelID.
<pre><code>
  select *from housing_data..housing
where PropertyAddress is null
order by ParcelID
</code>
</pre>

- Self Join to Match ParcelID for PropertyAddress:
Performs a self-join on the housing table to match ParcelID for records with null PropertyAddress.


- Populating Null Property Address:
Updates records with null PropertyAddress by filling them with non-null values from the self-joined records.
<pre><code>
  update a
set propertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
from housing_data..housing a
join housing_data..housing b 
 on a.ParcelID =b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null
</code>
</pre>


- Breaking Out Address into Individual Columns:
Splits the PropertyAddress column into separate columns for Address and City, creating new columns "PropertySplitAddress" and "PropertySplitCity."


- Updating Owner Address Column:
Parses the OwnerAddress column and updates new columns "OwnerSplitAddress," "OwnerSplitCity," and "OwnerSplitState" with the parsed values.


- Changing 'Y' to 'Yes' and 'N' to 'No' in "SoldAsVacant" Field:
Converts values in the "SoldAsVacant" column to 'Yes' or 'No.'

- Removing Duplicates:
Deletes duplicate records based on specific columns, keeping only the first occurrence.
<pre>
  <code>
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

  </code>
</pre>

- Deleting Unused Columns:
Removes columns that are deemed unnecessary for further analysis: OwnerAddress, TaxDistrict, and SaleDate.
<pre> <code>
  alter table housing_data..housing
Drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table housing_data..housing
Drop column SaleDate
</code>
  
</pre>

## Results

The updated data is more standardize and ready to be analysed.
<img width="925" alt="sql data cleaning" src="https://github.com/deepanshak/Sql_Housing_data_cleaning/assets/139687677/a8c2bc64-4d76-4102-9b76-cccdf3e25205">





<img width="533" alt="Screenshot 2023-12-28 211637" src="https://github.com/deepanshak/Sql_Housing_data_cleaning/assets/139687677/166bedf2-7888-4cc8-b294-4e469d075e48">



