\dontrun{
# Basic querz
overview <- queryDB("SELECT * FROM OVERVIEW")
tree <- queryDB("SELECT * FROM TREE")

# Site name or site_id
myQuery <- queryDB("SELECT date, tmax_degC FROM CLIMATE_LOCAL WHERE site == 'hyytiala'")
myQuery <- queryDB("SELECT date, tmax_degC FROM CLIMATE_LOCAL_12")

# Tree species
myQuery <- queryDB("SELECT  * FROM TREE WHERE species == 'Picea abies'")
myQuery <- queryDB("SELECT  * FROM TREE_piab")

# Specify variables
myQuery <- queryDB("SELECT date, tmax_degC FROM CLIMATE_LOCAL WHERE
                   tmax_degC > 20 AND site == 'hyytiala' AND year == 2010")



}
