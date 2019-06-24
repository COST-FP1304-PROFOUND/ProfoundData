# The Profound dataset for checking and benchmarking of dynamic vegetation models

# About the database

The PROFOUND database is a collection of data for calibrating, validating and benchmarking dynamic vegetation models, created by [Cost Action FP1304 PROFOUND](https://twitter.com/FP1304Profound).

- The code to clean the data / create the database is available [here](https://github.com/COST-FP1304-PROFOUND/ProfoundData/tree/master/PROFOUND%20database).   
- News / version infos / changes of the code [here](./PROFOUND%20database/NEWS.md)
- The database itself, including document and description of the dasta, is hosted by the Potsdam Institute for Climate Research [http://doi.org/10.5880/PIK.2019.008](http://doi.org/10.5880/PIK.2019.008). You can dowload the database either there, or, if you have the R pacakge installed (see below), via 

```{r}
library(ProfoundData)
downloadDatabase()
```

## The ProfoundData R package

The ProfoundData R package helps users to download and explore the PROFOUND database from the R environment. 

### Installing the package 

CRAN install will come soon. If you want to install the current (development) version from this repository, run

```{r}
# requires package devtools installed
devtools::install_github(repo = "COST-FP1304-PROFOUND/ProfoundData", 
subdir = "ProfoundData", 
dependencies = T, build_vignettes = T)
```
Below the status of the automatic Travis CI tests on the master branch (if this doesn load see [here](https://travis-ci.org/COST-FP1304-PROFOUND/ProfoundData))

[![Build Status](https://travis-ci.org/COST-FP1304-PROFOUND/ProfoundData.svg?branch=master)](https://travis-ci.org/COST-FP1304-PROFOUND/ProfoundData)


### First steps

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


