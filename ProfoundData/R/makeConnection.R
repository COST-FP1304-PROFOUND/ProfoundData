# @title A function to ensure that the queried variables exist in the DB
#
# @description TODO
# @return a connection to the database
# @note To report errors in the package or the data, please use the issue tracker
#  in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
# (preferred, but requires that you have access to our GitHub account) or
# or use this google form http://goo.gl/forms/e2ZQCiZz4x
# @author Ramiro Silveyra Gonzalez
makeConnection <- function() {
  if (!requireNamespace("RSQLite", quietly = TRUE)) {
    stop("Pkg needed for this function to work. Please install it.",
         call. = FALSE)
  }else if(!requireNamespace("sqldf", quietly = TRUE)){
    stop("Pkg needed for this function to work. Please install it.",
         call. = FALSE)
  }else{
    #path.to.db <- system.file("extdata", "ProfoundData.sqlite", package="ProfoundData")
    #path.to.db <-"/home/trashtos/GitHub/TG2/ProfoundData/inst/extdata/ProfoundData.sqlite"
    conn <- try(RSQLite::dbConnect(db$drive, dbname = db$path), T)
    if ('try-error' %in% class(conn)){
      stop("Invalid database connection")
    }

    return(conn)
  }
}




