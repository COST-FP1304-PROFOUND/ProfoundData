load("ProfoundOtherData.new.RData")
sp <- read.table("species.txt", header=T, sep=",")

### Hyytiala ####
ProfoundOtherData.new$Hyytiala$StandData$species

### I assume that "pine" is "Pinus sylvestris"
ProfoundOtherData.new$Hyytiala$StandData$species <- replace(ProfoundOtherData.new$Hyytiala$StandData$species, ProfoundOtherData.new$Hyytiala$StandData$species=="pine", "pisy")

ProfoundOtherData.new$Hyytiala$StandData$species <- replace(ProfoundOtherData.new$Hyytiala$StandData$species, ProfoundOtherData.new$Hyytiala$StandData$species=="spruce", "piab")

ProfoundOtherData.new$Hyytiala$StandData$species <- replace(ProfoundOtherData.new$Hyytiala$StandData$species, ProfoundOtherData.new$Hyytiala$StandData$species=="hardwood", "hawo")

ProfoundOtherData.new$Hyytiala$TreeData

### Peitz ####
table(ProfoundOtherData.new$Peitz$TreeData$species)
# -> ok

### Solling304 ####
names(ProfoundOtherData.new$Solling304$TreeData)
table(ProfoundOtherData.new$Solling304$TreeData$species)

ProfoundOtherData.new$Solling304$TreeData$species <- replace(ProfoundOtherData.new$Solling304$TreeData$species, ProfoundOtherData.new$Solling304$TreeData$species==20, "fasy")

### 118 ?