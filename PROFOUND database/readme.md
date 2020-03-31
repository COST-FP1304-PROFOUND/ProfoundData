# Overview

- **Processing**, scripts for processing the data included in the database

- **createDB**, scripts to build up the database

- **testDB**, scripts to test the database correctness

- **exportDB**, script to export the master tables as ASCII files.


# News

## v0.2.0 - Release Notes

### New datasets

* FLUXNET-ENERGYBALANCE: renamed ENERGYBALANCE. Now it is ATMOSPHERICHEATCONDUCTION. 

### Changes in existing datasets

* CLIMATE_LOCAL: replaced wrong prepicipation values in the years 2011 and 2012 in the data of Soro.
* CO2_ISIMIP: renamed forcingConditions to forcingCondition.
* FLUXNET-ENERGYBALANCE: renamed table ENERGYBALANCE. Now it is ATMOSPHERICHEATCONDUCTION. 
* ISIMIPFT: renamed forcingConditions to forcingCondition.
* ISIMIP2A: renamed WATCH-WFDEI. Now it is WFDEI. 
* ISIMIP2B: added new RCPs 4.5 and 8.5. Renamed forcingConditions to forcingCondition.
* ISIMIP2BLBC: added HadGEM2-ES data sets. Renamed forcingConditions to forcingCondition.
* MODIS - MODIS_MODMOD09A1: added corrected SANI data.
* NDEPOSITION_ISIMIP2B: added new  nitrogen data for the RCPs 4.5 and 8.5. Renamed forcingConditions to forcingCondition.
* PLOTSIZE: added missing plot size for LeBray and some Peitz records.
* SITEDESCRIPTION: completed and updated descriptions for all sites.
* SOIL: added and updated FAO soil type (type_fao) for all sites. Corrected wrong units (cm) of the horizon layers depths for Soro data.
* STAND: added missing age for Collelongo, Kroof, Soro. Added missing basal area.
* TREESPECIES: corrected Pinus sylvestris."


## v0.1.12 - Release Notes

### Major changes

* Sites included in the database
  -  Removed incomplete sites (Braschaat, Espirra, Hesse, Puechabon) from the PROFOUND database. 
  - Additionally, removed additional site names and kept only those after the ISIMIP protocoll.
  - These changes affect the entire database. 


### New datasets

* MODIS: new data and new structure. Removed MODIS8 and MODIS16 and added five tables (MODIS_MOD09A1, MODIS_MOD11A2, MODIS_MOD13Q1, MODIS_MOD15A2, MODIS_MOD17A2). Created subsequent METADATA.


### Changes in existing datasets

* POLICY: updated the PROFOUND database policy. Add new MODIS policy.
* POLICY_SITES: updated LeBRay and Soro policy.
* SOURCE: updated MODIS_MOD, NDEPOSITION_ISIMIP2B, CLIMATE_LOCAL sources. 
* OVERVIEW: renamed name1 to site. Corrected a bug that prevented CLIMATE_ISIMIP2B and CLIMATE_ISIMIP2BLBC from being displayed. 
* OVERVIEW_EXTENDED: renamed name1 to site. Corrected a bug that prevented CLIMATE_ISIMIP2B and CLIMATE_ISIMIP2BLBC from being displayed. 
* METADATA_FLUX: corrected a bug that prevented the FLUX variables from being displayed. 
* METADATA_STAND: corrected a bug that prevented the STAND variables from being displayed. Updated metadata. 
* METADATA_CLIMATE_LOCAL: updated metadata. 
* SITES: added soro missing values. 
* TREESPECIES: corrected Pinus pinaaster to Pinus pinaster. This affects STAND and TREE views. 
* CLIMATE_LOCAL from FLUXNET (CLIMATEFLUXNET): created quality flag for relative humidity. Soro new precipitacion data for 2011 and 2012 (see site specific metadata). 
* METADATA_CLIMATE_LOCAL (METADATA_CLIMATEFLUXNET): updated metadata.
* TREE: renamed TREE views with the convention TREE_species_site_id. New data for Soro. 
* STAND: renamed STAND views with the convention STAND_species_site_id. New data for Soro. 
* CO2_ISIMIP: added new data to historical forcingCondition. 
* METADATA_DATASET: corrected a bug that prevented site from being displayed. 
* METADATA_CLIMATE_LOCAL: added missing column record_id.  
* METADATA_CO2_ISIMIP: updated column names, source is removed and IDrecord is renamed to record_id. 
* CLIMATE_ISIMIP2BLBC: new p_mm data for Soro. 
* METADATA_SITEDESCRIPTION: corrected a bug that made the view to display METADATA_SITESID. 
* METADATA_STAND: corrected a bug that prevented the variable site from being displayed. 
* ENERGYBALANCE: added two new quality flags, leCORR_qc and hCORR_qc. 
* METADATA_FLUXNET: updated metadata. 
* SITEDESCRIPTION: corrected typos in site description. 


## v0.1.11 - Release Notes

* Major changes in the database structure: moved from table collection to relational database (master tables and views).
* Included site specific metadata. 
* Quality check of data by data providers. 
* ISIMIP: deleted ISIMIP, put old data into and CLIMATE_ISIMIPFT and CLIMATE_ISIMIP2A. 
* Added CLIMATE_ISIMIP2B and CLIMATE_ISIMIP2BLBC (Local Bias Corrected). New variables forcingDatasets and forcingConditions. * NDEPOSITION_ISIMIP2B: new dataset from ISIMIP2B. 
* CO2: renamed to CO2_ISIMIP and changed years for rcp to make it consistent with protocol. 
* METEOROLOGICAL: new dataset with half-hourly climate observations from FLUXNET. 
* TREE: new data for Solling 304 and 305. Removed additional dbh and height measurements. 
* STAND: new data for Solling 304 and Solling 305. Introduce new variables for dbh and height (see metadata). Ensured consistency between STAND and TREE. Included variables derived from TREE. Corrected bug in Kroof Stand data. New LeBray stand data (included biomass).  
* PLOTSIZE_master: new dataset to hold the plot size. 
* SOIL: new data for Solling_304, Solling_305, Soro and LeBray. 
* CLIMATE: renamed to CLIMATE_LOCAL. LeBray has CLIMATE_LOCAL derived from FLUXNET. 
* FLUXNET: derived tables ENERGYBALANCE, METEOROLOGICAL, SOILTS and FLUX. Data for LeBray. 
* MODIS 8 and MODIS 16: new datasets from MODIS with 8 and 16 days temporal resolution (composites). 
* METADATA: introduced metadata for all dataset and sites. 
* SOURCE: new dataset with data source and references for each dataset and site. 
* POLICY: new dataset with policy for each dataset and site. 
* SITEDESCRIPTION: new dataset with site description and references.


## v0.1.10 - Release Notes

* Version for revision by PIs.
 
## v0.1.9 - Release Notes


### Changes in existing datasets

* SOIL: added missing data. 
* ISIMIP: edited GCM names to be consistent with tables. 
* CLIMATE: corrected out the range humidity values for LeBray. Corrected interchanged locations (Brasschaat, BilyKriz, Hyytiala, Puechabon, Soro). 
* FLUX: corrected interchanged locations (Brasschaat, BilyKriz, Hyytiala, Puechabon, Soro). 
* ENERGYBALANCE: corrected interchanged locations (Brasschaat, BilyKriz, Hyytiala, Puechabon, Soro). 
* SOILTS: corrected interchanged locations (Brasschaat, BilyKriz, Hyytiala, Puechabon, Soro). 
* METADATA_DATASETS: completed species code.

## v0.1.8 - Release Notes

### New datasets

* METADATA_DATASET

### Changes in existing datasets

* TREE: BilyKriz added height. Hyytiala correction, hardwood 2008 the height and BDH values were interchanged. 
* ISIMIP: renamed princenton in princeton. 


## v0.1.7 - Release Notes


### Changes in existing datasets

* SOIL: Peitz correction in N. 
* CLIMATE: correction in radiation for Brasschaat, BilyKriz, Puechabon, Soro, Hyytiala, LeBray, Solling 304, and Solling 305. * STAND: Peitz age. Include all available years for Sollling 304 and 304

## v0.1.6 - Release Notes

### New datasets

* ENERGYBALANCE
* SOILTS
* NDEPOSITION

### Changes in existing datasets

* FLUX: new variables set. 
* SOIL: data for Collelongo. 
* CLIMATE: correction in radiation for Brasschaat, BilyKriz, Puechabon, Soro, Hyytiala. 
* STAND: added data for Solling 304 and 305


## v0.1.5 - Release Notes

### Changes in existing datasets

* STAND: error correction  for Hyytiala

## v0.1.4 - Release Notes

### New datasets

* CO2: time series for CO2 for the past and the future according to the different RCPs.  

### Changes in existing datasets

* SITES: new sites (e.g. Collelongo, Solling 305), but yet not complete. Site parameters for several locations (aspect, elevation, slope, natural vegetation) 
* TREE: Error correction in Solling 304 tree data: height was in dm not im m.  Added Soro. 
* STAND: several locations (Collelongo, Kroof, Hyytiala, Peitz, Soro). 
* FLUX:  replaced old data by new from FLUXNET. 
* SOIL: BilyKriz, Solling 304 and 305.

## v0.1.3 - Release Notes

### Changes in existing datasets

* ISIMIP: Corrected errors in GSWP3, princenton, watch, watch+wfdei RCP had no value in the table which result on empty outputs with getData

## v0.1.2 - Release Notes

### Changes in existing datasets

* TREE: added data of Bily Kriz. 
* CLIMATE: now gap free. New climate data has been derived from FLUXNET 2015 for Bily Kriz, Brasschat, Hyytiala, Puechabon and Soro. Le Bray still has gaps. 
* SOIL: Soro and Hyytiala have new data.

## v0.1.1 - Release Notes

### Changes in existing datasets

* TREE: Corrected errors

## v0.1.0 - Release Notes

First PROFOUND Database version




