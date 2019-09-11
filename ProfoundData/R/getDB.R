#' @title A function to return information of the database connection
#'
#' @description A function to return the filepath to the database.
#' @return a character string with the filepath to the database
#' @author Ramiro Silveyra Gonzalez
#' @examples /inst/examples/download-set-get-DBHelp.R
#' @export
getDB <- function(){
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection", call. = FALSE)
  }else{
    RSQLite::dbDisconnect(conn)
  }
  versionHelp()
  #return(getFromNamespace("db",  pos =  "package:ProfoundData")$path)
  return(dbConnection()$dbname)
}

