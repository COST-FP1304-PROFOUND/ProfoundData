#' @title A function to return information of the database connection
#'
#' @description A function to return the filepath to the database.
#' @return a character string with the filepath to the database
#' @export
#' @example /inst/examples/getDBHelp.R
#' @note To report errors in the package or the data, please use the issue tracker
#' in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
#' (preferred, but requires that you have access to our GitHub account) or
#' or use this google form http://goo.gl/forms/e2ZQCiZz4x
#' @author Ramiro Silveyra Gonzalez
getDB <- function(){
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection", call. = FALSE)
  }else{
    RSQLite::dbDisconnect(conn)
  }
  versionHelp()
  return(getFromNamespace("db",  pos =  "package:ProfoundData")$path)
}

