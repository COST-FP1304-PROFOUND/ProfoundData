# ProfoundData

This repository contains two components

- The code used to create the PROFOUND database

- The ProfoundData R package for downloading and exploring data from the PROFOUND database

## The PROFOUND database

The PROFOUND database is a collection of data for calibrating, validating and benchmarking dynamic vegetation models. 

- The code to clean the data / create the database is available [here](./PROFOUND%20database/).   
- News / version infos / changes of the code [here](./PROFOUND%20database/NEWS.md)
- The database itself is available on request via [PIK](http://pmd.gfz-potsdam.de/panmetaworks/review/8993fe318f6828555d421a3a86c47f80a410ffaba6120fe0de97de1d02a3bdfc-pik/)

## The ProfoundData R package

The ProfoundData R package helps users to download and explore the PROFOUND database from the R environment. To get an overview about its functionality once the package is installed, run

```{r}
library(ProfoundData)
?ProfoundData
vignette("ProfoundData", package="ProfoundData")
```
To cite the package, run 

```{r}
citation("ProfoundData")
```

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
with the appropriate version number / branch as argument to ref. You can find the news file (info about changes for each release) [here](./ProfoundData/NEWS.md)





