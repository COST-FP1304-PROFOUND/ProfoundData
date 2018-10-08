# ProfoundData

ProfoundData is an R package for downloading and exploring data from the PROFOUND database.

## The PROFOUND database

The database is openly available after request at [PIK](http://pmd.gfz-potsdam.de/panmetaworks/review/8993fe318f6828555d421a3a86c47f80a410ffaba6120fe0de97de1d02a3bdfc-pik/)

## Getting the ProfoundData R package

### Installing the R package from CRAN

Coming soon 

### Development release 

If you want to install the current (development) version from this repository, run

```{r}
devtools::install_github(repo = "COST-FP1304-PROFOUND/ProfoundData", subdir = "ProfoundData", 
dependencies = T, build_vignettes = T)
```
Below the status of the automatic Travis CI tests on the master branch (if this doesn load see [here](https://travis-ci.org/COST-FP1304-PROFOUND/ProfoundData))

[![Build Status](https://travis-ci.org/COST-FP1304-PROFOUND/ProfoundData.svg?branch=master)](https://travis-ci.org/COST-FP1304-PROFOUND/ProfoundData)

### Older releases

To install a specific (older) release, or a particular branch, decide for the version number that you want to install in [https://github.com/COST-FP1304-PROFOUND/ProfoundData/releases](https://github.com/COST-FP1304-PROFOUND/ProfoundData/releases) (version numbering corresponds to CRAN, but there may be smaller releases that were not pushed to CRAN), or branch and run 

```{r}
devtools::install_github(repo = "COST-FP1304-PROFOUND/ProfoundData", subdir = "ProfoundData", 
ref = "v0.0.2.1", dependencies = T, build_vignettes = T)
```
with the appropriate version number / branch as argument to ref. 

### Getting started

To get an overview about its functionality once the package is installed, run

```{r}
library(ProfoundData)
?ProfoundData
vignette("ProfoundData", package="ProfoundData")
```
To cite the package, run 

```{r}
citation("ProfoundData")
```

## Repository structure

### ProfoundData folder

Contains the PROFOUND R-package

### PROFOUND database

Contains four folders:

- **Processing**, scripts for processing the data included in the database

- **createDB**, scripts to build up the database

- **testDB**, scripts to test the database correctness

- **exportDB**, script to export the master tables as ASCII files.



#### createDB
