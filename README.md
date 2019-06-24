# ProfoundData

This repository contains two components

- The code used to create the PROFOUND database

- The ProfoundData R package for downloading and exploring data from the PROFOUND database

## The PROFOUND database

The PROFOUND database is a collection of data for calibrating, validating and benchmarking dynamic vegetation models. 

- The code to clean the data / create the database is available [here](./PROFOUND%20database/).   
- News / version infos / changes of the code [here](./PROFOUND%20database/NEWS.md)
- The database itself is hosted by the Potsdam Institute for Climate Research [PIK](http://www.pik-potsdam.de/). You can dowload the database via 

```{r}
library(ProfoundData)
downloadDatabase()
```

## The ProfoundData R package

The ProfoundData R package helps users to download and explore the PROFOUND database from the R environment. 

### Installing the package 

CRAN install will come soon. If you want to install the current (development) version from this repository, run

```{r}
devtools::install_github(repo = "COST-FP1304-PROFOUND/ProfoundData", subdir = "ProfoundData", 
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


