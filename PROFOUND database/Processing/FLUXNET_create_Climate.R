#------------------------------------------------------------------------------#
#                             Aggregate meteo data from FLUXNET 2015 -> meteo
#
# This scripts creates the climate variables from the meteo FLUXNET 2015 
#------------------------------------------------------------------------------#
directory <- "~/ownCloud/PROFOUND_Data/Processed/"
setwd(directory)
load("./RData/FLUXNET_Meteo.RData")
require(plyr)
# this functions calculates the quality flags
qf_percent <- function(x){ length(x[x < 2])/length(x)}

qf_percentHumidity <- function(vapor_qc, temperature_qc){
  humidity_qc <- cbind(vapor_qc, temperature_qc)
  humidity_qc <- sapply(1:nrow(humidity_qc), function(x){max(humidity_qc[x,])})
  return(qf_percent(humidity_qc))
}

# this functions cualculates the gaps
gaps_count <- function(x){ length(x[is.na(x)])}

FLUXNET_Climate <- vector("list", length(FLUXNET_Meteo))

names(FLUXNET_Climate) <- names(FLUXNET_Meteo)

variables <- c("NIGHT", "HH", "NIGHT_D", 
               "DAY_D", "NIGHT_RANDUNC_N", "DAY_RANDUNC_N" )





for (i in 1:length(FLUXNET_Meteo)){
  df_meteo <- FLUXNET_Meteo[[i]]
  names_remove <- names(df_meteo)
  names_remove  <- names_remove[grepl("_",names_remove)]                
  df_meteo <- ddply(df_meteo, .(day, mo,  year), transform,
                        tmean_degC=mean(TA_F, na.rm=T),
                        tmax_degC=max(TA_F, na.rm=T),
                        tmin_degC=min(TA_F, na.rm=T),
                        shortwawe_Jcm2day = sum(SW_IN_F * (30*60)/10000, na.rm=T),
                        longwawe_Jcm2day = sum(LW_IN_F *(30*60)/10000, na.rm=T),
                        vpd_hPa = mean(VPD_F, na.rm=T), 
                        p_mm = sum(P_F, na.rm=T),
                        airpress_hPa = mean(PA_F*10, na.rm=T),
                        wind_ms = mean(WS_F, na.rm=T),
                        tmean_qc = qf_percent(TA_F_QC),
                        tmin_qc = qf_percent(TA_F_QC),
                        tmax_qc = qf_percent(TA_F_QC),
                        shortwawe_qc =   qf_percent(SW_IN_F_QC),
                        longwawe_qc =   qf_percent(LW_IN_F_QC),
                        vpd_qc = qf_percent(VPD_F_QC), 
                        p_qc = qf_percent(P_F_QC),
                        airpress_qc = qf_percent(PA_F_QC),
                        wind_qc = qf_percent(WS_F_QC),
                        relhum_qc = qf_percentHumidity(VPD_F_QC, TA_F_QC),
                        t_gaps = gaps_count(TA_F),
                        shortwawe_gaps = gaps_count(SW_IN_F),
                        longwawe_gaps =  gaps_count(LW_IN_F),
                        vpd_gaps = gaps_count(VPD_F), 
                        p_gaps = gaps_count(P_F),
                        airpress_gaps = gaps_count(PA_F),
                        wind_gaps = gaps_count(WS_F))

  df_meteo <-subset(df_meteo, !duplicated(date))
  FLUXNET_Climate[[i]] <- df_meteo[order(df_meteo$date),]
  
}


save(FLUXNET_Climate, file = "./RData/FLUXNET_Climate.RData")

## Calculate the relative humidity

e_Ta <- function(x){  0.6108*exp((17.27*x)/(x+237.3))}

RH_from_vpd <- function(vpd, tmax, tmin){
  es <- (e_Ta(tmax) + e_Ta(tmin))/2
  ratio <- vpd/es
  ratio <- ifelse(ratio > 1,  1, ratio)
  rh <-(1 - ratio )* 100
  return(rh)  
}

load("./RData/FLUXNET_Climate.RData")


for (i in 1:length(FLUXNET_Climate)){
  FLUXNET_Climate[[i]][['relhum_percent']] <- RH_from_vpd(FLUXNET_Climate[[i]][['vpd_hPa']]/10,
                                                        FLUXNET_Climate[[i]][['tmax_degC']],
                                                        FLUXNET_Climate[[i]][['tmin_degC']])
#  FLUXNET_Climate[[i]][['relhum_qc']] <- FLUXNET_Climate[[i]][['vpd_qc']] # This is done above
  
  FLUXNET_Climate[[i]][['rad_Jcm2']]   <-   FLUXNET_Climate[[i]][['shortwawe_Jcm2']]
  FLUXNET_Climate[[i]][['rad_qc']]   <-   FLUXNET_Climate[[i]][['shortwawe_qc']] 
}

save(FLUXNET_Climate, file = "./RData/FLUXNET_Climate.RData")

### Check data
load("./RData/FLUXNET_Climate.RData")

str(FLUXNET_Climate,1)

sink("./RData/FLUXNET_Climate.txt")
str(FLUXNET_Climate)
sink()
# Add sites
# Get sites
load("./RData/Sites.RData")
# get the  locations
Site <- Sites$site2
Site.id <-  Sites$site_id
names(Site.id) <- Site
# variables to round

for (i in 1:length(FLUXNET_Climate)){
  FLUXNET_Climate[[i]]$site <-names(FLUXNET_Climate)[i]
  FLUXNET_Climate[[i]]$site_id <- Site.id[names(FLUXNET_Climate)[i] ]
}

# Add Soro Data for correction
load("./Soro/Soroe_daily_precipitation_1996_2016.RData")
#cat(Soroe_daily_precipitation_1996_2016.df.des)
head(Soroe_daily_precipitation_1996_2016.df)
climateSoro <-Soroe_daily_precipitation_1996_2016.df[, c("year", "day", "month", "Precip_Soroe", "Precip_DMI_10x10",  "Precip_EOBS_25x25_120_207")]
climateSoro <- climateSoro[climateSoro$year<2013,]
gaps <- is.na(climateSoro[climateSoro$year > 2010,]$Precip_Soroe)
pre2011 <- climateSoro[climateSoro$year < 2011,]$year > 2011
mask <- c(pre2011, gaps)

FLUXNET_Climate$Soro[mask,]$p_mm <-climateSoro[mask,]$Precip_DMI_10x10
FLUXNET_Climate$Soro[mask,]$p_qc <- 0

save(FLUXNET_Climate, file = "./RData/FLUXNET_Climate.RData")