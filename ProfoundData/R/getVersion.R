# @title A get version function
# @description  A function to provide information on the version of the DB
# @return a table with the versioning: version name, date and description
# @examples \dontrun{
# versionDB <- getVersion()
# }
# @keywords ProfoundData
# @author Ramiro Silveyra Gonzalez
getVersion <- function(){
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection")
  }
  table <- RSQLite::dbGetQuery(conn, "SELECT * FROM VERSION")
  RSQLite::dbDisconnect(conn)
  return(table)
}
