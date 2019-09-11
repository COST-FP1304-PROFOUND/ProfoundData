# @title A function to ensure that the queried variables exist in the DB
#
# @description TODO
# @return a connection to the database
# @author Ramiro Silveyra Gonzalez
makeConnection <- function() {
  if (!requireNamespace("RSQLite", quietly = TRUE)) {
    stop("Pkg needed for this function to work. Please install it.",
         call. = FALSE)
  }else if(!requireNamespace("sqldf", quietly = TRUE)){
    stop("Pkg needed for this function to work. Please install it.",
         call. = FALSE)
  }else{
    conn <- try(RSQLite::dbConnect(drv = dbConnection()$driver,
                                   dbname = dbConnection()$dbname), TRUE)
    if ('try-error' %in% class(conn)){
      stop("Invalid database connection")
    }

    return(conn)
  }
}




