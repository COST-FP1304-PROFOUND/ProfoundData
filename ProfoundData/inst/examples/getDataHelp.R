\dontrun{
# Obtain site data
sites <-getData(dataset =  "SITES")

# Obtain specific site data
site <-getData(dataset =  "SITES", location = "soro")

# Obtain site descriptions
sites <-getData(dataset =  "SITEDESCRIPTION"

# Obtain a specific site description
site <-getData(dataset =  "SITEDESCRIPTION", location = "lebray")


# Obtain any dataset for a location
data <-getData( dataset =  "CLIMATE_LOCAL", location = "soro")

# Obtain ISIMIP datasets as a list with dataframes
data <- getData(dataset ="CLIMATE_ISIMIP2A", location = "soro", collapse = FALSE)

# Obtain ISIMIP datasets as a list with dataframes
data <- getData(dataset ="CLIMATE_ISIMIP2A", location = "soro", collapse = TRUE)
data <- getData(dataset ="CLIMATE_ISIMIP2B", location = "soro", collapse = TRUE)
data <- getData(dataset ="NDEP_ISIMIP2B", location = "soro", collapse = TRUE)

# Obtain ISIMIP datasets as an unique data frame
data <- getData(dataset ="CLIMATE_ISIMIP2A", location = "soro", collapse = FALSE)
data <- getData(dataset ="CLIMATE_ISIMIP2B", location = "soro", collapse = FALSE)
data <- getData(dataset ="NDEP_ISIMIP2B", location = "soro", collapse = FALSE)

# Obtain SOIL data. Collapse FALSE is recommended.
data <- getData(dataset ="SOIL", location = "soro", collapse = FALSE)

# Dowloading specific forcing datasets and/or forcing conditions
data <- getData( dataset ="CLIMATE_ISIMIP2B", location ="soro",
                 forcingDataset="GFDLESM2M", forcingCondition ="rcp2p6")
# Equivalent to
data <- getData(dataset ="CLIMATE_ISIMIP2B_GFDLESM2M_rcp2p6", location ="soro")

# Specify variables
data <- getData(dataset ="CLIMATE_ISIMIP2B", location ="soro",
                forcingDataset="GFDLESM2M", forcingCondition ="rcp2p6",
              variables = "p_mm")

# Specify species
data <- getData(dataset ="TREE", location ="hyytiala", species = "Pinus sylvestris")
data <- getData(dataset ="TREE", location ="hyytiala", species = "pisy")
data <- getData(dataset ="STAND", location ="hyytiala", species = "Pinus sylvestris")
data <- getData(dataset ="STAND", location ="hyytiala", species = "pisy")

# Specify period
data <- getData(dataset ="CLIMATE_ISIMIP2B", location ="soro",
                forcingDataset="GFDLESM2M", forcingCondition ="rcp2p6",
                period = c("2006-01-01","2006-12-31"))

# Specify quality
data <- getData(dataset = "CLIMATE_LOCAL", location = "soro",
                quality = 1, decreasing = FALSE)
data <- getData(dataset = "FLUX", location = "soro",
                quality = 0, decreasing = TRUE)
}
