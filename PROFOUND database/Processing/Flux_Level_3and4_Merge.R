#------------------------------------------------------------------------------#
#                               FLUX DATA LEVEL 3 AND 4
#------------------------------------------------------------------------------#
# This script merges both datasets.
# Duplicated variables are dropped.
# Flux Data Level 4: Variables
#   Ta - air temperature
#   Ts - soil temperature
#   SWC - soil water content, soil moisture (Ms)
#   Rh - relative air humidity (rH)
#   VPD - vapour pressure deficit
#   Precip - precipitation (Pre, P)
#   ustar - friction velocity of the wind (u*)
#   WS - wind speed (u)
#   WD - wind direction
#   Rg - global radiation (GR)
#   PPFD - photosynthetic photon flux density, photosynthetically active radiation (PAR, FAR)
#   R_pot - potencial radiation, extraterestrial radiation (Rext)
#   Rn - net radiation
#   Rr - reflected radiation
#   Rd - diffuse dariation
#   APAR - light interception
#   G - ground heat flux
#   Pa - air pressure (sometimes also P, which is a bit confusing)
#   CO2 - concentration of CO2
#   H2O - concentration of H2O
#   NEE - net ecosystem exchange, CO2 flux (fCO2)
#   Reco - ecosystem respiration
#   GPP - gross primary production
#   LE - latent heat flux, latent energy (LH)
#   H - sensible heat flux
#   + all quality flags (quality codes). Usually variables with prefix or suffix of qc or qf.
#
#
#------------------------------------------------------------------------------#
# Where to stoer all output files
outDir = "/home/trashtos/ownCloud/PROFOUND_Data/Processed/Flux_Level4"
#------------------------------------------------------------------------------#
#                           Dennmark: Soro
#------------------------------------------------------------------------------#
inDir <- "/home/trashtos/ownCloud/PROFOUND_Data/Denmark"
# The other levels
files <- list.files(inDir, pattern ="*.zip", full.names=TRUE)

# Level 4
l4Files <- files[grepl("L4", files )]
# unzip files
unzippedl4Files <- unlist(lapply(l4Files, unzip))
# get the txt files () can do matrix, up to you.)
l4Files <- unzippedl4Files[grepl("*.txt", unzippedl4Files )]
# select by time step
l4Files.hour = l4Files[grepl("_h_", l4Files )]

# Level 3
l3Files <- files[grepl("L3", files )]
# unzip files
unzippedl3Files <- unlist(lapply(l3Files, unzip))
# get the txt files () can do matrix, up to you.)
l3Files =unzippedl3Files[grepl("*.txt", unzippedl3Files)]

# Merge
for (i in 1:length(l4Files.hour)){
  cat(paste("\nLooking for L3 corresponding to", l4Files.hour[i], "\n", sep=" "))
  for (j in 1:length(l3Files)){
    if (grepl(strsplit(l3Files[j], "_")[[1]][5], strsplit(l4Files.hour[i], "_")[[1]][6])){
      cat("      Found file!!\n")
      cat(l3Files[j])
      tables <- list(read.table(l4Files.hour[i], sep = ",", header = TRUE, colClasses = "numeric"),read.table(l3Files[j], sep = ",", header = TRUE, colClasses = "numeric"))
      merged_table <- merge(tables[1], tables[2], by=c("DoY", "DoY"), suffixes = c("", "_L3"))
      merged_table <-merged_table[!grepl("L3", names(merged_table))]
      outname = paste("Soro_CEIP_EC_L4+L3", strsplit(l4Files.hour[i], "_")[[1]][6], strsplit(l4Files.hour[i], "_")[[1]][7], sep="_")
      write.table(merged_table, file.path(outDir, outname), sep = " ", dec = ".", row.names = FALSE)
    }
  }
}
# Clean up
do.call ("file.remove", list(unzippedl4Files))
do.call ("file.remove", list(unzippedl3Files))
#------------------------------------------------------------------------------#
#                       France
#------------------------------------------------------------------------------#
inDir <- "/home/trashtos/ownCloud/PROFOUND_Data/France"
subDir <- list.files(inDir,  full.names=TRUE)
#------------------------------------------------------------------------------#
#                       France:LeBray
#------------------------------------------------------------------------------#
files <- list.files(subDir[grepl("bray", subDir )], pattern="zip", full.names=TRUE)

l4Files <- files[grepl("L4", files )]
# unzip files
unzippedl4Files <- unlist(lapply(l4Files, unzip))
# get the txt files () can do matrix, up to you.)
l4Files <- unzippedl4Files[grepl("*.txt", unzippedl4Files )]
# select by time step
l4Files.hour <- l4Files[grepl("_h_", l4Files )]

l3Files =files[grepl("L3", files )]
# unzip files
unzippedl3Files <- unlist(lapply(l3Files, unzip))
# get the txt files () can do matrix, up to you.)
l3Files =unzippedl3Files[grepl("*.txt", unzippedl3Files)]

for (i in 1:length(l4Files.hour)){
  cat(paste("\nLooking for L3 corresponding to", l4Files.hour[i], "\n", sep=" "))
  for (j in 1:length(l3Files)){
    if (grepl(strsplit(l3Files[j], "_")[[1]][5], strsplit(l4Files.hour[i], "_")[[1]][6])){
      cat("      Found file!!\n")
      cat(l3Files[j])
      tables <- list(read.table(l4Files.hour[i], sep = ",", header = TRUE, colClasses = "numeric"),read.table(l3Files[j], sep = ",", header = TRUE, colClasses = "numeric"))
      merged_table <- merge(tables[1], tables[2], by=c("DoY", "DoY"), suffixes = c("", "_L3"))
      merged_table <-merged_table[!grepl("L3", names(merged_table))]
      outname = paste("LeBray_CEIP_EC_L4+L3", strsplit(l4Files.hour[i], "_")[[1]][6], strsplit(l4Files.hour[i], "_")[[1]][7], sep="_")
      write.table(merged_table, file.path(outDir, outname), sep = " ", dec = ".", row.names = FALSE)
    }
  }
}
# Clean up
do.call ("file.remove", list(unzippedl4Files))
do.call ("file.remove", list(unzippedl3Files))

#------------------------------------------------------------------------------#
#                       France: Puechabon
#------------------------------------------------------------------------------#
files <- list.files(subDir[grepl("Pue", subDir )],pattern="zip", full.names=TRUE)

l4Files <- files[grepl("L4", files )]
# unzip files
unzippedl4Files <- unlist(lapply(l4Files, unzip))
# get the txt files () can do matrix, up to you.)
l4Files <- unzippedl4Files[grepl("*.txt", unzippedl4Files )]
# select by time step
l4Files.hour <- l4Files[grepl("_h_", l4Files )]

l3Files <- files[grepl("L3", files )]
# unzip files
unzippedl3Files <- unlist(lapply(l3Files, unzip))
# get the txt files () can do matrix, up to you.)
l3Files  <- unzippedl3Files[grepl("*.txt", unzippedl3Files)]

for (i in 1:length(l4Files.hour)){
  cat(paste("\nLooking for L3 corresponding to", l4Files.hour[i], "\n", sep=" "))
  for (j in 1:length(l3Files)){
    if (grepl(strsplit(l3Files[j], "_")[[1]][5], strsplit(l4Files.hour[i], "_")[[1]][6])){
      cat("      Found file!!\n")
      cat(l3Files[j])
      tables <- list(read.table(l4Files.hour[i], sep = ",", header = TRUE, colClasses = "numeric"),read.table(l3Files[j], sep = ",", header = TRUE, colClasses = "numeric"))
      merged_table <- merge(tables[1], tables[2], by=c("DoY", "DoY"), suffixes = c("", "_L3"))
      merged_table <-merged_table[!grepl("L3", names(merged_table))]
      outname <- paste("Puechabon_CEIP_EC_L4+L3", strsplit(l4Files.hour[i], "_")[[1]][6], strsplit(l4Files.hour[i], "_")[[1]][7], sep="_")
      write.table(merged_table, file.path(outDir, outname), sep = " ", dec = ".", row.names = FALSE)
    }
  }
}

do.call ("file.remove", list(unzippedl4Files))
do.call ("file.remove", list(unzippedl3Files))

#------------------------------------------------------------------------------#


