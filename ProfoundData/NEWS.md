# ProfoundData 0.2.1 

New features

- 

Major changes

- None

Minor changes

- Add

Bugfixes 

- Add, ideally with issue / commit


# ProfoundData 0.2.0 

## Modifications to adapt to new ProfoundData database version (v0.2.0) 

## New function(s)

* reportDB to create a site-by-site report of all avalaible data

## New options for existing functions

- summarizeData now also works for the FLUX dataset. 
  
- new option *mode* for summarizeData with two possible values: data and overview.

## Other changes

* Information of the DB connection is no longer stored as a variable in the package environment,
but as an option relying on the [settings R-package](https://cran.r-project.org/web/packages/settings/index.html). Thus, there is a new package dependency.

* The package vignette has been restructured and its content distributed into three different documents: profoundData.html, PROFOUNDdatabase.html and PROFOUNDsites.html. The latter must be created by the user with the function reportDB.




# v0.1.6 - Release Notes

## Modifications to adapt to new PROFOUND database version (v0.1.12)

## New function(s)

* New function getDB to return information on the connection to the database

## New options for exisiting function

* New options for plotData/getData to do more specific queries:
    - species
    - quality
    - variables
    - forcingDataset, forcingConditions
    
* SITEDESCRIPTION is accessible through getData, not browseData.


# v0.1.5 - Release Notes

## Modifications to adapt to new ProfoundData database version (v0.1.11) 

## New function(s)

* summarizeData to summarize climatic datasets and TREE data
* queryDB to pass self-defined queries to the database
* New options for browseData to access
  - data policy
  - data source
  - sites description
  
# v0.1.3 - Release Notes

## Modifications to adapt to new ProfoundData database version (v0.1.9) 

## New options for exisiting functions

* New options for plotData and more datasets
* browseData integrates previous getFunctions and allows, besides previous options, to access VERSION and METADATA
* New option in getData to download the SITES


# v0.1.2 - Release Notes

## Minor modifications

* Corrected small bugs and typos.

* Format options for new datasets in the DB.

# v0.1.1 - Release Notes

## First package release



