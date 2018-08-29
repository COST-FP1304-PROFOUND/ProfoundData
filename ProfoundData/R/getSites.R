# @title A get sites function
# @description  A function to provide information on available sites in the
# ProfoundData database
# @param site a character string providing the name of the site (optional)
# @return a table with the sites if not arguments are passed. Otherwise, it returns the
# site ID.
# @export
# @examples \dontrun{
# sites <- getsites()
# }
# @note To report errors in the package or the data, please use the issue tracker
# in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
# (preferred, but requires that you have access to our GitHub account) or
# or use this google form http://goo.gl/forms/e2ZQCiZz4x
# @keywords ProfoundData
# @author Ramiro Silveyra Gonzalez
getsites <- function(site = NULL){
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection", call. = FALSE)
  }
  table <- RSQLite::dbGetQuery(conn, "SELECT * FROM SITES")
  RSQLite::dbDisconnect(conn)
  if(!is.null(site)){
    if (site %in% table[["site"]]){
      sites <- table[table$site==site,]$site_id
#    }else if(site %in% table[["site2"]]){
#      sites <- table[table$site2==site,]$site_id
#      sites <-  sites[!is.na(sites)]
    }else if (site %in% table[["site_id"]]){
      sites <- site
    }else{
      sites <- 0
    }
  }else{
    sites <- table   #[, c("Site_ID", "name1", "name2")]
  }
  return(sites)
}
