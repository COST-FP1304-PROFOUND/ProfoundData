#------------------------------------------------------------------------------#
# Soil data
#     This script does the following:
#
#------------------------------------------------------------------------------#
load("~/ownCloud/PROFOUND_Data/Processed/RData/Soil_Data_Wide.RData")

# Target variables
columns <- c("record_id", "site_id", "table_id", "layer_id", "date",
  "horizon","upperDepth_cm","lowerDepth_cm","type_fao", "type_ka5", 
  "texture", "thickness_cm", "thicknesSigma_cm", "density_gcm3", "densitySigma_gcm3",
  "clay_percent", "claySigma_percent", "silt_percent", "siltSigma_percent",
  "sand_percent", "sandSigma_percent", "gravel_percent",
  "ph_h2o", "phSigma_h2o", "phSigma_kcl", "ph_kcl", "ph_cacl2",
  "porosity_percent", "fcapv_percent","wiltpv_percent", 
  "whcp","whc_mm", "whcSigma_mm", "cec_µeqg", 
  "c_percent","c_kgm2", "cSigma_kgm2", "humus_tCha", "cMax_percent", "cMin_percent", "cOrg_gcm3", "cOrg_percent", "cOrgSigma_percent", 
  "n_percent", "n_kgm2", "nMax_percent", "nMin_percent", "nOrg_percent", "nOrgSigma_percent", 
   "cn", "mbC_mgg", "mbCSigma_mgg", "mbN_mgg", "mbNSigma_mgg", "rMin_mgNkgH", "rMinSigma_mgNkgH", 
  "ofhC_percent", "ofh_gDWm2", "ofhN_percent", "ol_gDWm2",  
  "bs_percent", "fineRoot_percent", "hydCondSat_cmd1",  "rainGroundWater")

columns[!columns %in% names(Soil_Data_Wide)] 
names(Soil_Data_Wide)[!names(Soil_Data_Wide) %in% columns] 

#------------------------------------------------------------------------------#
#                    CREATE   SQL    TABLE
#------------------------------------------------------------------------------#
# Load libraries
library(sqldf)
library(DBI)
library(RSQLite)
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
# create table in DB (cant type minus)
if ( "SOIL_master" %in% dbListTables(db)) dbSendQuery(db, "DROP TABLE SOIL_master")

dbSendQuery(conn = db,
            "CREATE TABLE SOIL_master
       (record_id INTEGER,
        site_id INTEGER,
        table_id INTEGER,
        layer_id INTEGER,
        date TEXT ,
        horizon REAL ,
        upperDepth_cm REAL ,
        lowerDepth_cm REAL ,
        type_fao TEXT ,
        type_ka5 TEXT ,
        texture TEXT ,
        thickness_cm REAL ,
        thicknesSigma_cm REAL ,
        density_gcm3 REAL ,
        densitySigma_gcm3 REAL ,
        clay_percent REAL ,
        claySigma_percent REAL ,
        silt_percent REAL ,
        siltSigma_percent REAL ,
        sand_percent REAL ,
        sandSigma_percent REAL ,
        gravel_percent REAL ,
        ph_h2o REAL ,
        phSigma_h2o REAL ,
        phSigma_kcl REAL ,
        ph_kcl REAL ,
        ph_cacl2 REAL ,
        porosity_percent REAL ,
        fcapv_percent REAL ,
        wiltpv_percent REAL ,
        whcp REAL ,
        whc_mm REAL ,
        whcSigma_mm REAL ,
        cec_µeqg REAL ,
        c_percent REAL ,
        c_kgm2 REAL ,
        cSigma_kgm2 REAL ,
        humus_tCha REAL ,
        cMax_percent REAL ,
        cMin_percent REAL ,
        cOrg_gcm3 REAL ,
        cOrg_percent REAL ,
        cOrgSigma_percent REAL ,
        n_percent REAL ,
        n_kgm2 REAL ,
        nMax_percent REAL ,
        nMin_percent REAL ,
        nOrg_percent REAL ,
        nOrgSigma_percent REAL ,
        cn REAL ,
        mbC_mgg REAL ,
        mbCSigma_mgg REAL ,
        mbN_mgg REAL ,
        mbNSigma_mgg REAL ,
        rMin_mgNkgH REAL ,
        rMinSigma_mgNkgH REAL ,
        ofhC_percent REAL ,
        ofh_gDWm2 REAL ,
        ofhN_percent REAL ,
        ol_gDWm2 REAL ,
        bs_percent REAL ,
        fineRoot_percent REAL ,
        hydCondSat_cmd1 REAL ,
        rainGroundWater TEXT,
        PRIMARY KEY (record_id),
        FOREIGN KEY (site_id) REFERENCES SITESID_master(site_id)
            )")

# Check the table
dbListTables(db) # The tables in the database
dbListFields(db, "SOIL_master") # The fields in the table
## Close connnection to db
dbDisconnect(db)
# dbSendQuery(db, "DROP TABLE SOIL")
#------------------------------------------------------------------------------#
#               ENTER DATA IN THE TABLE
#------------------------------------------------------------------------------#
id <- 0
# Loop over files adds data to DB, could also add it to list and then do.call(rbind, listDf)
df <- Soil_Data_Wide
df$record_id <- c((id+1):(id+length(df$site)))
# open connection to DB
db <- dbConnect(SQLite(), dbname= myDB)
dbWriteTable(db, "SOIL_master",
                 df[,columns],
                 append=TRUE, row.names = FALSE)
dbDisconnect(db)
  # reset the id values
id <- id+length(df$site)

# create index
db <- dbConnect(SQLite(), dbname=myDB)
# create index for variables we are going to query: so far location, gcm, rcp
# --> change names to include the table
dbGetQuery(db,"CREATE INDEX index_SOIL_master_site_id ON SOIL_master (site_id)")
## Close connnection to db
dbDisconnect(db)

