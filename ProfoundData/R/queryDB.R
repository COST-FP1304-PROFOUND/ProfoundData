#' @title A function to create the a database connection object
#'
#' @description A queryDB funtion to  perform own queries to the Profound DB
#' @param queryItem a character string providing the query
#' @export
#' @example /inst/examples/queryDBHelp.R
#' @note To report errors in the package or the data, please use the issue tracker
#' in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
#' (preferred, but requires that you have access to our GitHub account) or
#' or use this google form http://goo.gl/forms/e2ZQCiZz4x
#' @author Ramiro Silveyra Gonzalez
queryDB <- function(queryItem) {
  # check the item, check if location is list or
  #run.function <- TRUE
  # now start the function itself
  # make connection
  conn <- makeConnection()
  # build query
  # send the query
  queried <- try(RSQLite::dbGetQuery(conn, queryItem))
  result <- NULL
  if ('try-error' %in% class(queried)) {
    #result[[item]] <- dbGetException(conn) # do something about this
    stop("Error when querying:",queryItem, sep = " ") # do something about this
    RSQLite::dbDisconnect(conn)
  }else if (length(queried[,1]) < 1){
    stop("Error when querying:", queryItem, sep = " ") # do something about this
  }else{
    result <- queried
    RSQLite::dbDisconnect(conn)
  }
  return (result)
}


