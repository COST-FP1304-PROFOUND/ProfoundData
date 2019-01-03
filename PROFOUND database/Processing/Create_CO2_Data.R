#------------------------------------------------------------------------------#
#                              CO2 DATA
#------------------------------------------------------------------------------#
# This script deos the following:
#          1. Merges all CO2 data
#
# Target variables are: RCP, year, C02 or concentration
# keep column CO2:Atmospheric CO2 concentrations and Year
# Drop duplicate historical data
#
#------------------------------------------------------------------------------#
directory <- "~/ownCloud/PROFOUND_Data/Processed/"
setwd(directory)

# Where data is


filenames <- list.files("./CO2", pattern = "Nocomments", full.names = TRUE)

df_list <- vector("list", length(filenames))
names(df_list ) <- c("20th","rcp2p6", "rcp4p5", "rcp6p0", "rcp8p5")

for (i in 1:length(filenames)){
  df_list[[i]] <- read.table(filenames[i], header = TRUE)
}

# Range of historical data
df <- read.table("./CO2/historical_CO2_annual.txt",
                 header =FALSE)
summary(df)

# Compare CO2 Values of period
names(df) <- c("YEARS", "historical")

df_subset <- df[df$YEARS < 2006, ]
for (i in 1:length(df_list)){
  co2_subset <- df_list[[i]][df_list[[i]]$YEARS < 2006, "CO2"]
  df_subset[[names(df_list)[i]]] <- co2_subset
}
# All same values. The historical is rounded up to 2 decimal positions
# Lets drop the 20th centruy because is providing no information
names(df_list)

df_list[[1]] <- NULL


#------------------------------------------------------------------------------#
# Create the data with the structrue Year RCP CO2

CO2_ISIMIP_Data <- vector("list", length(df_list) +1 )
names(CO2_ISIMIP_Data) <- c(names(df_list), "HISTORICAL")

for (i in 1:length(df_list)){
  CO2_ISIMIP_Data[[i]] <- df_list[[i]][df_list[[i]]$YEAR >= 2006, c("YEARS", "CO2")]
  CO2_ISIMIP_Data[[i]]$RCP <- names(df_list)[i]
}


# Now add any of the data from the df with all historical values
historical_CO2 <- df_list[[i]][df_list[[i]]$YEAR < 2006, c("YEARS", "CO2") ]
names(historical_CO2) <- c("YEARS","CO2")
# Add the new CO2 historical
df <- read.table("./CO2/historicalco2_until2015.txt", col.names = c("YEARS","CO2"))
historical_CO2 <- rbind(historical_CO2, df)
historical_CO2$RCP <- "historical"
CO2_ISIMIP_Data$HISTORICAL <- historical_CO2
CO2_ISIMIP_Data <- do.call("rbind", CO2_ISIMIP_Data)


rownames(CO2_ISIMIP_Data) <- NULL

names(CO2_ISIMIP_Data) <- c("year", "co2_ppm", "forcingCondition")

CO2_ISIMIP_Data$site_id <- 99
CO2_ISIMIP_Data$site <- "Global"


save(CO2_ISIMIP_Data, file="./RData/CO2_ISIMIP_Data.RData")

### Check data
load("./RData/CO2_ISIMIP_Data.RData")

str(CO2_ISIMIP_Data)

#sink("./RData/CO2_ISIMIP_Data.txt")
#str(CO2_ISIMIP_Data)
#sink()

