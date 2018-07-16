library(ProfoundData)
myDB <- "/home/ramiro/ownCloud/PROFOUND_Data/v0.1.13/ProfoundData.sqlite"
setDB(myDB)

outDir <-"/home/ramiro/ownCloud/PROFOUND_Data/exportASCII"

# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)

# Check the table
tables <- dbListTables(db) # The tables in the database
tables <- tables[grepl("_master", tables)]
# The fields in the table
## Close connnection to db
dbDisconnect(db)
  
prefix <- "SELECT * FROM"
for (i in 1:length(tables)){
  db <- dbConnect(SQLite(), dbname= myDB)
  dummy <- dbGetQuery(db, paste(prefix,tables[i], sep= " "))
  dbDisconnect(db)
  write.table(dummy, file.path(outDir, tables[i]), row.names = F, sep = "\t")
  rm(dummy)
}
