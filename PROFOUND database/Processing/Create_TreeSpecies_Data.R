#------------------------------------------------------------------------------#
#                               SPECIES TREE DATA
#------------------------------------------------------------------------------#
# Single Tree Data is available for:
#       Kroof
#       Peitz
#       Solling
#       Hyytiala
#       Soro
#       BilyKriz
# It must be derived for:


tree_file <- "./tree_species.txt"
TreeSpecies_Data <- read.table(tree_file, header=T, sep="\t")
# description says height and dbh in  m. Dbh it is in cm!!!

str(TreeSpecies_Data)
TreeSpecies_Data$species <- as.character(TreeSpecies_Data$species)
TreeSpecies_Data$species_id <- as.character(TreeSpecies_Data$species_id)

save(TreeSpecies_Data, file="./RData/TreeSpecies_Data.RData")

#
