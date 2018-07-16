# @title A get version function
# @description  A function to provide information on the version of the DB
# @return a table with the versioning: version name, date and description
# @examples \dontrun{
# versionDB <- getVersion()
# }
# @export
# @keywords ProfoundData
# @author Ramiro Silveyra Gonzalez
getMetadata <- function(dataset, location = NULL){
  firstVariables <- c("record_id", "site", "site2", "site_id", "species", "species_id",
                      "forcingConditions", "forcingDataset",
                      "description", "reference",  "date", "year", "mo", "day")

  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection")
  }
  #message(dataset_location)
  if(is.null(location)){
    if (!getDatasets(dataset) ){stop("Invalid dataset")}
    table <- RSQLite::dbGetQuery(conn, paste("SELECT * FROM ", dataset, sep = ""))
    RSQLite::dbDisconnect(conn)
  }else{
    location <- getLocations(location)
    if (!getDatasets(dataset) || !location ){stop("Invalid dataset and/or location")}
    if(!checkAvailable(dataset, location)){stop("Metadata is not available")}
    dataset_location <- paste(dataset, location, sep="_")
    table <- RSQLite::dbGetQuery(conn, paste("SELECT * FROM ", dataset_location, sep = ""))
    RSQLite::dbDisconnect(conn)
  }
  tableVariables <- unique(table$variable)
  variablesOrder <- c(firstVariables[firstVariables %in% tableVariables],
                      tableVariables[!tableVariables %in% firstVariables])
  if(!any(duplicated(table$variable))){
    table <- table[match(variablesOrder, table$variable),]
    rownames(table) <- NULL
  }else{
    sources <- unique(table$source)
    tableList <- lapply(sources, function(x){
      dummy <- table[table$source ==x, ]
      dummy <- dummy[match(variablesOrder, dummy$variable),]
      dummy <- dummy[!is.na(dummy$variable),]
      return(dummy)
    })
    table <- Reduce(rbind, tableList)
#    table <- tableList
    rownames(table) <- NULL
  }

  return(table)
}

