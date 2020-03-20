# example requires that a sql DB is registered via setDB(dbfile)
# when run without a registered DB, you will get a file query (depending on OS)

\dontrun{
# Get SITES data
sites <- getData(dataset =  "SITES")

# Get SITES data of a specific site
site <- getData(dataset =  "SITES", site = "soro")

# Get SITEDESCRIPTION
sites <- getData(dataset =  "SITEDESCRIPTION")

# Get SITEDESCRIPTION of a specific site
site <- getData(dataset =  "SITEDESCRIPTION", site = "lebray")

# Get any dataset for a site
data <- getData(dataset =  "CLIMATE_LOCAL", site = "soro")

# Get ISIMIP datasets as a list with data frames
data <- getData(dataset ="CLIMATE_ISIMIP2A", site = "soro", collapse = TRUE)
data <- getData(dataset ="CLIMATE_ISIMIP2B", site = "soro", collapse = TRUE)
data <- getData(dataset ="NDEPOSITION_ISIMIP2B", site = "soro", collapse = TRUE)

# Get ISIMIP datasets as an unique data frame
data <- getData(dataset ="CLIMATE_ISIMIP2A", site = "soro", collapse = FALSE)
data <- getData(dataset ="CLIMATE_ISIMIP2B", site = "soro", collapse = FALSE)
data <- getData(dataset ="NDEPOSITION_ISIMIP2B", site = "soro", collapse = FALSE)

# Get SOIL data. Collapse FALSE is recommended.
data <- getData(dataset ="SOIL", site = "soro", collapse = FALSE)

# Get specific forcing datasets and/or forcing conditions
data <- getData(dataset ="CLIMATE_ISIMIP2B", site ="soro",
                 forcingDataset="GFDLESM2M", forcingCondition ="rcp2p6")
# which is equivalent to
data <- getData(dataset ="CLIMATE_ISIMIP2B_GFDLESM2M_rcp2p6", site ="soro")

# Specify variables
data <- getData(dataset ="CLIMATE_ISIMIP2B", site ="soro",
                forcingDataset="GFDLESM2M", forcingCondition ="rcp2p6",
                variables = "p_mm")
data <- getData(dataset ="CLIMATE_ISIMIP2B", site ="soro",
                forcingDataset="GFDLESM2M", forcingCondition ="rcp2p6",
                variables = c("tmax_degC","p_mm"))

# Specify species
data <- getData(dataset ="TREE", site ="hyytiala", species = "Pinus sylvestris")
data <- getData(dataset ="TREE", site ="hyytiala", species = "pisy")
data <- getData(dataset ="STAND", site ="hyytiala", species = "Picea abies")
data <- getData(dataset ="STAND", site ="hyytiala", species = "piab")

# Specify period
data <- getData(dataset ="CLIMATE_ISIMIP2B", site ="soro",
                forcingDataset="GFDLESM2M", forcingCondition ="rcp2p6",
                period = c("2006-01-01","2006-12-31"))

# Specify quality
data <- getData(dataset = "CLIMATE_LOCAL", site = "soro",
                quality = 1, decreasing = FALSE)
data <- getData(dataset = "FLUX", site = "soro",
                quality = 0, decreasing = TRUE)
}
