#' @title A function to return information of the database connection
#'
#' @description A function to return the filepath to the database.
#' @return a character string with the filepath to the database
#' @author Ramiro Silveyra Gonzalez
#' @seealso \code{\link{setDB}}, \code{\link{downloadDatabase}}  
#' @example /inst/examples/download-set-get-DBHelp.R
#' @export
getDB <- function(){
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection. Please use setDB() to connect to a valid DB", call. = FALSE)
  }else{
    RSQLite::dbDisconnect(conn)
  }
  versionHelp()
  #return(getFromNamespace("db",  pos =  "package:ProfoundData")$path)
  return(dbConnection()$dbname)
}

#' @title A function to set the connection to the database
#'
#' @description A setDB funtion to  create a database connection object
#' @param db_name a character string providing the absolute path to the PROFOUND database.
#' @export
#' @seealso \code{\link{getDB}}, \code{\link{downloadDatabase}}  
#' @example /inst/examples/download-set-get-DBHelp.R
#' @note To report errors in the package or the data, please use the issue tracker
#' in the GitHub repository of ProfoundData \url{https://github.com/COST-FP1304-PROFOUND/ProfoundData}
setDB <- function(db_name = NULL){
  if(is.null(db_name)) db_name <- file.choose()
  
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


#' Downloads the PROFOUND database 
#' 
#' @description This function downloads the PROFOUND database
#' @details This is a convenience function to quickly download the PROFOUND database. The function will query you to ask about the path to store the databse, and will return a string with the location, for use in setDB
#' @param location file system location to store the database. If not provide, the function will use the current working directory. 
#' @return a string with the location of the sql database
#' @seealso \code{\link{getDB}}, \code{\link{setDB}} 
#' @example /inst/examples/download-set-get-DBHelp.R
#' @export
#' @author Florian Hartig
downloadDatabase<- function(location=NULL){
  
  #if(is.null(location)) location = choose_directory()
  if(is.null(location)) location = getwd()
  file = paste(location, "/ProfoundData.zip", sep = "")
  download.file("http://www.pik-potsdam.de/data/doi/10.5880/PIK.2019.008/ProfoundData.zip"
                , file)
  if(file.exists(file)) message("download successfull, trying to unzip. This may not work on some operating systems. In this case, locate the downloaded file and unzip by hand.")
  oldWd <- getwd()
  setwd(location)
  decompression <- system2("unzip", args = c("-o", file), stdout = TRUE)
  setwd(oldWd)
  
  sqlFile <- paste(location, "/ProfoundData.sqlite", sep = "")
  if(file.exists(sqlFile)) message(paste("unzip successfull, your database file is at", sqlFile, ". Please store this location for initializing the PROFOUND R functions"))
  return(sqlFile) 
}


# currently not used because it didn't seem to work on all OS without problems
choose_directory = function(caption = 'Select database download directory') {
  if (exists('utils::choose.dir')) {
    choose.dir(caption = caption) 
  } else {
    tcltk::tk_choose.dir(caption = caption)
  }
}



