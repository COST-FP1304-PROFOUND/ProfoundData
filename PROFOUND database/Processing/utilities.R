##########################################################
# Utility functions for processing Profound Data
#     1. Read xlsx books
#     2. Rbind for data with different rownames
#     3. A %!in% function
#     4. Find unique variables in datasets
#
##########################################################

# 1. Read xlsx books
read.XLSX <- function(filename){
  require(XLConnect)
  wb <- loadWorkbook(filename)
  numberSheets <- getSheets(wb)
  xlsxList <- readWorksheet(wb, sheet = numberSheets)
  return(xlsxList)
}

# 2. Rbind for data with different rownames
rbind.match.columns <- function(input1, input2) {
  # http://www.r-bloggers.com/combining-dataframes-when-the-columns-dont-match/
  n.input1 <- ncol(input1)
  n.input2 <- ncol(input2)

  if (n.input2 < n.input1) {
    TF.names <- which(names(input2) %in% names(input1))
    column.names <- names(input2[, TF.names])
  } else {
    TF.names <- which(names(input1) %in% names(input2))
    column.names <- names(input1[, TF.names])
  }

  return(rbind(input1[, column.names], input2[, column.names]))
}

# 3 To bind same and differnt columns
rbind.all <- function(a, b){
  names.a <- colnames(a)
  names.b <- colnames(b)
  names.both <- unique(c(names.a, names.b))

  for ( i in 1:length(names.both)){
    if(!names.both[i] %in% names.a){a[[names.both[i]]]<- NA }
    if(!names.both[i] %in% names.b){b[[names.both[i]]]<- NA }
  }
  binded <- rbind(a, b)
  return(binded)
}

# 4. A %!in% function
'%!in%' <- function(x,y)!('%in%'(x,y))

# 4. Find unique variables in datasets
findVariables <- function(listDataFiles){
  variablesAll <- vector("list", length(listDataFiles))
  for (i  in 1:length(listDataFiles)){
    table <- read.table(listDataFiles[i], sep = ",", header = TRUE, nrows=1)
    variablesAll[[i]] <- names(table)
  }
 return(unique(unlist(variablesAll)) )
}


# 5. Replace NULL by NAs
nullToNA <- function(x) {
  x[sapply(x, is.null)] <- NA
  return(x)
}

# Ratio DBH  Height
doHDR <- function(df){(df$height1_m*100)/df$dbh1_cm}

# 7. Remove overlapping information tree and stand
dropDuplicates <- function(stand, tree){
  variables.stand <- c("dbh_cm", "height_m")
  variables.tree <- c("dbh1_cm", "height1_m")
  stand$year <- as.numeric(stand$year)
  tree$year <- as.numeric(tree$year)
  tree$species_id <- as.character(tree$species_id)
  spp <- unique(as.character(stand$species_id))


  for (k in 1:length(spp)){
    years.stand <- stand[stand$species_id==spp[k],]$year
    years.tree <- unique(tree[tree$species_id==spp[k],]$year)

    for (i in 1:length(years.stand)){
      if (years.stand[i] %in% years.tree){
        # drop variables that should not be there
        # check if variables are present, and drop them
        dummy.tree <- tree[tree$year==years.stand[i] & tree$species_id==spp[k], ]
        keep <- rep(FALSE, length(variables.tree))
        for (j in 1:length(variables.tree)){
          if (variables.tree[j] %in% names(tree) & variables.stand[j] %in% names(stand)){
            if (!all(is.na(dummy.tree[[variables.tree[j]]]))) stand[stand$year== years.stand[i] & stand$species_id==spp[k],][[variables.stand[j]]] <- NA
          }
        }
      }
    }
  }
  columns <- c("age", "foliageBiomass_kgha",
               "branchesBiomass_kgha", "stemBiomass_kgha", "rootBiomass_kgha",
               "stumpCoarseRootBiomass_kgha", "coarseBiomass_kgha", "LAI", "height_m",
               "aboveGroundBiomass_kgha", "dbh_cm", "density_treeha", "stem" )
  stand.data <- stand[,colnames(stand) %in% columns]
  # remove rows with all NAs
  stand <- stand[rowSums(is.na(stand.data))<ncol(stand.data), ]
  stand <- stand[,colSums(is.na(stand))<nrow(stand)]
  return(stand)
}

# Merge STAND with STAND from TREE
combineSTAND <- function(stand, standFromTree){
  stand$dummy <- paste(stand$year, as.character(stand$species_id), sep="_")
  standFromTree$dummy <- paste(standFromTree$year, as.character(standFromTree$species_id), sep="_")
  tmp <- merge(stand, standFromTree, by = c("dummy", "dummy"), all = T,suffixes = c("", "_drop"))
  dropVariables <- colnames(tmp)[grepl("_drop", colnames(tmp))]
  tmp$species_id <- as.character(tmp$species_id)
  tmp$species_id_drop <- as.character(tmp$species_id)
  for (i in 1:length(dropVariables)){
    theVariable <- gsub("_drop", "", dropVariables[i])
    if (theVariable %in%  colnames(tmp))  tmp[[theVariable]] <- ifelse(is.na(tmp[[theVariable]]), tmp[[dropVariables[i]]], tmp[[theVariable]])
  }
  tmp <- tmp[, colnames(tmp)[!grepl("_drop", colnames(tmp))]]
  #tmp$year <- gusb("_*", "", tmp$dummy)
  tmp$dummy <- NULL
  return(tmp)
}
  

# Convert tree data in stand data
summarizePROFOUND.TREE <-function(data, by = "years"){
  TREEtoSTAND <- function(subData){
    site <- unique(as.character(subData$site))
    site_id <-unique(subData$site_id)
    year <-unique(subData$year)
    age <- mean(subData$age, na.rm = T)
    species <-unique(as.character(subData$species))
    species_id <-unique(as.character(subData$species_id))
    size_m2 <- unique(subData$size_m2)
    density_treeha <-  length(subData$dbh1_cm)*(10000 / size_m2)
    dbhDQ_cm <-  meanSquaredDiameter(subData$dbh1_cm)
    dbhArith_cm <- mean(subData$dbh1_cm, na.rm = T)
    dbhBA_cm <- LoreysMeanDBH(subData$dbh1_cm)
    heightBA_m <- LoreysMeanHeight(subData$height1_m, subData$dbh1_cm)
    heightArith_m <- mean(subData$height1_m, na.rm = T)
    ba_m2ha <- standBA(subData$dbh1_cm, subData$size_m2)
    subSummary <- cbind(site, site_id, year, age, species, species_id, size_m2, density_treeha,
                        dbhDQ_cm, dbhArith_cm, dbhBA_cm, heightArith_m, heightBA_m,
                        ba_m2ha )
    return(subSummary)
  }
  data$foo <- paste(data$year, data$species_id, sep = "_")
  foobar <- unique(data$foo)
  summaryObject <- lapply(1:length(foobar), function(x){
    subData <- data[data$foo == foobar[x], ]
    subData <- TREEtoSTAND(subData)
    return(subData)
  })
  summaryObject <- as.data.frame(Reduce(f = function(...)rbind(...),x = summaryObject))
  columns <- !colnames(summaryObject) %in% c("site",  "species", "species_id")
  summaryObject[,columns] <- apply(summaryObject[,columns], 2, function(x) as.numeric(as.character(x)))
  columns <- colnames(summaryObject) %in% c("site",  "species", "species_id")
  summaryObject[,columns] <- apply(summaryObject[,columns], 2, function(x) as.character(x))
  rownames(summaryObject) <- NULL
  return(summaryObject)
}



meanSquaredDiameter <- function(dbh){
  if(length(dbh[!is.na(dbh)])==0){
    dq_cm <- NA
  }else{
    dq_cm <- sqrt(sum(dbh**2, na.rm = T)/length(dbh[!is.na(dbh)]))
  }
  return(dq_cm)
}

meanSquaredDiameter100 <- function(dbh){
  if(length(dbh[!is.na(dbh)])==0){
    dq_cm <- NA
  }else{
    dbh <- dbh[order(dbh, decreasing = T)]
    if (length(dbh)>= 100){
      dbh <- dbh[1:100]
    }
    dq_cm <- sqrt(sum(dbh**2, na.rm = T)/length(dbh[!is.na(dbh)]))
  }
  return(dq_cm)
}
meanDiameter100 <- function(dbh){
  if(length(dbh[!is.na(dbh)])==0){
    dq_cm <- NA
  }else{
    dbh <- dbh[order(dbh, decreasing = T)]
    if (length(dbh)>= 100){
      dbh <- dbh[1:100]
    }
    dbh_cm <- mean(dbh, na.rm = T)
  }
  return(dbh_cm)
}

# mean squared height--> Lorey's mean height weights
LoreysMeanDBH100  <- function(dbh){
  dbh <- dbh[order(dbh, decreasing = T)]
  if (length(dbh)>= 100){
    dbh <- dbh[1:100]
  }
  ba_cm2 <- sapply(dbh, function(x){pi * (x/2)**2})
  dbh_cm <- sum((ba_cm2 * dbh), na.rm = T)/sum(ba_cm2, na.rm = T)
  #height_m <- sqrt(sum(height**2, na.rm = T)/length(height[!is.na(height)]))
  return(dbh_cm)
}

LoreysMeanDBH <- function(dbh){
  ba_cm2 <- sapply(dbh, function(x){pi * (x/2)**2})
  dbh_cm <- sum((ba_cm2 * dbh), na.rm = T)/sum(ba_cm2, na.rm = T)
  #height_m <- sqrt(sum(height**2, na.rm = T)/length(height[!is.na(height)]))
  return(dbh_cm)
}

# mean squared height--> Lorey's mean height weights
LoreysMeanHeight100  <- function(height, dbh){
  if(length(height[!is.na(height)])==0){
    height_m <- NA
  }else{
    dbh <- dbh[order(dbh, decreasing = T)]
    height <- height[order(dbh, decreasing = T)]
    if (length(dbh)>= 100){
      dbh <- dbh[1:100]
      height <- height[1:100]
    }
    
    ba_m2 <- sapply(dbh/100, function(x){pi * (x/2)**2})
    ba_m2 <- ba_m2[!is.na(height)]
    height <- height[!is.na(height)]
    height_m <- sum((ba_m2 * height), na.rm = T)/sum(ba_m2, na.rm = T)
    #height_m <- sqrt(sum(height**2, na.rm = T)/length(height[!is.na(height)]))
  }
  return(height_m)
}

LoreysMeanHeight <- function(height, dbh){
  if(length(height[!is.na(height)])==0){
    height_m <- NA
  }else{
    ba_m2 <- sapply(dbh/100, function(x){pi * (x/2)**2})
    ba_m2 <- ba_m2[!is.na(height)]
    height <- height[!is.na(height)]
    height_m <- sum((ba_m2 * height), na.rm = T)/sum(ba_m2, na.rm = T)
    #height_m <- sqrt(sum(height**2, na.rm = T)/length(height[!is.na(height)]))
  }
  return(height_m)
}

meanHeight100 <- function(dbh, height){
  if(length(dbh[!is.na(dbh)])==0){
    dq_cm <- NA
  }else{
    dbh <- dbh[order(dbh, decreasing = T)]
    height <- height[order(dbh, decreasing = T)]
    if (length(dbh)>= 100){
      dbh <- dbh[1:100]
      height <- height[1:100]
    }
    height <- mean(height, na.rm = T)
  }
  return(height)
}



#The height of the average tree may be measured.
meanSquaredHeight <- function(height, dbh){
  if(length(height[!is.na(height)])==0){
    height_m <- NA
  }else{
    meanDBH <- meanSquaredDiameter(dbh)
    dbh <- dbh[!is.na(height)]
    height <- height[!is.na(height)]
    height_m <- height[which.min(abs(dbh - meanDBH))]
  }
  
  return(height_m)
}

meanSquaredHeight100 <- function(height, dbh){
  if(length(height[!is.na(height)])==0){
    height_m <- NA
  }else{
    dbh <- dbh[order(dbh, decreasing = T)]
    height <- height[order(dbh, decreasing = T)]
    if (length(dbh)>= 100){
      dbh <- dbh[1:100]
      height <- height[1:100]
    }
    if(length(height[!is.na(height)])==0){
      height_m <- NA
    }else{
      meanDBH <- meanSquaredDiameter(dbh)
      dbh <- dbh[!is.na(height)]
      height <- height[!is.na(height)]
      height_m <- height[which.min(abs(dbh - meanDBH))]
    }
  }
  return(height_m)
}

# basal area of stand
standBA <- function(dbh, plotSize){
  if(length(dbh[!is.na(dbh)])==0){
    ba_m2ha <- NA
  }else{
    ba_m2 <- sapply(dbh/100, function(x){pi * (x/2)**2})
    A_ha <-  unique(plotSize)* (1/10000)
    ba_m2ha <- sum(ba_m2, na.rm = T) / A_ha
  }
  return(ba_m2ha)
}



# calculate height
# Logarithmic y = 10.745ln(x) - 13.095Collelongo Works!!
calcHeiht.log <- function(dbh, a =1, b=1){
  height <- a + b*log(dbh)
  return(height)
}
# Petterson KRoof
calcHeiht.peterson <- function(dbh, a =1, b=1){
  height <- 1.3 + (dbh/(a + b*dbh))**3
  return(height)
}
# Michailoff  Peitz
calcHeiht.michailoff  <- function(dbh, a =1, b=1){
  height <- 1.3 + a*exp(b/dbh)
  return(height)
}

# Oliveira cited from Gadow &   Bredenkamp
calcHeiht.oliveira  <- function(dbh, a =1, b=1){
  height <- exp(a + b/dbh)
  return(height)
}


