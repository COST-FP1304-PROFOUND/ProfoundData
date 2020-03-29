\dontrun{
  
# For downloading the data, use 
dbfile <- downloadDatabase(location = tempdir())

# Set the connection using the setDB function
setDB(dbfile)

# check if database is available
getDB()
}
