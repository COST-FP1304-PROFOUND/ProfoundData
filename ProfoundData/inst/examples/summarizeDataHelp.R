\dontrun{

# Summarize by years
data <-summarizeData(dataset =  "TREE", location = "bily_kriz", by = "year",
                     mode = "data")
data <-summarizeData(dataset =  "CLIMATE_LOCAL", location = "bily_kriz", by = "year",
                     mode = "data")
data <-summarizeData(dataset =  "CLIMATE_ISIMIP2A", location = "bily_kriz", by = "year",
                     mode = "data")

# Specify forcing dataset or condition
data <-summarizeData(dataset ="CLIMATE_ISIMIP2B", location ="soro",
                     forcingDataset="GFDLESM2M", forcingCondition ="rcp2p6")


# Summarize total period
data <-summarizeData(dataset =  "TREE", location = "bily_kriz", by = "total",
                     mode = "data")
data <-summarizeData(dataset =  "CLIMATE_LOCAL", location = "bily_kriz", by = "total",
                     mode = "data")

# Summarize overview
data <-summarizeData(dataset =  "CLIMATE_LOCAL", location = "bily_kriz", mode = "overview")
data <-summarizeData(dataset =  "FLUX", location = "bily_kriz", mode = "overview")
 # Here should do min, max, mean, first, last


}
