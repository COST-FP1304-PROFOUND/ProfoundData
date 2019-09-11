# @title A function to format data downloaded from a DB
#
# @description  A function to format data downloaded from the ProfoundData database
# @param tmp a query object returned by the parseQuery function
# @param quality a boolean indicating whether the returned data will have with quality flag 0 and 1.
# @param collapse a boolean indicating whether the returned data should be a
# single dataframe (TRUE) or list of dataframes. Only needed for ISIMIP dataframe.
# @return a dataframe or list of dataframes
# @keywords ProfoundData
# @author Ramiro Silveyra Gonzalez
formatData <- function(tmp){
  message(paste("Formatting data of ", tmp[["dataset"]], sep = ""))
  # Columns of final output
  # Replace -9999 by NA
  if (!tmp[["dataset"]]== "SITES" ){
    tmp[["query"]][ tmp[["query"]] == -9999] <- NA
  #  tmp[["query"]] <- tmp[["query"]][,colSums(is.na(tmp[["query"]]))<nrow(tmp[["query"]])]
    #cat(tmp[["variables"]])
    #  if(!is.null(tmp[["variables"]]))
    if(tmp[["dropVariables"]])    tmp[["query"]] <- dropVariables(tmp[["query"]], tmp[["variablesChecked"]], tmp[["dataset"]])
    if (grepl("CLIMATE_ISIMIP2B", tmp[["dataset"]]) || grepl("CLIMATE_ISIMIP2BBLC",  tmp[["dataset"]])  || grepl( "CLIMATE_ISIMIPFT", tmp[["dataset"]])){
      data <- formatPROFOUND.ISIMIPDatasetConditions(tmp)
    }else if (grepl("CLIMATE_ISIMIP2A", tmp[["dataset"]])){
      data <- formatPROFOUND.ISIMIPDataset(tmp)
    }else if (grepl("CO2_ISIMIP", tmp[["dataset"]]) || grepl("NDEPOSITION_ISIMIP2B", tmp[["dataset"]]) ){
      data <- formatPROFOUND.ISIMIPConditions(tmp)
    }else if (tmp[["dataset"]]== "FLUX" || tmp[["dataset"]]== "ATMOSPHERICHEATCONDUCTION" || tmp[["dataset"]]== "SOILTS" || tmp[["dataset"]]== "FLUXNET" || tmp[["dataset"]]== "METEOROLOGICAL"){
      data <- formatPROFOUND.FLUXNET(tmp)
    }else if (grepl("MODIS", tmp[["dataset"]])){
      data <- formatPROFOUND.MODIS(tmp)
    }else if (tmp[["dataset"]]== "SOIL"){
      data <- formatPROFOUND.SOIL(tmp)
    }else if (tmp[["dataset"]]== "CLIMATE_LOCAL"){
      data <- formatPROFOUND.CLIMATELOCAL(tmp)
    }else{
      if(!class(tmp[["query"]])=="data.frame") stop(paste("Error when querying:", tmp[["item"]]), call. = FALSE)
      tmp[["query"]] <- tmp[["query"]][,colSums(is.na(tmp[["query"]]))<nrow(tmp[["query"]])]
      data <- tmp[["query"]]
    }
  }else if (tmp[["dataset"]]== "SITES" ){
    if(!class(tmp[["query"]])=="data.frame") stop(paste("Error when querying:", tmp[["item"]]), call. = FALSE)
    data <- tmp[["query"]]
  }
  return(data)
}





