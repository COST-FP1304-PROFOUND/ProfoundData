# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)
# create index
db <- dbConnect(SQLite(), dbname=myDB)
if ( "TREESPECIES" %in% dbListTables(db)){
  dbSendQuery(db, "DROP VIEW TREESPECIES")}

# --> change names to include the table
dbGetQuery(db, "CREATE VIEW TREESPECIES AS
           SELECT TREESPECIES_master.species_id,
           TREESPECIES_master.species
           FROM TREESPECIES_master"
)

## Close connnection to db
dbDisconnect(db)



db <- dbConnect(SQLite(), dbname=myDB)
if ( "TREE" %in% dbListTables(db)){
  dbSendQuery(db, "DROP VIEW TREE")}

# --> change names to include the table
dbGetQuery(db, "CREATE VIEW TREE AS
           SELECT TREE_master.record_id,
           SITESID_master.site,
           TREE_master.site_id,
           TREE_master.year,
           PLOTSIZE_master.size_m2,
           TREESPECIES_master.species,
           TREE_master.species_id,
           TREE_master.dbh1_cm,
           TREE_master.height1_m
           FROM TREE_master INNER JOIN SITESID_master ON TREE_master.site_id = SITESID_master.site_id 
           INNER JOIN TREESPECIES_master ON TREE_master.species_id = TREESPECIES_master.species_id
           INNER JOIN PLOTSIZE_master ON TREE_master.site_id = PLOTSIZE_master.site_id AND  TREE_master.year = PLOTSIZE_master.year"
)

## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM TREE_master)")

for (i in 1:length(ids[,1])){
  if ( paste("TREE_", ids[i,], sep ="") %in% dbListTables(db)){
    dbSendQuery(db, paste("DROP VIEW TREE_", ids[i,], sep =""))}
  dbGetQuery(db, paste("CREATE VIEW TREE_", ids[i,], " AS ",
                       "SELECT TREE_master.record_id, ",
                       "SITESID_master.site, ",
                       "TREE_master.site_id, ",
                       "TREE_master.year, ",
                       "PLOTSIZE_master.size_m2, ",                       
                       "TREESPECIES_master.species, ",
                       "TREE_master.species_id, ",
                       "TREE_master.dbh1_cm, ",
                       "TREE_master.height1_m ",
                       "FROM TREE_master INNER JOIN SITESID_master ON TREE_master.site_id = SITESID_master.site_id ", 
                       "INNER JOIN TREESPECIES_master ON TREE_master.species_id = TREESPECIES_master.species_id ",
                       "INNER JOIN PLOTSIZE_master ON TREE_master.site_id = PLOTSIZE_master.site_id AND  TREE_master.year = PLOTSIZE_master.year ",
                       "WHERE TREE_master.site_id = '", ids[i,], "'",
                       sep = "")
  )
}
## Close connnection to db
dbDisconnect(db)


db <- dbConnect(SQLite(), dbname=myDB)
spp <- dbGetQuery(db, "SELECT species_id FROM (SELECT DISTINCT species_id FROM TREE_master)")

for (i in 1:length(spp[,1])){
  if ( paste("TREE_",spp[i,], sep ="") %in% dbListTables(db)){
    dbSendQuery(db, paste("DROP VIEW TREE_", spp[i,], sep =""))}
  dbGetQuery(db, paste("CREATE VIEW TREE_", spp[i,], " AS ",
                       "SELECT TREE_master.record_id, ",
                       "SITESID_master.site, ",
                       "TREE_master.site_id, ",
                       "TREE_master.year, ",
                       "PLOTSIZE_master.size_m2, ",                       
                       "TREESPECIES_master.species, ",
                       "TREE_master.species_id, ",
                       "TREE_master.dbh1_cm, ",
                       "TREE_master.height1_m ",
                       "FROM TREE_master INNER JOIN SITESID_master ON TREE_master.site_id = SITESID_master.site_id ", 
                       "INNER JOIN TREESPECIES_master ON TREE_master.species_id = TREESPECIES_master.species_id ",
                       "INNER JOIN PLOTSIZE_master ON TREE_master.site_id = PLOTSIZE_master.site_id AND  TREE_master.year = PLOTSIZE_master.year ",
                       "WHERE TREE_master.species_id = '", spp[i,], "'", sep = "")
  )
}
## Close connnection to db
dbDisconnect(db)

db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM TREE_master)")

for (i in 1:length(ids[,1])){
  spp <- dbGetQuery(db, paste("SELECT species_id FROM (SELECT DISTINCT species_id FROM TREE_master WHERE site_id ='",
                              ids[i,],  "')", sep = ""))
  for (j in 1:length(spp[,1])){
    if ( paste("TREE_",spp[j,],"_", ids[i,],   sep ="") %in% dbListTables(db)){
      dbSendQuery(db, paste("DROP VIEW TREE_", spp[j,],"_", ids[i,], sep =""))}
    dbGetQuery(db, paste("CREATE VIEW TREE_",spp[j,],"_", ids[i,], " AS ",
                         "SELECT TREE_master.record_id, ",
                         "SITESID_master.site, ",
                         "TREE_master.site_id, ",
                         "TREE_master.year, ",
                         "PLOTSIZE_master.size_m2, ",                         
                         "TREESPECIES_master.species, ",
                         "TREE_master.species_id, ",
                         "TREE_master.dbh1_cm, ",
                         "TREE_master.height1_m ",
                         "FROM TREE_master INNER JOIN SITESID_master ON TREE_master.site_id = SITESID_master.site_id ", 
                         "INNER JOIN TREESPECIES_master ON TREE_master.species_id = TREESPECIES_master.species_id ",
                         "INNER JOIN PLOTSIZE_master ON TREE_master.site_id = PLOTSIZE_master.site_id AND  TREE_master.year = PLOTSIZE_master.year ",
                         "WHERE TREE_master.site_id ='",ids[i,], "' AND TREE_master.species_id = '", spp[j,], "'",
                         sep = "")
    )
  }
}
## Close connnection to db
dbDisconnect(db)



