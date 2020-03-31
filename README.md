# The Profound dataset for checking and benchmarking of dynamic vegetation models

The PROFOUND database is a collection of data for calibrating, validating and benchmarking dynamic vegetation models, created by [Cost Action FP1304 PROFOUND](https://twitter.com/FP1304Profound). The database itself, including document and description of the dasta, is hosted by the Potsdam Institute for Climate Research [http://doi.org/10.5880/PIK.2019.008](http://doi.org/10.5880/PIK.2019.008). You can dowload the database either there, or, via the R pacakge (see below). The source code that was used to create the database is available [here](https://github.com/COST-FP1304-PROFOUND/ProfoundData/tree/master/PROFOUND%20database).   

## Installing the ProfoundData R package

The ProfoundData R package helps users to download and explore the PROFOUND database from the R environment. The package is available from CRAN. To install the (typically more stable) CRAN version, just type:

```{r}
install.packages("ProfoundData")
```

If you want to install the current (development) version from this repository, run

```{r}
devtools::install_github(repo = "COST-FP1304-PROFOUND/ProfoundData", 
subdir = "ProfoundData", 
dependencies = T, build_vignettes = T)
```
Below the status of the automatic Travis CI tests on the master branch (if this doesn load see [here](https://travis-ci.org/COST-FP1304-PROFOUND/ProfoundData))

[![Build Status](https://travis-ci.org/COST-FP1304-PROFOUND/ProfoundData.svg?branch=master)](https://travis-ci.org/COST-FP1304-PROFOUND/ProfoundData)


## First steps

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

## Downloading the database from R

```{r}
downloadDatabase()
```

