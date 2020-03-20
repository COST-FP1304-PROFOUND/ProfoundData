# example requires that a sql DB is registered via setDB(dbfile)
# when run without a registered DB, you will get a file query (depending on OS)

\dontrun{
# Normal plotting
plotData(dataset = "CLIMATE_LOCAL", site = "le_bray", automaticPanels = TRUE)
plotData(dataset = "TREE", site = "solling_beech",   automaticPanels = TRUE)
plotData(dataset = "CLIMATE_LOCAL", site = "le_bray", automaticPanels = FALSE)
plotData(dataset = "TREE", site = "solling_beech",   automaticPanels = FALSE)

# Plot specific forcing datasets and conditions
plotData(dataset ="CLIMATE_ISIMIP2B", site ="soro", forcingDataset="GFDLESM2M",
         forcingCondition ="rcp2p6", automaticPanels = TRUE)

# Plot specific variables
plotData(dataset ="CLIMATE_ISIMIP2B",site ="soro", forcingDataset="GFDLESM2M",
         forcingCondition ="rcp2p6", variables = "p_mm")
plotData(dataset ="TREE",site ="solling_beech", variables = "dbh1_cm")

# Plot specific species
plotData(dataset ="TREE", site ="hyytiala", species = "Pinus sylvestris",
         automaticPanels = TRUE)

# Plot specific period
plotData(dataset = "CLIMATE_LOCAL", site =  "soro",
         period = c("2011-01-01","2012-12-31"))

# Set quality threshold
plotData(dataset = "CLIMATE_LOCAL", site = "soro",
         period = c("2011-01-01","2012-12-31"), quality = 1, decreasing = FALSE)
plotData(dataset = "FLUX", site = "soro", period = c("2011-01-01","2012-12-31"),
         quality = 0, decreasing = TRUE)

# Plot aggregated data
plotData(dataset = "CLIMATE_ISIMIP2B", site ="soro",  forcingDataset= "GFDLESM2M",
         forcingCondition="rcp2p6", variables = "tmax_degC",
         period = c("2020-01-01", "2022-01-01"),
         aggregate = "month", FUN =median)
plotData(dataset = "CLIMATE_ISIMIP2B", site ="soro",  forcingDataset= "GFDLESM2M",
         forcingCondition="rcp2p6", variables = "p_mm",
         period = c("2020-01-01", "2022-01-01"),
         aggregate = "month", FUN =sum)

# Plot aggregated data with self-defined function. In this case, compare month
# mean temperature of one year to mean of all period
data <- getData(dataset = "CLIMATE_ISIMIP2B", site ="soro",  forcingDataset= "GFDLESM2M",
                forcingCondition="rcp2p6", variables = "tmax_degC")
meanTemperature <- mean(data$tmax_degC, na.rm = TRUE)
difference <- function(x) {mean(x, na.rm = TRUE) -meanTemperature}

plotData(dataset = "CLIMATE_ISIMIP2B", site ="soro",  forcingDataset= "GFDLESM2M",
         forcingCondition="rcp2p6", variables = "tmax_degC",
         period = c("2020-01-01", "2021-01-01"),
         aggregate = "month", FUN =difference)
abline(h = 0, col = "red")
}
