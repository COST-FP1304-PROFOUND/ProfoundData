#------------------------------------------------------------------------------#
#                 CLIMATE DATA ADDITIONAL: Analysis Soro differents sources
#------------------------------------------------------------------------------#
myDir <- "~/ownCloud/PROFOUND_Data/Processed/"
setwd(myDir)
# Soro has p_mm data that is wrong: years 2011, 2012
load("./RData/FLUXNET_Climate.RData")
Soro <- FLUXNET_Climate$Soro[,c("year", "mo", "day", "p_mm", "p_qf")]
head(Soro)
SoroYear <- aggregate(p_mm ~ year, data = Soro, sum)
plot(SoroYear)
abline(h = median(SoroYear$p_mm), col = "red")
# Use new data from Andreas
load("./Soro/Soroe_daily_precipitation_1996_2016.RData")
cat(Soroe_daily_precipitation_1996_2016.df.des)
head(Soroe_daily_precipitation_1996_2016.df)
df <-Soroe_daily_precipitation_1996_2016.df[, c("year", "day", "month", "Precip_Soroe", "Precip_DMI_10x10",  "Precip_EOBS_25x25_120_207")]
df[is.na(df)] <- 0
SoroNewYear <- aggregate(. ~ year, data = df, sum)

rangeYear <- range(c(SoroNewYear$year, SoroYear$year), na.rm = T)
plot(SoroYear, xlim = rangeYear, ylim = c(0, 2000), pch = 1, main ="Soro yearly p_mm: different sources")
#points(SoroYear, xlim = rangeYear, ylim = c(0, 2000),  main ="Soro yearly p_mm: different sources")
abline(h = mean(SoroYear[SoroYear$year<2011,]$p_mm), col = "red")
points(SoroNewYear$year, SoroNewYear$Precip_Soroe, pch = 3)
points(SoroNewYear$year, SoroNewYear$Precip_DMI_10x10, pch = 4)
points(SoroNewYear$year, SoroNewYear$Precip_EOBS_25x25_120_207, pch = 5)
legend("topleft",legend = c("FLUXNET", "Precip_Soroe", "DMI_10x10", "EOBS_25x25" ),
       pch = c(1,3,4,5))
legend("topright",legend = "mean p_mm FLUXNET (year < 2011)", col = "red", lty = 1)
# What to do!

# Compare data
df <-Soroe_daily_precipitation_1996_2016.df[, c("year", "day", "month", "Precip_Soroe", "Precip_DMI_10x10",  "Precip_EOBS_25x25_120_207")]
subsetFluxnet <-Soro[Soro$year > 2010,]
subsetFluxnet$date <- as.Date(paste(subsetFluxnet$year, subsetFluxnet$mo, subsetFluxnet$day, sep="-"))
subsetdf <- df[df$year > 2010 & df$year < 2013,]
subsetdf$date <- as.Date(paste(subsetdf$year, subsetdf$month, subsetdf$day, sep="-"))
subsetPrecSoroe <-subsetdf[, c("date", "year", "day", "month", "Precip_Soroe")]
subsetPrecSoroeGAPS <- subsetPrecSoroe
subsetPrecSoroeGAPS[is.na(subsetPrecSoroeGAPS)] <- - 9
subsetPrecDMI_10x10 <-subsetdf[, c("date","year", "day", "month", "Precip_DMI_10x10")]
subsetPrecDMI_10x10GAPS <- subsetPrecDMI_10x10
subsetPrecDMI_10x10GAPS[is.na(subsetPrecDMI_10x10GAPS)] <- - 9


bad <- subsetFluxnet$p_qf < 1
good <- subsetFluxnet$p_qf == 1


plot(subsetPrecDMI_10x10GAPS$Precip_DMI_10x10, subsetPrecSoroeGAPS$Precip_Soroe, pch = 4,  ylim = c(-9,120), xlim = c(-9,120),
     xlab = "Precip_Soroe (mm)", ylab = "Precip_DMI 10x10 (mm)", main = " Precip_Soroe against Precip_DMI_10x10")
mtext(side = 3, cex = 0.75, text = "Gaps are set to value -9")

plot(subsetFluxnet$p_mm[good], subsetPrecSoroeGAPS$Precip_Soroe[good], pch = 4,  ylim = c(-9,120), xlim = c(-9,120),
     xlab = "p_mm FLUXNET", ylab = "Precip_Soroe (mm)", main = " Precip_Soroe against p_mm FLUXNET")
points(subsetFluxnet$p_mm[bad], subsetPrecSoroeGAPS$Precip_Soroe[bad], pch = 4, col="red")
mtext(side = 3, cex = 0.75, text = "Gaps are set to value -9")
legend("topright",title = "FLUXNET quality", legend = c("High quality = 1", "Bad quality < 1"), pch=4, col= c("black", "red"))

plot(subsetFluxnet$p_mm[good], subsetPrecDMI_10x10GAPS$Precip_DMI_10x10[good], pch = 4,  ylim = c(-9,120), xlim = c(-9,120),
     xlab = "p_mm FLUXNET", ylab = "Precip_DMI 10x10 (mm)", main = " Precip_DMI_10x10 against p_mm FLUXNET")
points(subsetFluxnet$p_mm[bad], subsetPrecDMI_10x10GAPS$Precip_DMI_10x10[bad], pch = 4, col="red")
mtext(side = 3, cex = 0.75, text = "Gaps are set to value -9")
legend("topright",title = "FLUXNET quality", legend = c("High quality = 1", "Bad quality < 1"), pch=4, col= c("black", "red"))

plot(subsetPrecDMI_10x10GAPS$date, subsetPrecDMI_10x10GAPS$Precip_DMI_10x10, pch = 1,  ylim = c(-9,120), 
     ylab = "p (mm)", xlab = paste("Time period:", paste(range(subsetPrecDMI_10x10GAPS$date), collapse = " - ")),
     main = "p (mm) time series")
points(subsetPrecSoroeGAPS$date, subsetPrecSoroeGAPS$Precip_Soroe, pch =4)
points(subsetFluxnet$date[good], subsetFluxnet$p_mm[good], pch = 3)
points(subsetFluxnet$date[bad], subsetFluxnet$p_mm[bad], pch = 3, col="red")
mtext(side = 3, cex = 0.75, text = "Gaps are set to value -9")
legend("topright",legend = c("DMI 10x10", "precip_Soroe"," FLUXNET: High quality = 1", " FLUXNET: Bad quality < 1"),
       pch=c(1,4,3,3), col= c("black","black","black", "red"))


# The new precipitacion
newPP <- subsetdf
newPP$Precip_Soroe <- ifelse(is.na(newPP$Precip_Soroe), newPP$Precip_DMI_10x10, newPP$Precip_Soroe)
newPP[is.na(newPP)] <- - 9
plot(newPP$date, newPP$Precip_Soroe, pch = 4,  ylim = c(-9,120), 
     ylab = "p (mm)", xlab = paste("Time period:", paste(range(newPP$date), collapse = " - ")),
     main = "p (mm) time series")
points(subsetFluxnet$date[good], subsetFluxnet$p_mm[good], pch = 3)
points(subsetFluxnet$date[bad], subsetFluxnet$p_mm[bad], pch = 3, col="red")
legend("topright",legend = c("precip_Soroe gap filled"," FLUXNET: High quality = 1", " FLUXNET: Bad quality < 1"),
       pch=c(4,3,3), col= c("black","black", "red"))

plot(subsetFluxnet$p_mm[good], newPP$Precip_Soroe[good], pch = 4,  ylim = c(0,120), xlim = c(0,120),
     xlab = "p_mm FLUXNET", ylab = "Gap filled Precip_Soroe (mm)", main = " Gap filled Precip_Soroe against p_mm FLUXNET")
points(subsetFluxnet$p_mm[bad], newPP$Precip_Soroe[bad], pch = 4, col="red")
legend("topright",title = "FLUXNET quality", legend = c("High quality = 1", "Bad quality < 1"), pch=4, col= c("black", "red"))


SoroNewYear <- df[df$year < 2013,]
SoroNewYear$p_mm <- ifelse(is.na(SoroNewYear$Precip_Soroe), SoroNewYear$Precip_DMI_10x10, SoroNewYear$Precip_Soroe)
SoroNewYear <- SoroNewYear[, c("year", "p_mm", "Precip_Soroe")]
SoroNewYear[is.na(SoroNewYear)] <- 0
SoroNewYear <- aggregate(. ~ year, data = SoroNewYear, sum)
rangeYear <- range(c(SoroNewYear$year, SoroYear$year), na.rm = T)
plot(SoroYear, xlim = rangeYear, ylim = c(0, 2000), pch = 1, main ="Soro yearly p_mm: different sources")
#points(SoroYear, xlim = rangeYear, ylim = c(0, 2000),  main ="Soro yearly p_mm: different sources")
abline(h = mean(SoroYear[SoroYear$year<2011,]$p_mm), col = "red")
points(SoroNewYear$year, SoroNewYear$p_mm, pch = 3)
points(SoroNewYear$year, SoroNewYear$Precip_Soroe, pch = 4)
legend("topleft",legend = c("FLUXNET", "Precip_Soroe gap filled", "Precip_Soroe"),
       pch = c(1,3, 4))
legend("topright",legend = "mean p_mm FLUXNET (year < 2011)", col = "red", lty = 1)
# What to do!
##


# Get the data
library(ProfoundData)
myDB <- "/home/ramiro/ownCloud/PROFOUND_Data/v0.1.12/ProfoundData.sqlite"
setDB(myDB)

climateFLUXNET <- getData("CLIMATE_LOCAL", "soro", variables = "p_mm", period = c(NA, "2010-12-31"))
str(climateFLUXNET)
range(climateFLUXNET$date)
load("./Soro/Soroe_daily_precipitation_1996_2016.RData")
cat(Soroe_daily_precipitation_1996_2016.df.des)
head(Soroe_daily_precipitation_1996_2016.df)
climateSoro <-Soroe_daily_precipitation_1996_2016.df[, c("year", "day", "month", "Precip_Soroe", "Precip_DMI_10x10",  "Precip_EOBS_25x25_120_207")]
climateSoro <- climateSoro[climateSoro$year<2013,]

summayDistribution <- function(x, variable = "p_mm"){
  Mean <- mean(x[[variable]], na.rm = T)
  Median <- median(x[[variable]], na.rm = T)
  Min <- min(x[[variable]], na.rm = T)
  Max <- max(x[[variable]], na.rm = T)
  Var <- var(x[[variable]], na.rm = T)
  Sd <- sd(x[[variable]], na.rm = T)
  return(cbind(Mean, Median,Min, Max, Var, Sd))
}

plotDensity <- function(x, variable = "p_mm"){
  hist(x[[variable]],freq = F,
       breaks = max(x[[variable]], na.rm = T)/5, 
       xlab = variable, ylab = 'Probability',
       main = paste('Histogram of', variable ,'with Kernel Density Plot'))
  lines(density(x[[variable]], na.rm = T, from = 0, to = max(x[[variable]], na.rm = T)))
}

knitr::kable(summayDistribution(climateFLUXNET))
plotDensity(climateFLUXNET)

knitr::kable(summayDistribution(climateSoro, "Precip_Soroe"))
plotDensity(climateSoro, variable = "Precip_Soroe")

knitr::kable(summayDistribution(climateSoro, "Precip_DMI_10x10"))
plotDensity(climateSoro, variable = "Precip_DMI_10x10")


# Figure out the empty values
climateSoro2011 <- climateSoro[climateSoro$year == 2011,]
gaps2011 <- is.na(climateSoro2011$Precip_Soroe)
climateSoro2012 <- climateSoro[climateSoro$year == 2012,]
gaps2012 <- is.na(climateSoro2012$Precip_Soroe)
# They are not indentical, but same amount of gaps
identical(gaps2011, gaps2012)
table(gaps2012)
table(gaps2011)


# Lets mask the data using 2012 gaps
years <- unique(climateFLUXNET$year)
length(gaps2012)
mask <- sapply(years, function(x){
  days <- nrow(climateFLUXNET[climateFLUXNET$year==x,])
  if(days == 366) return(gaps2012) else return(gaps2012[-(31+29)])
})
mask <-unlist(mask)
climateSoroTo2010 <- climateSoro[climateSoro$year < 2011,]
climateFLUXNET$p_mm_gf <- climateFLUXNET$p_mm
climateFLUXNET[mask,]$p_mm_gf <-climateSoroTo2010[mask,]$Precip_DMI_10x10
knitr::kable(summayDistribution(climateFLUXNET, variable = "p_mm"))
plotDensity(climateFLUXNET, variable = "p_mm")
knitr::kable(summayDistribution(climateFLUXNET, variable = "p_mm_gf"))
plotDensity(climateFLUXNET, variable = "p_mm_gf")


# Lets mask the data using 2011 gaps
years <- unique(climateFLUXNET$year)
length(gaps2011)
mask <- sapply(years, function(x){
  days <- nrow(climateFLUXNET[climateFLUXNET$year==x,])
  if(days == 365) return(gaps2011) else return(c(gaps2011[1:(31+28)], TRUE, gaps2011[(31+29):length(gaps2011)]))
})
mask <-unlist(mask)
climateSoroTo2010 <- climateSoro[climateSoro$year < 2011,]
climateFLUXNET$p_mm_gf <- climateFLUXNET$p_mm
climateFLUXNET[mask,]$p_mm_gf <-climateSoroTo2010[mask,]$Precip_DMI_10x10
knitr::kable(summayDistribution(climateFLUXNET, variable = "p_mm"))
plotDensity(climateFLUXNET, variable = "p_mm")
knitr::kable(summayDistribution(climateFLUXNET, variable = "p_mm_gf"))
plotDensity(climateFLUXNET, variable = "p_mm_gf")


