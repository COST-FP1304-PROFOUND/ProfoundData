formatPROFOUND.SOIL <- function(tmp){
  data <- tmp[["query"]]
  if(!class(data)=="data.frame") stop(paste("Error when querying:", tmp[["item"]]), call. = FALSE)
  if(tmp[["collapse"]]){
    result.list <- data[,colSums(is.na(data))<nrow(data)]
  }else{
    tables <- unique(data$table_id)
    result.list <- vector("list", length(tables))
    for (i in 1:length(tables)){
      df <-subset(data, table_id == tables[i])
      df <- df[,colSums(is.na(df))<nrow(df)]
      result.list[[i]]<- df
    }
    if (length(result.list) == 1){
      result.list <- result.list[[1]]
    }
  }
  return(result.list)
}

formatPROFOUND.FLUXNET <- function(tmp){
  data <- tmp[["query"]]
  if(!class(data)=="data.frame") stop(paste("Error when querying:", tmp[["item"]]), call. = FALSE)
  if (!is.null(tmp[["quality"]]))  data <- checkQuality(rawdata= data, variables= tmp[["variablesChecked"]],
                                                        dataset= tmp[["dataset"]], value = tmp[["quality"]], tmp[["decreasing"]])

  if (!is.null(tmp[["period"]])){
    message("Subsetting data to the requested time period")
    data <- subsetPeriod(data, tmp[["period"]])
  }
  data <- data[,colSums(is.na(data))<nrow(data)]
  return(data)
}
formatPROFOUND.CLIMATELOCAL <- function(tmp){
  data <- tmp[["query"]]
  if(!class(data)=="data.frame") stop(paste("Error when querying:", tmp[["item"]]), call. = FALSE)
  if (!is.null(tmp[["quality"]]))  data <- checkQuality(rawdata= data, variables= tmp[["variablesChecked"]],
                                                        dataset= tmp[["dataset"]], value = tmp[["quality"]], tmp[["decreasing"]])
  if (!is.null(tmp[["period"]])){
    message("Subsetting data to the requested time period")
    data <- subsetPeriod(data, tmp[["period"]])
  }
  data <- data[,colSums(is.na(data))<nrow(data)]
  return(data)
}

formatPROFOUND.MODIS <- function(tmp){
  data <- tmp[["query"]]
  if(!class(data)=="data.frame") stop(paste("Error when querying:", tmp[["item"]]), call. = FALSE)
  if (!is.null(tmp[["quality"]]))  data <- checkQuality(rawdata= data, variables= tmp[["variablesChecked"]],
                                                        dataset= tmp[["dataset"]], value = tmp[["quality"]], tmp[["decreasing"]])

  if (!is.null(tmp[["period"]])){
    message("Subsetting data to the requested time period")
    data <- subsetPeriod(data, tmp[["period"]])
  }
  data <- data[,colSums(is.na(data))<nrow(data)]
  return(data)
}



formatPROFOUND.ISIMIPDatasetConditions <- function(tmp){
  if(!class(tmp[["query"]])=="data.frame") stop(paste("Error when querying:", tmp[["item"]]), call. = FALSE)
  if(tmp[["collapse"]]){
    data <- tmp[["query"]]

    if (!is.null(tmp[["period"]])){
      message("Subsetting data to the requested time period")
      data <- subsetPeriod(data, tmp[["period"]])
    }
    result.list <- data
  }else{

    forcingDataset <- unique(tmp[["query"]]$forcingDataset)
    result.list <- vector("list", length(forcingDataset))
    names(result.list)<- forcingDataset
    for (i in 1:length(forcingDataset)){
      message("---------------")
      message(forcingDataset[i])
      message("---------------")
      rawData <- tmp[["query"]][which( tmp[["query"]]$forcingDataset==forcingDataset[i]), ]
      forcingConditions <- unique(rawData$forcingConditions)
      forcingConditions.list <- vector("list", length(forcingConditions))
      names(forcingConditions.list) <- forcingConditions
      for(j in 1:length(forcingConditions)){
        df <- rawData[which( rawData$forcingConditions==forcingConditions[j]), ]
        # period subset
        if (!is.null(tmp[["period"]])){
          message("Subsetting data to the requested time period")
          df <- subsetPeriod(df, tmp[["period"]])
        }
        forcingConditions.list[[forcingConditions[j]]] <- df
      }
      result.list[[forcingDataset[i]]] <- forcingConditions.list
    }
    # collapse dimension: droplevels if empty
    if (length(result.list) == 1){
      result.list <- result.list[[1]]
      if (length(result.list) == 1 ){
        result.list <- result.list[[1]]
      }
    }
  }
  return(result.list)
}

formatPROFOUND.ISIMIPDataset <- function(tmp){
  if(!class(tmp[["query"]])=="data.frame") stop(paste("Error when querying:", tmp[["item"]]), call. = FALSE)
  if(tmp[["collapse"]]){
    data <- tmp[["query"]]
    if (!is.null(tmp[["period"]])){
      message("Subsetting data to the requested time period")
      data <- subsetPeriod(data, tmp[["period"]])
    }
    result.list <- data
  }else{
    forcingDataset <- unique(tmp[["query"]]$forcingDataset)
    result.list <- vector("list", length(forcingDataset))
    names(result.list) <- forcingDataset
    for (i in 1:length(forcingDataset)){
      message("---------------")
      message(forcingDataset[i])
      message("---------------")
      df <- tmp[["query"]][tmp[["query"]]$forcingDataset==forcingDataset[i], ]
      if (!is.null(tmp[["period"]])){
        message("Subsetting data to the requested time period")
        df <- subsetPeriod(df, tmp[["period"]])
      }
      result.list[[forcingDataset[i]]] <-df
    }
    # collapse dimension: droplevels if empty
    if (length(result.list) == 1){
      result.list <- result.list[[1]]
      if (length(result.list) == 1 ){
        result.list <- result.list[[1]]
      }
    }
  }
  return(result.list)
}

formatPROFOUND.ISIMIPConditions <- function(tmp){
  if(!class(tmp[["query"]])=="data.frame") stop(paste("Error when querying:", tmp[["item"]]), call. = FALSE)
  if(tmp[["collapse"]]){
    df <- tmp[["query"]]
    if (is.null(tmp[["period"]]) == TRUE){
      message("Processing the entire time series")
    }else{
      df <- subsetPeriod(df, tmp[["period"]])
    }
    result.list <- df
  }else{
    forcingConditions <- unique(tmp[["query"]]$forcingConditions)
    result.list <- vector("list", length(forcingConditions))
    names(result.list) <- forcingConditions
    for (i in 1:length(forcingConditions)){
      message("---------------")
      message(forcingConditions[i])
      message("---------------")
      df <- tmp[["query"]][tmp[["query"]]$forcingConditions==forcingConditions[i], ]
      if (!is.null(tmp[["period"]])){
        message("Subsetting data to the requested time period")
        df <- subsetPeriod(df, tmp[["period"]])
      }
      result.list[[forcingConditions[i]]] <-df
    }
    # collapse dimension: droplevels if empty
    if (length(result.list) == 1){
      result.list <- result.list[[1]]
      if (length(result.list) == 1 ){
        result.list <- result.list[[1]]
      }
    }
  }
  return(result.list)
}
