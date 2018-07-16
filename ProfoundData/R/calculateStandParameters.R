#calculate_basal_area <- function(tree) {
#ba <- as.data.frame(aggregate(tree$dbh1_cm, by=list(year=tree$year, species=tree$species), function(x) sum(0.25 *pi * x^2)))
#  names(ba)[names(ba) =="x"] <- "basal_area_cm2"
#  if (length(unique(tree$size_m2)) == 1) ba$basal_area_m2_per_ha <- (ba$basal_area_cm2/(100*100))/(unique(tree$size_m2)/(100*100))
#  ba
#}


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


