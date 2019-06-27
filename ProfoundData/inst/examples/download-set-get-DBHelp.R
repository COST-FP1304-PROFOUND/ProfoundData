\dontrun{
  
# For downloading the data, use 
downloadDatabase()
# The function will query you to ask about the path to store the databse
  
# Define the path to the database. 
myDB <- "/home/ownCloud/PROFOUND_Data/v0.1.13/ProfoundData.sqlite"
# myDB must be an absolute paths, so you should expand relative paths
myDB <- path.expand("~/ownCloud/PROFOUND_Data/v0.1.13/ProfoundData.sqlite")

# Set the connection using the setDB function
setDB(myDB)

# check if database is available
getDB()
}
