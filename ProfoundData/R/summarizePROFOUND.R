
summarizePROFOUND.CLIMATE <- function(data, by = "total"){
  # think of having variables
  summaryCLIMATE <- function(subData){
    site <- unique(subData$site)
    site_id <-unique(subData$site_id)
    year <-unique(subData$year)
    tmax_degC <- ifelse("tmax_degC" %in% colnames(subData), mean(subData$tmax_degC, na.rm = T),NA)
    tmean_degC <- ifelse("tmean_degC" %in% colnames(subData),mean(subData$tmean_degC, na.rm = T),NA)
    tmin_degC <- ifelse("tmin_degC" %in% colnames(subData),mean(subData$tmin_degC, na.rm = T),NA)
    p_mm <- ifelse("p_mm" %in% colnames(subData),sum(subData$p_mm, na.rm = T),NA)
    relhum_percent <- ifelse("relhum_percent" %in% colnames(subData), mean(subData$relhum_percent, na.rm = T),NA)
    airpress_hPa <- ifelse("airpress_hPa" %in% colnames(subData), mean(subData$airpress_hPa, na.rm = T),NA)
    rad_Jcm2day <-  ifelse("rad_Jcm2day" %in% colnames(subData), sum(subData$rad_Jcm2day, na.rm = T),NA)
    wind_ms <-  ifelse("wind_ms" %in% colnames(subData), mean(subData$wind_ms, na.rm = T),NA)
    subSummary <- cbind(site, site_id, year, tmax_degC, tmean_degC, tmin_degC, p_mm,
                        relhum_percent, airpress_hPa, rad_Jcm2day, wind_ms)
    return(subSummary)
  }
  # Summarize
  foobar <- unique(data$year)
  summaryObject <- lapply(1:length(foobar), function(x){
    subData <- data[data$year == foobar[x], ]
    subData <- summaryCLIMATE(subData)
    return(subData)
  })
  summaryObject <- as.data.frame(Reduce(f = function(...)rbind(...),x = summaryObject))
  summaryObject[,2:ncol(summaryObject)] <- apply(summaryObject[,2:ncol(summaryObject)], 2, function(x) as.numeric(as.character(x)))

  if(by == "total"){
    summaryTotal <- summaryObject[1,]
    summaryTotal[,2:ncol(summaryTotal)] <- apply(summaryObject[,2:ncol(summaryObject)], 2, function(x) mean(x, na.rm = T))
    summaryTotal$year <- paste(range(data$year, na.rm=T), collapse = "-")
    summaryObject <- summaryTotal
  }
  row.names(summaryObject) <- NULL
  return(summaryObject)
}




summarizePROFOUND.ISIMIP <- function(data, by ="total"){
  #by <- "total"
  variables <- c("year", "tmax_degC","tmean_degC","tmin_degC","p_mm","relhum_percent","airpress_hPa","rad_Jcm2day",
                 "wind_ms")
  # or do a long table
  if ("forcingDataset" %in% names(data)){
    if ("forcingCondition" %in% names(data)){
      forcingDataset <- unique(data$forcingDataset)
      forcingCondition <- unique(data$forcingCondition)
      headers <- c("forcingDataset", "forcingCondition",variables)
      summaryISIMIP <- as.data.frame(matrix(ncol = length(headers) , nrow = length(forcingDataset)*length(forcingCondition)))
      colnames(summaryISIMIP) <- headers
      index <- 1
      if(length(forcingDataset) == 1 & length(forcingCondition) == 1){
        summaryISIMIP <-  summarizePROFOUND.CLIMATE(data, by)
      }else{
        for (i in 1:length(forcingDataset)){
          for(j in 1:length(forcingCondition)){
            df <- data[data$forcingDataset == forcingDataset[i] & data$forcingCondition == forcingCondition[j], ]
            total <- summarizePROFOUND.CLIMATE(df, by = "total")
            total <- c(forcingDataset[i], forcingCondition[j], total[, variables])
            summaryISIMIP[index, ] <- total
            index <- index + 1
          }
        }

      }
    }else{
      forcingDataset <- unique(data$forcingDataset)
      headers <- c("forcingDataset",variables)
      summaryISIMIP <- as.data.frame(matrix(ncol = length(headers) , nrow = length(forcingDataset)))
      colnames(summaryISIMIP) <- headers
      index <- 1
      if(length(forcingDataset) == 1){
        summaryISIMIP <- summarizePROFOUND.CLIMATE(data, by)
      }else{
        for (i in 1:length(forcingDataset)){
          df <- data[data$forcingDataset == forcingDataset[i], ]
          total <- summarizePROFOUND.CLIMATE(df, by = "total")
          total <- c(forcingDataset[i],  total[, variables])
          summaryISIMIP[index, ] <- total
          index <- index + 1
        }
      }
    }
  }else{
    stop("You might have found a bug! Please report it", call. = FALSE)
  }
  return(summaryISIMIP)
}

summarizePROFOUND.TREE <-function(data, by = "year"){
  TREEtoSTAND <- function(subData){
    site <- unique(subData$site)
    site_id <-unique(subData$site_id)
    year <-unique(subData$year)
    species <-unique(subData$species)
    species_id <-unique(subData$species_id)
    size_m2 <- unique(subData$size_m2)
    density_treeha <-  length(subData$dbh1_cm)*(10000 / size_m2)
    dbhDQ_cm <-  meanSquaredDiameter(subData$dbh1_cm)
    dbhArith_cm <- mean(subData$dbh1_cm, na.rm = T)
    dbhBA_cm <- LoreysMeanDBH(subData$dbh1_cm)
    heightBA_m <- LoreysMeanHeight(subData$height1_m, subData$dbh1_cm)
    heightArith_m <- mean(subData$height1_m, na.rm = T)
    ba_m2ha <- standBA(subData$dbh1_cm, subData$size_m2)
    subSummary <- cbind(site, site_id, year, species, species_id, size_m2, density_treeha,
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
  columns <- c(3,6:ncol(summaryObject))
  summaryObject[,columns] <- apply(summaryObject[,columns], 2, function(x) as.numeric(as.character(x)))
  summaryObject <- summaryObject[,colSums(is.na(summaryObject))<nrow(summaryObject)]
  row.names(summaryObject) <- NULL
  return(summaryObject)
}



summarizePROFOUND.FLUX <- function(data, by = "total"){
  # This summs whateever it gets and returns gC/m2
  sumHalfhourly <- function(x){
    # Convert half hourly average to the time period of 30 min (60s/m * 30 min = 1800s)
    x <- x*60*30
    # result is umolCO2m2
    # do the sum of whatever is available: day or year
    x <-sum(x, na.rm = T)
    # Calculate the C part of the molecule
      # 1 atom O 15,999 u, 1 atom C 12.0096
      # 1 mol CO2 --> 2*15,999 + 12.0096 = 44.0076 grams CO2
      # 1 mol CO2 --> 12.0096 grams C
      # 1 umol CO2 --> 12.0096 g/mol * 1mol/1000000 umol
    x <- x*12.0096/1000000
    # result is gC/m2
    return(x)
  }
  # These functions create the new variables.
  summaryFLUX <- function(subData, by){
    neeCutRef_gCm2 <- ifelse("neeCutRef_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$neeCutRef_umolCO2m2s1),NA)
    neeVutRef_gCm2 <- ifelse("neeVutRef_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$neeVutRef_umolCO2m2s1),NA)
    neeCutRefJointunc_gCm2 <- ifelse("neeCutRefJointunc_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$neeCutRefJointunc_umolCO2m2s1),NA)
    neeVutRefJointunc_gCm2<- ifelse("neeVutRefJointunc_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$neeVutRefJointunc_umolCO2m2s1),NA)
    recoNtVutRef_gCm2 <- ifelse("recoNtVutRef_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$recoNtVutRef_umolCO2m2s1),NA)
    recoNtVutSe_gCm2 <- ifelse("recoNtVutSe_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$recoNtVutSe_umolCO2m2s1),NA)
    recoNtCutRef_gCm2 <- ifelse("recoNtCutRef_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$recoNtCutRef_umolCO2m2s1),NA)
    recoNtCutSe_gCm2 <- ifelse("recoNtCutSe_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$recoNtCutSe_umolCO2m2s1),NA)
    gppNtVutRef_gCm2 <- ifelse("gppNtVutRef_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$gppNtVutRef_umolCO2m2s1),NA)
    gppNtVutSe_gCm2 <- ifelse("gppNtVutSe_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$gppNtVutSe_umolCO2m2s1),NA)
    gppNtCutRef_gCm2 <- ifelse("gppNtCutRef_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$gppNtCutRef_umolCO2m2s1),NA)
    gppNtCutSe_gCm2 <- ifelse("gppNtCutSe_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$gppNtCutSe_umolCO2m2s1),NA)
    recoDtVutRef_gCm2  <- ifelse("recoDtVutRef_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$recoDtVutRef_umolCO2m2s1),NA)
    recoDtVutSe_gCm2 <- ifelse("recoDtVutSe_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$recoDtVutSe_umolCO2m2s1),NA)
    recoDtCutRef_gCm2 <- ifelse("recoDtCutRef_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$recoDtCutRef_umolCO2m2s1),NA)
    recoDtCutSe_gCm2 <- ifelse("recoDtCutSe_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$recoDtCutSe_umolCO2m2s1),NA)
    gppDtVutRef_gCm2 <- ifelse("gppDtVutRef_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$gppDtVutRef_umolCO2m2s1),NA)
    gppDtVutSe_gCm2 <- ifelse("gppDtVutSe_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$gppDtVutSe_umolCO2m2s1),NA)
    gppDtCutRef_gCm2 <- ifelse("gppDtCutRef_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$gppDtCutRef_umolCO2m2s1),NA)
    gppDtCutSe_gCm2 <- ifelse("gppDtCutSe_umolCO2m2s1" %in% colnames(subData), sumHalfhourly(subData$gppDtCutSe_umolCO2m2s1),NA)

    subSummary <- cbind(neeCutRef_gCm2, neeVutRef_gCm2,
                        neeCutRefJointunc_gCm2, neeVutRefJointunc_gCm2,
                        recoNtVutRef_gCm2, recoNtVutSe_gCm2, recoNtCutRef_gCm2,
                        recoNtCutSe_gCm2, gppNtVutRef_gCm2, gppNtVutSe_gCm2,
                        gppNtCutRef_gCm2, gppNtCutSe_gCm2, recoDtVutRef_gCm2,
                        recoDtVutSe_gCm2, recoDtCutRef_gCm2, recoDtCutSe_gCm2,
                        gppDtVutRef_gCm2, gppDtVutSe_gCm2, gppDtCutRef_gCm2,
                        gppDtCutSe_gCm2)
    # if year convert to t ha i change names, do another cbind
    site <- unique(subData$site)
    site_id <-unique(subData$site_id)
    year <-unique(subData$year)
    if (by == "year" || by == "total"){
      # Convert to tC/ha
      colnames(subSummary) <- gsub("_gCm2", "_tCha1", colnames(subSummary))
      subSummary <-apply(subSummary, c(1,2), function(x) x*(1/1000000)*(100000/1))
      subSummary <- as.data.frame(cbind(site, site_id, year,subSummary))
    }else if (by == "day"){
      mo <- unique(subData$mo)
      day <- unique(subData$day)
      date <- paste(year, day, mo, sep = "-")
      subSummary <- as.data.frame(cbind(site, site_id, year,mo, day, date, subSummary))
      subSummary$date <- as.Date(subSummary$date, format = "%Y-%m-%d")
    }
    return(subSummary)
  }
  # Summarize
    # consider first summarize by days, then years, and then total
  if(by == "day"){
    data$foobar <- paste(data$year, data$mo, data$day, sep = "_")
    foobar <- unique(data$foobar)
  }else{
    data$foobar <- data$year
    foobar <- unique(data$year)
  }
  summaryObject <- lapply(1:length(foobar), function(x){
    subData <- data[data$foobar == foobar[x], ]
    subData <- summaryFLUX(subData, by)
    return(subData)
  })
  summaryObject <- as.data.frame(Reduce(f = function(...)rbind(...),x = summaryObject))

  if(by=="day") {
    summaryObject[,2:5] <- apply(summaryObject[,2:5], 2, function(x) as.numeric(as.character(x)))
    summaryObject[,7:ncol(summaryObject)] <- apply(summaryObject[,7:ncol(summaryObject)], 2, function(x) as.numeric(as.character(x)))
  }else{
    summaryObject[,2:ncol(summaryObject)] <- apply(summaryObject[,2:ncol(summaryObject)], 2, function(x) as.numeric(as.character(x)))
  }
  if(by == "total"){
    summaryTotal <- summaryObject[1,]
    summaryTotal[,2:ncol(summaryTotal)] <- apply(summaryObject[,2:ncol(summaryObject)], 2, function(x) mean(x, na.rm = T))
    summaryTotal$year <- paste(range(data$year, na.rm=T), collapse = "-")
    summaryObject <- summaryTotal
  }
  row.names(summaryObject) <- NULL
  summaryObject$foobar <- NULL
  return(summaryObject)
}


