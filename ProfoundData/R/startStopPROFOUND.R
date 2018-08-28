
startStopPROFOUND <- function(data){

}


startStopPROFOUND.YEARLY <- function(data){
  data$record_id <- NULL
  columnsNot <- c("site", "site_id")
  columnsYes <- colnames(data)[!colnames(data) %in% columnsNot]
  columnsYes <- columnsYes[!columnsYes %in% c("year")]
  colnamesCol <- c("site", "site_id",
                   "variable", "first", "last", "min", "max", "mean", "year_first", "year_last", "obs")
  collector <-as.data.frame(matrix(rep(NA, length(columnsYes) * length(colnamesCol)),
                                     nrow = length(columnsYes), ncol = length(colnamesCol),
                                     dimnames = list(columnsYes, colnamesCol)))
  collector$variable <- columnsYes
  collector$site <- unique(data$site)
  collector$site_id <- unique(data$site_id)

  for (j in 1:length(columnsYes)){
      tmp <- data[!is.na(data[[columnsYes[j]]]), ]
      collector[columnsYes[j], 4:ncol(collector) ] <- c(tmp[[columnsYes[j]]][1],tmp[[columnsYes[j]]][nrow(tmp)],
                                                        min(tmp[[columnsYes[j]]], na.rm = TRUE),
                                                        max(tmp[[columnsYes[j]]], na.rm = TRUE),
                                                        mean(tmp[[columnsYes[j]]], na.rm = TRUE),
                                                        tmp[["year"]][1], tmp[["year"]][nrow(tmp)], nrow(tmp))
  }

  rownames(collector) <- NULL
  return(collector)

}

startStopPROFOUND.ISIMIP <- function(data){
  data$record_id <- NULL
  columnsNot <- c("site", "site_id")
  colnamesCol <- c("site", "site_id", "forcingDataset", "forcingConditions",
                   "variable", "first", "last", "min", "max", "mean", "year_first", "year_last", "obs")

  if ("forcingDataset" %in% names(data)){
    if ("forcingConditions" %in% names(data)){
      forcingDataset <- unique(data$forcingDataset)
      forcingConditions <- unique(data$forcingConditions)
      collectorHolder <- vector("list", length = length(forcingDataset)*length(forcingConditions))
      index <- 0
      for (i in 1:length(forcingDataset)){
          for(j in 1:length(forcingConditions)){
            index <- index + 1
            columnsYes <- colnames(data)[!colnames(data) %in% columnsNot]
            columnsYes <- colnames(data)[!colnames(data) %in% columnsNot]
            columnsYes <- columnsYes[!columnsYes %in% c("year", "mo", "date", "day", "forcingDataset", "forcingConditions")]
            collector <-as.data.frame(matrix(rep(NA, length(columnsYes) * length(colnamesCol)),
                                             nrow = length(columnsYes), ncol = length(colnamesCol),
                                             dimnames = list(columnsYes, colnamesCol)))
            collector$variable <- columnsYes
            collector$site <- unique(data$site)
            collector$site_id <- unique(data$site_id)
            collector$forcingDataset <- forcingDataset[i]
            collector$forcingConditions <- forcingConditions[j]
            df <- data[data$forcingDataset == forcingDataset[i] & data$forcingConditions == forcingConditions[j], ]
            df <- summarizePROFOUND.CLIMATE(df, by = "year")
            for (k in 1:length(columnsYes)){
              tmp <- df[!is.na(df[[columnsYes[k]]]), ]
              collector[columnsYes[k], 6:ncol(collector) ] <- c(tmp[[columnsYes[k]]][1],tmp[[columnsYes[k]]][nrow(tmp)],
                                                                min(tmp[[columnsYes[k]]], na.rm = TRUE),
                                                                max(tmp[[columnsYes[k]]], na.rm = TRUE),
                                                                mean(tmp[[columnsYes[k]]], na.rm = TRUE),
                                                                tmp[["year"]][1], tmp[["year"]][nrow(tmp)], nrow(tmp))
            }
            rownames(collector) <- NULL
            collectorHolder[[index]] <- collector
          }

      }
      # reduce thing
      collector <- as.data.frame(Reduce(f = function(...)rbind(...),x = collectorHolder))

    }else{
      forcingDataset <- unique(data$forcingDataset)
      collectorHolder <- vector("list", length = length(forcingDataset))
      index <- 0
      for (i in 1:length(forcingDataset)){
        index <- index + 1
        columnsYes <- colnames(data)[!colnames(data) %in% columnsNot]
        columnsYes <- colnames(data)[!colnames(data) %in% columnsNot]
        columnsYes <- columnsYes[!columnsYes %in% c("year",  "mo", "date", "day",  "forcingDataset", "forcingConditions")]
        collector <-as.data.frame(matrix(rep(NA, length(columnsYes) * length(colnamesCol)),
                                         nrow = length(columnsYes), ncol = length(colnamesCol),
                                         dimnames = list(columnsYes, colnamesCol)))
        collector$variable <- columnsYes
        collector$site <- unique(data$site)
        collector$site_id <- unique(data$site_id)
        collector$forcingDataset <- forcingDataset[i]
        collector$forcingConditions <- NULL
        df <- data[data$forcingDataset == forcingDataset[i], ]
        df <- summarizePROFOUND.CLIMATE(df, by = "year")
        for (k in 1:length(columnsYes)){
          tmp <- df[!is.na(df[[columnsYes[k]]]), ]
          collector[columnsYes[k], 5:ncol(collector) ] <- c(tmp[[columnsYes[k]]][1],tmp[[columnsYes[k]]][nrow(tmp)],
                                                            min(tmp[[columnsYes[k]]], na.rm = TRUE),
                                                            max(tmp[[columnsYes[k]]], na.rm = TRUE),
                                                            mean(tmp[[columnsYes[k]]], na.rm = TRUE),
                                                            tmp[["year"]][1], tmp[["year"]][nrow(tmp)], nrow(tmp))
        }
        rownames(collector) <- NULL
        collectorHolder[[index]] <- collector
      }

      #reduce bit
      collector <- as.data.frame(Reduce(f = function(...)rbind(...),x = collectorHolder))
    }
  }else{
    stop("You are missing something!!!")
  }
  return(collector)
}





startStopPROFOUND.HOURLY <- function(data){

}


startStopPROFOUND.TREE <- function(data){


}

startStopPROFOUND.STAND <- function(data){
  data$record_id <- NULL
  columnsNot <- c("site", "site_id", "species", "species_id")
  columnsYes <- colnames(data)[!colnames(data) %in% columnsNot]
  columnsYes <- columnsYes[!columnsYes %in% c("year")]
  species <- unique(data$species)
  species_id <- unique(data$species_id)
  site <- unique(data$site)
  site_id <- unique(data$site_id)
  all <- vector("list", length(species))
  for (i in 1:length(species)){
    dummy <- data[data$species == species[i],]
    colnamesCol <- c("site", "site_id", "species", "species_id", "variable",
                     "first", "last","min", "max", "mean", "year_first", "year_last", "obs")
    collector <-as.data.frame(matrix(rep(NA, length(columnsYes) * length(colnamesCol)),
                           nrow = length(columnsYes), ncol = length(colnamesCol),
                           dimnames = list(columnsYes, colnamesCol)))
    collector$species <- species[i]
    collector$species_id <- species_id[i]
    collector$variable <- columnsYes
    collector$site <- site
    collector$site_id <- site_id

    for (j in 1:length(columnsYes)){
      tmp <- dummy[!is.na(dummy[[columnsYes[j]]]), ]
      collector[columnsYes[j], 6:ncol(collector) ] <- c(tmp[[columnsYes[j]]][1],tmp[[columnsYes[j]]][nrow(tmp)],
                                                        min(tmp[[columnsYes[j]]], na.rm = TRUE),
                                                        max(tmp[[columnsYes[j]]], na.rm = TRUE),
                                                        mean(tmp[[columnsYes[j]]], na.rm = TRUE),
                                                        tmp[["year"]][1], tmp[["year"]][nrow(tmp)], nrow(tmp))
    }
    all[[i]] <- collector
  }
  all <-  Reduce(function(...) rbind(...), all)
  rownames(all) <- NULL
  return(all)
}
