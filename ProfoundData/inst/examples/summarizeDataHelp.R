# example requires that a sql DB is registered via setDB(dbfile)
# when run without a registered DB, you will get a file query (depending on OS)

\dontrun{
# Summarize by years
data <-summarizeData(dataset =  "TREE", site = "bily_kriz", by = "year",
                     mode = "data")
data <-summarizeData(dataset =  "CLIMATE_LOCAL", site = "bily_kriz", by = "year",
                     mode = "data")
data <-summarizeData(dataset =  "CLIMATE_ISIMIP2A", site = "bily_kriz", by = "year",
                     mode = "data")

# Specify forcing dataset or condition
data <-summarizeData(dataset ="CLIMATE_ISIMIP2B", site ="soro",
                     forcingDataset="GFDLESM2M", forcingCondition ="rcp2p6")


# Summarize total period
data <-summarizeData(dataset =  "TREE", site = "bily_kriz", by = "total",
                     mode = "data")
data <-summarizeData(dataset =  "CLIMATE_LOCAL", site = "bily_kriz", by = "total",
                     mode = "data")

# Summarize overview
data <-summarizeData(dataset =  "CLIMATE_LOCAL", site = "bily_kriz", mode = "overview")
data <-summarizeData(dataset =  "FLUX", site = "bily_kriz", mode = "overview")
data <-summarizeData(dataset =  "TREE", site = "bily_kriz", mode = "overview")
data <-summarizeData(dataset =  "STAND", site = "bily_kriz", mode = "overview")
}
