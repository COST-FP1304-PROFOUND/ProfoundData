# @title A get variables function
# @description  A function to provide information on available variables of a
# dataset
# @param dataset a character string providing the name of the dataset
# @param quality a boolean to to see whether we want to see what variables have
# quality flags for the specified dataset.
# @return a vector with the available variables
# @export
# @note To report errors in the package or the data, please use the issue tracker
# in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
# (preferred, but requires that you have access to our GitHub account) or
# or use this google form http://goo.gl/forms/e2ZQCiZz4x
# @keywords ProfoundData
# @author Ramiro Silveyra Gonzalez
getVariables <- function(dataset,  quality = FALSE){
  firstVariables <- c("record_id", "site", "site2", "site_id", "species", "species_id",
                      "forcingConditions", "forcingDataset",
                      "description", "reference",  "date", "year", "mo", "day")
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection", call. = FALSE)
  }else{
    RSQLite::dbDisconnect(conn)
  }
  if(is.null(dataset)){
    stop("Please provide a dataset", call. = FALSE)
  }
  datasets.available <- getDatasets()
  if(dataset == "error"){
    stop("Please provide a valid dataset", call. = FALSE)
  }

  conn <- makeConnection()
  variablesAvailable <- RSQLite::dbListFields(conn, dataset)
  RSQLite::dbDisconnect(conn)


  if (quality == TRUE){
    variablesNoFlags <- variablesAvailable[!grepl("_qc$", variablesAvailable)]
    dummyFlags <- gsub("\\_.*", "_qc", variablesNoFlags)
    names(dummyFlags) <- variablesNoFlags
    variablesFlags <- variablesAvailable[grepl("_qc$", variablesAvailable)]
    if (length(variablesFlags)>0){
#      cat(variablesAvailable, collapse = ", "); cat("\n")
      variablesFlags <- dummyFlags[dummyFlags %in% variablesFlags]
#      cat(variablesAvailable.names, collapse = ", "); cat("\n")
   #   for (i in 1:length(variablesAvailable.names)){
  #      cat(variablesAvailable.names[i], collapse = ", "); cat("\n")
   #     variablesAvailable.names[i] <- allvariables[grepl(variablesAvailable.names[i], allvariables)]

    }else{
      variablesFlags <- NULL
    }
    variablesAvailable <- variablesFlags
  }else{
    variablesAvailable <- variablesAvailable[!grepl("_qc$", variablesAvailable)]
  }
  #Do no apply next code line until you sure that will not affect the package
  #variablesOrder <- c(firstVariables[firstVariables %in% variablesAvailable], variablesAvailable[!variablesAvailable %in% firstVariables])
  return(variablesAvailable)
}
