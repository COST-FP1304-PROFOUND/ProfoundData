# @title A function to query data from a DB
#
# @description This function queries data on DB and returns the query
# @param tmp a named list containing needed parameters for executing the query
# @return tmp an object containing the queried data
# @keywords ProfoundData
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

