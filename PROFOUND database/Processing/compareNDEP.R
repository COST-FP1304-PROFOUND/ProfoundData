
load( "~/ownCloud/PROFOUND_Data/Processed/RData/NDep_Data.RData")
# Target variables
#variables_names <- c( "RCP","year", "CO2")
# Columns DB
columns <- c("IDrecord", "site_id",  "year", "NdepOxi_gm2","NdepRed_gm2")

op <- par(mfrow = c(7,2), mar=c(2,2,2,1))
op <- par(mfrow = c(1,2), mar=c(3,3,3,1))
for (i in 1:length(NDep_Data)){
  df1 <- NDep_Data[[i]]  
  site_id <- unique(df1$site_id)
  location <- unique(df1$site)
  db <- dbConnect(SQLite(), dbname=myDB)
  df2 <- dbGetQuery(db, paste("SELECT * FROM NDEPOSITION_ISIMIP2B_historical_", site_id, sep=""))
  dbDisconnect(db)
  plot(df1$year, df1$NdepOxi_gm2, main = paste(location, ": NdepOxi", sep = ""), type = "l" , ylab = "gN m2", xlab = "years",
       ylim=c(0,2.5))
  lines(df2$year, df2$NdepOxi_gm2,  lty=2, col="red" )
  legend("topright", c("EMEP", "ISIMIP2B"), cex=0.8, col=c("black", "red"), lty=c(1, 2))
  
  plot(df1$year, df1$NdepRed_gm2, main = paste(location, ": NdepRed", sep = ""), type = "l" , ylab = "gN m2", xlab = "years",
       ylim=c(0,2.5))
  lines(df2$year, df2$NdepRed_gm2,  lty=2, col="red" )
  legend("topright", c("EMEP", "ISIMIP2B"), cex=0.8, col=c("black", "red"), lty=c(1, 2))
  
  rm(site_id)
}
par(op)






