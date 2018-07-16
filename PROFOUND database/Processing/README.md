This folder contains are scripts for processing the data that will be included in the DB.
It also contains files / information needed to solve open issues and structure the DB

# Scripts

#### Scripts that create the .RData that should be fed to the DB

These scripts should gather the datas and ensure that data has corrected units.


- tree_data.R
- climate_data.R
- soil_data.R



#### Scripts that create into the DB.

These scripts:

- check that input data has the required variables
- create the SQL table
- write the data into the SQL table

Scripts:

- Tree_to_DB.R
- Soil_to_DB.R
- ISIMIP_to_DB.R
- Climate_to_DB.R
- FLUX_to_DB.R
- Create_View_DB.R

All is run by:

- Create_DB.R

# Files

+ Flux_Level_4_Lenkalist.txt

    The list of variables to be included in the DB after Lenka

+ Flux_Level_4_variables_DB.txt

    The list of available variables resulting from combinbing Level 3 or Level 4. 
    Currently, all these variables are part of the DB.
    It is noted the origin of the variable and whether it is part of Lenka's list.

