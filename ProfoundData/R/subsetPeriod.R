# @title A utitility funtion for formatData
#
# @description  A function that performs a subset on data based on a give period
# @param data dataframe, data to be subset
# @param period array, either start of the subset or start and end.
# @return dataframe or list of dataframes
# @keywords ProfoundData
# @author Ramiro Silveyra Gonzalez
subsetPeriod <- function(data, period){
  if(!"date" %in% names(data)){
    warning("This data cant be subset: no date column", call. = FALSE)
  }else{
    if (all(is.na(period)))stop("Invalid period", call. = FALSE)
    data$DateSubset <- as.Date(data$date, format = "%Y-%m-%d")
    # perfom subset
    if (length(period) ==1){
      #period <- as.Date(period,format = "%Y-%m-%d" )
     # message("Processing a subset the time series")
      data <- subset(data, DateSubset >= period[1])
    }else if (length(period)==2){
      if(any(is.na(period))){
        if (which(is.na(period))==1){
          data <- subset(data, DateSubset <= period[2])
        }else if (which(is.na(period))==2){
          data <- subset(data, DateSubset >= period[1])
        }else{
          warning("Bug!", call. = FALSE)
        }
      }else{
        period <- period[order(period)]
        #period[1] <- as.Date(period[1],format = "%Y-%m-%d" )
        #period[2] <- as.Date(period[2],format = "%Y-%m-%d" )
        message ("Processing a subset of the time series")
        data <- subset(data, DateSubset >= period[1] &  DateSubset  <= period[2] )
      }
    }
    data$DateSubset <- NULL
  }
  return(data)
}
