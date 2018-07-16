# @title A get locations function
# @description  A function to provide information on available locations in the
# ProfoundData database
# @param location a character string providing the name of the location (optional)
# @return a table with the locations if not arguments are passed. Otherwise, it returns the
# location ID.
# @export
# @examples \dontrun{
# locations <- getLocations()
# }
# @note To report errors in the package or the data, please use the issue tracker
# in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
# (preferred, but requires that you have access to our GitHub account) or
# or use this google form http://goo.gl/forms/e2ZQCiZz4x
# @keywords ProfoundData
# @author Ramiro Silveyra Gonzalez
getLocations <- function(location = NULL){
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection")
  }
  table <- RSQLite::dbGetQuery(conn, "SELECT * FROM SITES")
  RSQLite::dbDisconnect(conn)
  if(!is.null(location)){
    if (location %in% table[["site"]]){
      sites <- table[table$site==location,]$site_id
#    }else if(location %in% table[["site2"]]){
#      sites <- table[table$site2==location,]$site_id
#      sites <-  sites[!is.na(sites)]
    }else if (location %in% table[["site_id"]]){
      sites <- location
    }else{
      sites <- 0
    }
  }else{
    sites <- table   #[, c("Site_ID", "name1", "name2")]
  }
  return(sites)
}
