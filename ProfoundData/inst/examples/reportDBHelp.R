# example requires that a sql DB is registered via setDB(dbfile)
# when run without a registered DB, you will get a file query (depending on OS)

\dontrun{
# Create the database report and specify the output directory
reportDB(outDir = "/home/mine/database/")
  
# Create the database report without specify the output directory
reportDB()
}
