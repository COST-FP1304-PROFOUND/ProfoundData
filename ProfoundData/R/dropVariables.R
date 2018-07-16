# @title A function to drop variables from data
#
# @description This function drops variables from a given dataset
# @param dataset a character string providing the name of an available dataset
# @param variables a character array with the variables to check
# @param data a data.frame holding the data to be subset
# @return data  a data.frame
# @note To report errors in the package or the data, please use the issue tracker
# in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
# (preferred, but requires that you have access to our GitHub account) or
# or use this google form http://goo.gl/forms/e2ZQCiZz4x
# @author Ramiro Silveyra Gonzalez

dropVariables <- function(data, variables, dataset){
  message("Subsetting variables")
  #cat(variables, collapse =", ");cat("\n")
  # the valid variables list for each dataset
  variablesKeep <- c("record_id", "site", "site_id", "date", "year", "day", "mo", "hour", "DoY",
                      "timestampStart", "timestampEnd", "forcingDataset", "forcingConditions",
                      "species", "species_id")
  # The quality flags variables
  # Check the quality flags that must be kept based on variables
  variablesQuality <- getVariables(dataset, quality = TRUE)
  variablesQuality <- variablesQuality[names(variablesQuality) %in% variables]
  # Pack together what it should be kept and subset the data.
  variablesKeep <- c(variablesKeep, variables, variablesQuality)
  variablesKeep <- variablesKeep[variablesKeep %in% colnames(data)]
  data <- data[, variablesKeep]
  return(data)
}
