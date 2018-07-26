#' @title A function to create the a database connection object
#'
#' @description A setDB funtion to  create a database connection object
#' @param db_name a character string providing the absolute path to the Profound DB.
#' @export
#' @example /inst/examples/setDBHelp.R
#' @note To report errors in the package or the data, please use the issue tracker
#' in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
#' (preferred, but requires that you have access to our GitHub account) or
#' or use this google form http://goo.gl/forms/e2ZQCiZz4x
#' @author Ramiro Silveyra Gonzalez
setDB <- function(db_name){
  db <- list()
  #db_name <- normalizePath(db_name)
  if (file.exists(db_name)){
    db[["path"]] <- db_name
    message(db[["path"]])
    if(grepl("sqlite", db_name)){
      db[["driver"]] <- SQLite()
    }
    assignInNamespace("db", db,   pos ="package:ProfoundData")
    versionHelp()
  }else{
    stop("Please provide a valid path to DB")
  }
}


