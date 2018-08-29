# @title A get version function
# @description  A function to provide information on the version of the DB
# @return a table with the versioning: version name, date and description
# @examples \dontrun{
# versionDB <- getVersion()
# }
# @export
# @keywords ProfoundData
# @author Ramiro Silveyra Gonzalez
getPolicy <- function(dataset, site = NULL){
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection")
  }
  if(is.null(site)){
    if (!getDatasets(dataset) ){stop("Invalid dataset", call. = FALSE)}
    table <- RSQLite::dbGetQuery(conn, paste("SELECT * FROM ", dataset, sep = ""))
    RSQLite::dbDisconnect(conn)
  }else{
    site <- getsites(site)
    if (!getDatasets(dataset) || !site ){stop("Invalid dataset and/or site", call. = FALSE)}
    if(!checkAvailable(dataset, site)){stop("site specific policy is not available", call. = FALSE)}
    dataset_site <- paste(dataset, site, sep="_")
    table <- RSQLite::dbGetQuery(conn, paste("SELECT * FROM ", dataset_site, sep = ""))
    RSQLite::dbDisconnect(conn)
  }
  return(table)
}
