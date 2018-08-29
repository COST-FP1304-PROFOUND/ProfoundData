# @title A function to do a data subset on quality files
#
# @description This function replace values with NAs if they do not meet the quality requirement
# @param rawdata dataframe to be susbet
# @param variables  a character array holding the variables to be plotted. Default  is all variables.
# @param dataset a character string providing the name one of the available datasets.
# @param value a character string providing the name one of the available datasets.
# @param decreasing a boolean indicated whether ther quality treshold should be applied up or downwards.
# @return a subset of the raw data dataframe
# @author Ramiro Silveyra Gonzalez

checkQuality <- function(rawdata, variables,  dataset, value, decreasing){
  message("Checking data quality")
  # Internal function
  # there alwasy parametes
  # but include a checker to stop it.
  variablesQuality <- getVariables(dataset, quality = TRUE)
  # Figure out wether there is any variable with quality flag
  variablesQuality <- variablesQuality[variablesQuality %in% colnames(rawdata)]
  if (length(variablesQuality)==0){
    warning("There are not quality flags for this specific dataset", call. = FALSE)
  }else{
    if(decreasing){
      message(paste("Removing data points with quality >", value, sep =" "))
      for(i in 1:length(variables)){
        if(variables[i] %in% names(variablesQuality)){

         # if(max(rawdata[[variablesQuality[[variables[i]]] ]], na.rm = T) > value){
          rawdata[[ variables[i] ]] <-ifelse(rawdata[[ variablesQuality[[variables[i]]] ]] > value, NA, rawdata[[ variables[i] ]])
          rawdata[[variablesQuality[[variables[i]]]]] <-ifelse(rawdata[[ variablesQuality[[variables[i]]] ]] > value, NA, rawdata[[variablesQuality[[variables[i]]] ]])
       #      rawdata[[ variables[i] ]][ rawdata[[ variablesQuality[[variables[i]]] ]] >  value ] <- NA
        }
      }
    }else if(!decreasing){
      message(paste("Removing data points with quality <", value, sep =" "))
      for(i in 1:length(variables)){
        if(variables[i] %in% names(variablesQuality)){

        #  if(min(rawdata[[variablesQuality[[variables[i]]] ]], na.rm = T) < value){
          rawdata[[ variables[i] ]] <-ifelse(rawdata[[ variablesQuality[[variables[i]]] ]] < value, NA, rawdata[[ variables[i] ]] )
          rawdata[[ variablesQuality[[variables[i]]] ]] <-ifelse(rawdata[[ variablesQuality[[variables[i]]] ]] < value, NA, rawdata[[ variablesQuality[[variables[i]]] ]] )
            #rawdata[[ variables[i] ]][ rawdata[[ variablesQuality[[variables[i]]] ]] <  value ] <- NA
        #  }
        }
      }
    }else{
      warning("You might have found a bug! Please report it", call. = FALSE)
    }
  }
  return(rawdata)
}
