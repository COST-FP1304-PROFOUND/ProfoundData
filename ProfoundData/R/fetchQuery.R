# @title A function to query data from a DB
#
# @description This function performs queries data on DB and returns
# @param tmp a named list containing TODO
# @return TODO
# @keywords ProfoundData
# @note To report errors in the package or the data, please use the issue tracker
# in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
# (preferred, but requires that you have access to our GitHub account) or
# or use this google form http://goo.gl/forms/e2ZQCiZz4x
#
# @author Ramiro Silveyra Gonzalez

fetchQuery <- function(tmp) {
  # check the item, check if site is list or
  #run.function <- TRUE
# now start the function itself
# make connection
  conn <- makeConnection()
  # build query
  # send the query
  if(is.null(tmp[["site"]]))    message(paste("Downloading data from" , tmp[["dataset"]],  sep = " "))
 # }else{
#    message(paste("Downloading data from" , tmp[["dataset"]], "for the site", tmp[["site"]],  sep = " "))
#  }

  queried <- try(RSQLite::dbGetQuery(conn, tmp[["item"]]))
  if ('try-error' %in% class(queried)) {
    #result[[item]] <- dbGetException(conn) # do something about this
    tmp[["query"]] <- paste ("Error when querying:", tmp[["item"]], sep = " ") # do something about this
  }else if (length(queried[,1]) < 1){
    tmp[["query"]] <- paste ("Error when querying:", tmp[["item"]], sep = " ") # do something about this
  }else{
    tmp[["query"]] <- queried
  }
  RSQLite::dbDisconnect(conn)
  return (tmp)
}

