# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)


# create index
db <- dbConnect(SQLite(), dbname=myDB)
if ( "STAND" %in% dbListTables(db)){
  dbSendQuery(db, "DROP VIEW STAND")}
# --> change names to include the table
dbGetQuery(db, "CREATE VIEW STAND AS
           SELECT STAND_master.record_id,
           SITESID_master.site,
           STAND_master.site_id,
           STAND_master.year, 
           TREESPECIES_master.species, 
           STAND_master.species_id, 
           STAND_master.age, 
           STAND_master.dbhArith_cm, 
           STAND_master.dbhBA_cm, 
           STAND_master.dbhDQ_cm, 
           STAND_master.heightArith_m, 
           STAND_master.heightBA_m, 
           STAND_master.ba_m2ha, 
           STAND_master.density_treeha, 
           STAND_master.aboveGroundBiomass_kgha,
           STAND_master.foliageBiomass_kgha,
           STAND_master.branchesBiomass_kgha,
           STAND_master.stemBiomass_kgha, 
           STAND_master.rootBiomass_kgha, 
           STAND_master.stumpCoarseRootBiomass_kgha, 
           STAND_master.lai 
           FROM STAND_master INNER JOIN SITESID_master ON STAND_master.site_id = SITESID_master.site_id  
           INNER JOIN TREESPECIES_master ON STAND_master.species_id = TREESPECIES_master.species_id"
       #    INNER JOIN PLOTSIZE_master ON TREE_master.site_id = PLOTSIZE_master.site_id AND  TREE_master.year = PLOTSIZE_master.year"
)

## Close connnection to db
dbDisconnect(db)



db <- dbConnect(SQLite(), dbname=myDB)
spp <- dbGetQuery(db, "SELECT species_id FROM (SELECT DISTINCT species_id FROM STAND_master)")

for (i in 1:length(spp[,1])){
  if ( paste("STAND_", spp[i,], sep ="") %in% dbListTables(db)){
    dbSendQuery(db, paste("DROP VIEW STAND_", spp[i,], sep =""))}
  dbGetQuery(db, paste("CREATE VIEW STAND_", spp[i,], " AS ",
                       "SELECT STAND_master.record_id, ",
                       "SITESID_master.site, ",
                       "STAND_master.site_id, ",
                       "STAND_master.year, ",
                       "TREESPECIES_master.species, ",
                       "STAND_master.species_id, ",
                       "STAND_master.age, ",
                       "STAND_master.dbhArith_cm, ",
                       "STAND_master.dbhBA_cm, ",
                       "STAND_master.dbhDQ_cm, ",
                       "STAND_master.heightArith_m, ",
                       "STAND_master.heightBA_m, ",
                       "STAND_master.ba_m2ha, ",
                       "STAND_master.density_treeha, ",
                       "STAND_master.aboveGroundBiomass_kgha,",
                       "STAND_master.foliageBiomass_kgha,",
                       "STAND_master.branchesBiomass_kgha,",
                       "STAND_master.stemBiomass_kgha, ",
                       "STAND_master.rootBiomass_kgha, ",
                       "STAND_master.stumpCoarseRootBiomass_kgha, ",
                       "STAND_master.lai ",
                       "FROM STAND_master INNER JOIN SITESID_master ON STAND_master.site_id = SITESID_master.site_id ", 
                       "INNER JOIN TREESPECIES_master ON STAND_master.species_id = TREESPECIES_master.species_id ",
                    #   "INNER JOIN PLOTSIZE_master ON TREE_master.site_id = PLOTSIZE_master.site_id AND  STAND_master.year = PLOTSIZE_master.year ",
                       "WHERE STAND_master.species_id = '", spp[i,], "'", sep = "")
  )
}
## Close connnection to db
dbDisconnect(db)

db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM STAND_master)")

for (i in 1:length(ids[,1])){
  spp <- dbGetQuery(db, paste("SELECT species_id FROM (SELECT DISTINCT species_id FROM STAND_master WHERE site_id ='",
                              ids[i,],  "')", sep = ""))
  for (j in 1:length(spp[,1])){
    if ( paste("STAND_",spp[j,],"_", ids[i,], sep ="") %in% dbListTables(db)){
      dbSendQuery(db, paste("DROP VIEW STAND_", spp[j,],"_", ids[i,], sep =""))}
    dbGetQuery(db, paste("CREATE VIEW STAND_",spp[j,],"_", ids[i,], " AS ",
                         "SELECT STAND_master.record_id, ",
                         "SITESID_master.site, ",
                         "STAND_master.site_id, ",
                         "STAND_master.year, ",
                         "TREESPECIES_master.species, ",
                         "STAND_master.species_id, ",
                         "STAND_master.age, ",
                         "STAND_master.dbhArith_cm, ",
                         "STAND_master.dbhBA_cm, ",
                         "STAND_master.dbhDQ_cm, ",
                         "STAND_master.heightArith_m, ",
                         "STAND_master.heightBA_m, ",
                         "STAND_master.ba_m2ha, ",
                         "STAND_master.density_treeha, ",
                         "STAND_master.aboveGroundBiomass_kgha,",
                         "STAND_master.foliageBiomass_kgha,",
                         "STAND_master.branchesBiomass_kgha,",
                         "STAND_master.stemBiomass_kgha, ",
                         "STAND_master.rootBiomass_kgha, ",
                         "STAND_master.stumpCoarseRootBiomass_kgha, ",
                         "STAND_master.lai ",
                         "FROM STAND_master INNER JOIN SITESID_master ON STAND_master.site_id = SITESID_master.site_id ", 
                         "INNER JOIN TREESPECIES_master ON STAND_master.species_id = TREESPECIES_master.species_id ",
                     #    "INNER JOIN PLOTSIZE_master ON STAND_master.site_id = PLOTSIZE_master.site_id AND  STAND_master.year = PLOTSIZE_master.year ",
                         "WHERE STAND_master.site_id ='",ids[i,], "' AND STAND_master.species_id = '", spp[j,], "'",
                         sep = "")
    )
  }
}
## Close connnection to db
dbDisconnect(db)

db <- dbConnect(SQLite(), dbname=myDB)
ids <- dbGetQuery(db, "SELECT site_id FROM (SELECT DISTINCT site_id FROM STAND_master)")

for (i in 1:length(ids[,1])){
  if ( paste("STAND_",ids[i,], sep ="") %in% dbListTables(db)){
    dbSendQuery(db, paste("DROP VIEW STAND_", ids[i,], sep =""))}
  dbGetQuery(db, paste("CREATE VIEW STAND_",ids[i,],  " AS ",
                       "SELECT STAND_master.record_id, ",
                       "SITESID_master.site, ",
                       "STAND_master.site_id, ",
                       "STAND_master.year, ",
                       "TREESPECIES_master.species, ",
                       "STAND_master.species_id, ",
                       "STAND_master.age, ",
                       "STAND_master.dbhArith_cm, ",
                       "STAND_master.dbhBA_cm, ",
                       "STAND_master.dbhDQ_cm, ",
                       "STAND_master.heightArith_m, ",
                       "STAND_master.heightBA_m, ",
                       "STAND_master.ba_m2ha, ",
                       "STAND_master.density_treeha, ",                       
                       "STAND_master.aboveGroundBiomass_kgha,",
                       "STAND_master.foliageBiomass_kgha,",
                       "STAND_master.branchesBiomass_kgha,",
                       "STAND_master.stemBiomass_kgha, ",
                       "STAND_master.rootBiomass_kgha, ",
                       "STAND_master.stumpCoarseRootBiomass_kgha, ",
                       "STAND_master.lai ",
                       "FROM STAND_master INNER JOIN SITESID_master ON STAND_master.site_id = SITESID_master.site_id ", 
                       "INNER JOIN TREESPECIES_master ON STAND_master.species_id = TREESPECIES_master.species_id ",
                      # "INNER JOIN PLOTSIZE_master ON STAND_master.site_id = PLOTSIZE_master.site_id AND  STAND_master.year = PLOTSIZE_master.year ",
                       "WHERE STAND_master.site_id = '", ids[i,], "'",
                       sep = "")
  )
  
}
## Close connnection to db
dbDisconnect(db)
