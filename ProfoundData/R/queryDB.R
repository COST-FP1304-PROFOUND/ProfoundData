#' @title A function to query the database
#'
#' @description A queryDB function to perform self-defined queries on the PROFOUND database.
#' @param queryItem a character string providing the query
#' @export
#' @example /inst/examples/queryDBHelp.R
#' @note To report errors in the package or the data, please use the issue tracker
#' in the GitHub repository of ProfoundData \url{https://github.com/COST-FP1304-PROFOUND/ProfoundData}
queryDB <- function(queryItem) {
  # check the item, check if site is list or
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


