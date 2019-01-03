#' @title A function to set the connection to the database
#'
#' @description A setDB funtion to  create a database connection object
#' @param db_name a character string providing the absolute path to the PROFOUND database.
#' @export
#' @example /inst/examples/setDBHelp.R
#' @note To report errors in the package or the data, please use the issue tracker
#' in the GitHub repository of ProfoundData \url{https://github.com/COST-FP1304-PROFOUND/ProfoundData}
setDB <- function(db_name){
  if (file.exists(db_name)){
    #ProfoundData.env <- new.env()
    #dbConnection() <- list(dbname = "somepath", driver = "somedriver")
    if(grepl("sqlite", db_name)){
      #dbConnection[["driver"]] <- SQLite()
      temp <- RSQLite::SQLite()
    }else{
      stop("Unkown driver")
    }
    #dbConnection[["dbname"]] <- db_name
    #ProfoundData.env$dbConnection <- dbConnection
  }else{
    stop("Please provide a valid path to DB")
  }
  dbConnection(dbname = db_name, driver = temp)
}


dbConnection <- settings::options_manager(dbname="somename", driver=RSQLite::SQLite())



