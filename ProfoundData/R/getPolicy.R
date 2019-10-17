# @title A get policy function
# @description  A function to provide information on the policy of the dataset
# @return a table with the policy information for the specified dataset and site
# @examples \dontrun{
# dataPolicy <- getPolicy(dataset ="CLIMATE_ISIMIP2A", site = "soro")
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
