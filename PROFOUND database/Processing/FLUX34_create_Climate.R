#------------------------------------------------------------------------------#
#                             Aggregate meteo data from FLUXNET 2015 -> meteo
#
# This scripts subsets the FLUXNET 2015 data the meteo variables
#------------------------------------------------------------------------------#
directory <- "/home/trashtos/ownCloud/PROFOUND_Data/Processed/"
setwd(directory)

qf_percent <- function(x){ length(x[x < 2])/length(x)}
gaps_count <- function(x){ length(x[is.na(x)])}
FLUX34_meteo <- list()
#------------------------------------------------------------------------------#
# Hyytiala
#--------------------------------------#
files <- list.files("./Hyytiala/Hyytiala_meteo",
                    pattern = "meteo", full.names = TRUE)
files <- sort(files)
df <- read.table(files[1],sep = " ", header = FALSE)
head(df)
# get the names from the file
names.meteo <-c("Year", "Month", "Day","Hour", "Minute_midpoint_of_halfhour_period",
                "Precipitation_mm_includes_snow", "Global_shortwave_radiation_Wm2",
                "Diffuse_shortwave_radiation_Wm2", "Reflected_shortwave_radiation_Wm2",
                "PPFD_quality_flag_0measured_1gapfilled", "PPFD_µmolm2s",
                "Diffuse_PPFD_µmol_m2s", "Reflected_PPFD_µmol_m2s1",
                "Belowcanopy_PPFD_µmolm2s_LiCor_Li190SZ_sensors",
                "Belowcanopy_PPFD_µmolm2s_Apogee_SQ100_sensors",
                "Incoming_longwave_thermal_radiation_Wm2", "Outgoing_longwave_thermal_radiation_Wm2",
                "UVA_320_400_nm_Wm2","UVB_280_320_nm_Wm2", "Net_radiation_Wm2",
                "PRI", "NDVI", "Air_temperature_quality_flag_0measured_1gapfilled",
                "Air_temperature_at_17m_height_degC", "Atmospheric_pressure_hPa",
                "RH_quality_flag_0measured_1gapfilled","Relative_humidity",
                "CO2_quality_flag_0measured_1gapfilled", "CO2_concentration_at_17m_height_ppm",
                "H2O_concentration_at_17m_height_ppth", "Wind_direction_at_34m_deg",
                "Wind_speed_quality_flag_0measured_1gapfilled", "Wind_speed_at_34m_ms",
                "Global shortwave quality flag (0=measured, 1=gapfilled)",
                "Incoming longwave quality flag (0=measured, 1=gapfilled)"
                )
names(df) <- names.meteo
# Read all of them and bind
Hyytiala.meteo <- vector("list", length(files) -1)
for (i in 1: length(Hyytiala.meteo)){
  df <- read.table(files[i],sep = " ", header = FALSE)
  names(df) <- names.meteo
  Hyytiala.meteo[[i]] <- df
}
Hyytiala.meteo <- do.call(rbind, Hyytiala.meteo)
# Remove the -9999 so that we can calculate stats
Hyytiala.meteo[Hyytiala.meteo == -9999] <- NA
# Aggregated column
Hyytiala.meteo$Date <- as.Date(strptime(paste(Hyytiala.meteo$Year,Hyytiala.meteo$Month,
                                              Hyytiala.meteo$Day, sep="-"),
                                        format ="%Y-%m-%d"))

length(unique(Hyytiala.meteo$Date))
# create the DF to hold the data
# variables that must  be created
require(plyr)

#Hyytiala.meteo
Hyytiala.meteo.new<- ddply(Hyytiala.meteo, .(Month, Day, Year), transform,
                           tmean_degC=mean(Air_temperature_at_17m_height_degC, na.rm=T),
                           tmax_degC=max(Air_temperature_at_17m_height_degC, na.rm=T),
                           tmin_degC=min(Air_temperature_at_17m_height_degC, na.rm=T),
                           p_mm = sum(Precipitation_mm_includes_snow, na.rm=T),
                           relhum_percent = mean(Relative_humidity, na.rm=T),
                           airpress_hPA = mean(Atmospheric_pressure_hPa, na.rm=T),
                           rad_Jcm2day = sum(Global_shortwave_radiation_Wm2*(30*60)/10000, na.rm=T),
                           wind_ms = mean(Wind_speed_at_34m_ms, na.rm=T),
                           #
                           tmax_qf = qf_percent(Air_temperature_quality_flag_0measured_1gapfilled),
                           tmin_qf =   qf_percent(Air_temperature_quality_flag_0measured_1gapfilled),
                           tmean_qf =   qf_percent(Air_temperature_quality_flag_0measured_1gapfilled),
                           relhum_qf =  qf_percent(RH_quality_flag_0measured_1gapfilled),
                           #
                           t_gaps=gaps_count(Air_temperature_at_17m_height_degC),
                           p_gaps = gaps_count(Precipitation_mm_includes_snow),
                           relhum_gaps = gaps_count(Relative_humidity),
                           airpress_gaps = gaps_count(Atmospheric_pressure_hPa),
                           rad_gaps = gaps_count(Global_shortwave_radiation_Wm2),
                           wind_gaps = gaps_count(Wind_speed_at_34m_ms))

Hyytiala.meteo.new <-subset(Hyytiala.meteo.new, !duplicated(Date))


variables <- c("tmean_degC", "tmax_degC", "tmin_degC","p_mm","relhum_percent",
               "rad_Jcm2day", "wind_ms", "airpress_hPA", "tmax_qf","tmin_qf",
               "tmean_qf",
               "relhum_qf")
for (j in 1:length(variables)){
  Hyytiala.meteo.new[[variables[j]]] <- ifelse(is.infinite(Hyytiala.meteo.new[[variables[j]]]),
                                               NA,
                                               Hyytiala.meteo.new[[variables[j]]])
}




# maybe check ID. Or not needed, order is respected.
names(Hyytiala.meteo.new)
names.new <- names(Hyytiala.meteo.new)
names.new <- gsub("Year", "year", names.new)
names.new <- gsub("Month", "mo", names.new)
names.new <- gsub("Day", "day", names.new)
names(Hyytiala.meteo.new) <- names.new 

names(Hyytiala.meteo.new)

FLUX34_meteo$Hyytiala <- Hyytiala.meteo.new
rm(Hyytiala.meteo)
rm(Hyytiala.meteo.new)
# Soro
#--------------------------------------#
files <- list.files("./Flux_Level4",
                    pattern = "Soro", full.names = TRUE)
df <- read.table(files[1],sep = " ", header = TRUE)
head(df)
names(df)
# Read all of them and bind
Soro.meteo <- vector("list", length(files))
for (i in 1:length(files)){
  df <- read.table(files[i],sep = " ", header = TRUE)
  df$Year <- replicate( length(df[,1]) ,strsplit(files[i], "_")[[1]][6] )
  Soro.meteo[[i]] <- df
}
Soro.meteo <- do.call(rbind, Soro.meteo)


# Remove the -9999 so that we can calculate stats
summary(Soro.meteo)
Soro.meteo[Soro.meteo == -9999] <- NA
summary(Soro.meteo)
# Aggregated column
names(Soro.meteo)
Soro.meteo$Date <- as.Date(strptime(paste(Soro.meteo$Year,Soro.meteo$Month,
                                          Soro.meteo$Day, sep="-"),
                                    format ="%Y-%m-%d"))
length(unique(Soro.meteo$Date))
# This is the conversion
#Hyytiala.meteo
Soro.meteo.new<- ddply(Soro.meteo, .(Month, Day, Year), transform,
                       tmean_degC=mean(Ta_f, na.rm=T),
                       tmax_degC=max(Ta_f, na.rm=T),
                       tmin_degC=min(Ta_f, na.rm=T),
                       p_mm = sum(Precip, na.rm=T),
                       relhum_percent = mean(Rh, na.rm=T),
                       rad_Jcm2day = sum(Rg_f*(30*60)/10000, na.rm=T),                       
                       wind_ms = mean(WS, na.rm=T),
                       #
                       tmax_qf = qf_percent(Ta_fqc),
                       tmin_qf =   qf_percent(Ta_fqc),
                       tmean_qf =   qf_percent(Ta_fqc),
                       rad_qf =  qf_percent(Rg_fqc),
                       #
                       t_gaps=gaps_count(Ta_f),
                       p_gaps = gaps_count(Precip),
                       relhum_gaps = gaps_count(Rh),
                       rad_gaps = gaps_count(Rg_f),
                       wind_gaps = gaps_count(WS))

Soro.meteo.new <-subset(Soro.meteo.new, !duplicated(Date))


variables <- c("tmean_degC", "tmax_degC", "tmin_degC","p_mm","relhum_percent",
               "rad_Jcm2day", "wind_ms", "tmax_qf","tmin_qf", "tmean_qf",
               "rad_qf")
for (j in 1:length(variables)){
  Soro.meteo.new[[variables[j]]] <- ifelse(is.infinite(Soro.meteo.new[[variables[j]]]),
                                           NA,
                                           Soro.meteo.new[[variables[j]]])
}




# Add to the climate data
names.new <- names(Soro.meteo.new)
names.new <- gsub("Year", "year", names.new)
names.new <- gsub("Month", "mo", names.new)
names.new <- gsub("Day", "day", names.new)
names(Soro.meteo.new) <- names.new 


FLUX34_meteo$Soro <- Soro.meteo.new
rm(Soro.meteo)
rm(Soro.meteo.new)

# LeBray
#--------------------------------------#
files <- list.files("./Flux_Level4",
                    pattern = "LeBray", full.names = TRUE)
df <- read.table(files[1],sep = " ", header = TRUE)
head(df)
names(df)
# Read all of them and bind
LeBray.meteo <- vector("list", length(files))
for (i in 1:length(files)){
  df <- read.table(files[i],sep = " ", header = TRUE)
  df$Year <- replicate( length(df[,1]) ,strsplit(files[i], "_")[[1]][6] )
  LeBray.meteo[[i]] <- df
}
LeBray.meteo <- do.call(rbind, LeBray.meteo)

# Remove the -9999 so that we can calculate stats
summary(LeBray.meteo)
LeBray.meteo[LeBray.meteo == -9999] <- NA
summary(LeBray.meteo)
# Aggregated column
names(LeBray.meteo)
LeBray.meteo$Date <- as.Date(strptime(paste(LeBray.meteo$Year,LeBray.meteo$Month,
                                            LeBray.meteo$Day, sep="-"),
                                      format ="%Y-%m-%d"))
length(unique(LeBray.meteo$Date))
# This is the conversion
#Hyytiala.meteo
LeBray.meteo.new<- ddply(LeBray.meteo, .(Month, Day, Year), transform,
                         tmean_degC=mean(Ta_f, na.rm=T),
                         tmax_degC=max(Ta_f, na.rm=T),
                         tmin_degC=min(Ta_f, na.rm=T),
                         p_mm = sum(Precip, na.rm=T),
                         relhum_percent = mean(Rh, na.rm=T),
                         rad_Jcm2day = sum(Rg_f*(30*60)/10000, na.rm=T),
                         wind_ms = mean(WS, na.rm=T),
                         #
                         tmax_qf = qf_percent(Ta_fqc),
                         tmin_qf =   qf_percent(Ta_fqc),
                         tmean_qf =   qf_percent(Ta_fqc),
                         rad_qf =  qf_percent(Rg_fqc),
                         relhum_qf = qf_percent(Rh),
                         #
                         t_gaps=gaps_count(Ta_f),
                         p_gaps = gaps_count(Precip),
                         relhum_gaps = gaps_count(Rh),
                         rad_gaps = gaps_count(Rg_f),
                         wind_gaps = gaps_count(WS))

LeBray.meteo.new <-subset(LeBray.meteo.new, !duplicated(Date))


variables <- c("tmean_degC", "tmax_degC", "tmin_degC","p_mm","relhum_percent",
               "rad_Jcm2day", "wind_ms", "tmax_qf","tmin_qf", "tmean_qf",
               "rad_qf")
for (j in 1:length(variables)){
  LeBray.meteo.new[[variables[j]]] <- ifelse(is.infinite(LeBray.meteo.new[[variables[j]]]),
                                             NA,
                                             LeBray.meteo.new[[variables[j]]])
}


names(LeBray.meteo.new)
names.new <- names(LeBray.meteo.new)
names.new <- gsub("Year", "year", names.new)
names.new <- gsub("Month", "mo", names.new)
names.new <- gsub("Day", "day", names.new)
names(LeBray.meteo.new) <- names.new 
# Add to the climate data
FLUX34_meteo$LeBray <- LeBray.meteo.new
rm(LeBray.meteo)
rm(LeBray.meteo.new)

# Puechabon
#--------------------------------------#
files <- list.files("./Flux_Level4",
                    pattern = "Puechabon", full.names = TRUE)
df <- read.table(files[1],sep = " ", header = TRUE)
head(df)
names(df)
# Read all of them and bind
Puechabon.meteo <- vector("list", length(files))
for (i in 1:length(files)){
  df <- read.table(files[i],sep = " ", header = TRUE)
  df$Year <- replicate( length(df[,1]) ,strsplit(files[i], "_")[[1]][6] )
  Puechabon.meteo[[i]] <- df
}
Puechabon.meteo <- do.call(rbind, Puechabon.meteo)

# Remove the -9999 so that we can calculate stats
summary(Puechabon.meteo)
Puechabon.meteo[Puechabon.meteo == -9999] <- NA
summary(Puechabon.meteo)
# Aggregated column
names(Puechabon.meteo)
Puechabon.meteo$Date <- as.Date(strptime(paste(Puechabon.meteo$Year,Puechabon.meteo$Month,
                                               Puechabon.meteo$Day, sep="-"),
                                         format ="%Y-%m-%d"))
length(unique(Puechabon.meteo$Date))
# This is the conversion
#Hyytiala.meteo
Puechabon.meteo.new<- ddply(Puechabon.meteo, .(Month, Day, Year), transform,
                            tmean_degC=mean(Ta_f, na.rm=T),
                            tmax_degC=max(Ta_f, na.rm=T),
                            tmin_degC=min(Ta_f, na.rm=T),
                            p_mm = sum(Precip, na.rm=T),
                            relhum_percent = mean(Rh, na.rm=T),
                            rad_Jcm2day = sum(Rg_f*(30*60)/10000, na.rm=T),
                            wind_ms = mean(WS, na.rm=T),
                            tmax_qf = qf_percent(Ta_fqc),
                            tmin_qf =   qf_percent(Ta_fqc),
                            tmean_qf =   qf_percent(Ta_fqc),
                            rad_qf =  qf_percent(Rg_fqc),
                            t_gaps=gaps_count(Ta_f),
                            p_gaps = gaps_count(Precip),
                            relhum_gaps = gaps_count(Rh),
                            rad_gaps = gaps_count(Rg_f),
                            wind_gaps = gaps_count(WS))

Puechabon.meteo.new <-subset(Puechabon.meteo.new, !duplicated(Date))



variables <- c("tmean_degC", "tmax_degC", "tmin_degC","p_mm","relhum_percent",
               "rad_Jcm2day", "wind_ms", "tmax_qf","tmin_qf", "tmean_qf",
               "rad_qf")
for (j in 1:length(variables)){
  Puechabon.meteo.new[[variables[j]]] <- ifelse(is.infinite(Puechabon.meteo.new[[variables[j]]]),
                                                NA,
                                                Puechabon.meteo.new[[variables[j]]])
}




names(FLUX34_meteo$Kroof)
names(Puechabon.meteo.new)
names(Puechabon.meteo.new)
names.new <- names(Puechabon.meteo.new)
names.new <- gsub("Year", "year", names.new)
names.new <- gsub("Month", "mo", names.new)
names.new <- gsub("Day", "day", names.new)
names(Puechabon.meteo.new) <- names.new 
# Add to the climate data
FLUX34_meteo$Puechabon <- Puechabon.meteo.new
rm(Puechabon.meteo)
rm(Puechabon.meteo.new)



save(FLUX34_meteo, file = "./RData/FLUX34_meteo.RData")

### Check data
load("./RData/FLUX34_meteo.RData")

for (i in 1:length(FLUX34_meteo)){
  FLUX34_meteo[[i]]$relhum_percent  <- ifelse(FLUX34_meteo[[i]]$relhum_percent > 100, 100,
         ifelse(FLUX34_meteo[[i]]$relhum_percent < 0, 0, FLUX34_meteo[[i]]$relhum_percent))
}
save(FLUX34_meteo, file = "./RData/FLUX34_meteo.RData")

str(FLUX34_meteo,1)

#sink("./RData/FLUX34_meteo.txt")
#str(FLUX34_meteo)
#sink()
