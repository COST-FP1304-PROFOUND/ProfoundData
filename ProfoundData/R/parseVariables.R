# @title A function to ensure that the queried variables exist in the DB
#
# @description TODO
# @param dataset a character string providing the name of an available dataset
# @param variables a character array with the variables to check
# @return variablesChecked  a character array holding a valid list of variables
# @export
# @author Ramiro Silveyra Gonzalez

parseVariables <- function(dataset, variables = NULL){
  # the valid variables list for each dataset this only refers what it can be plot
  variablesDrop <- c("record_id", "site", "site_id", "date", "year", "day", "mo", "hour", "DoY",
                     "species","species_id",
                      "timestampStart", "timestampEnd", "forcingDataset", "forcingCondition")
  variablesAvailable <- getVariables(dataset)
  if (is.null(variables)){
    variablesChecked <- variablesAvailable
  }else{
    variablesChecked <- variablesAvailable[variablesAvailable %in% variables ]
    variablesWrong <- variables[!variables %in% variablesAvailable ]
    if(length(variablesWrong) > 1) warning(paste("The variables", paste(variablesWrong, collpase =", "), "do not exist in", dataset, sep = " "))
    if (0 < length(variablesWrong) &  length(variablesWrong) < 2 ) warning(paste("The variable", variablesWrong, "does not exist in", dataset, sep = " "))
    if(length(variablesChecked) == 0) stop("Invalid variables")
 #     warning("Setting the variables to default")
#      variablesChecked <- variablesAvailable
 #   }
  }
  variablesChecked <- variablesChecked[!variablesChecked %in% variablesDrop]
  # return the checked variables in array
  return(variablesChecked)
}
