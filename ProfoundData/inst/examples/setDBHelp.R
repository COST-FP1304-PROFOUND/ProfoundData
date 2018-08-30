\dontrun{
# Define the path to the database. It must be an absolute path.
myDB <- "/home/ownCloud/PROFOUND_Data/v0.1.13/ProfoundData.sqlite"
myDB <- path.expand("~/ownCloud/PROFOUND_Data/v0.1.13/ProfoundData.sqlite")

# Set the connection using the setDB function
setDB(myDB)
}
