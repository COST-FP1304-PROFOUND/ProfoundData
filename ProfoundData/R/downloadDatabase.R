#' Downloads the PROFOUND database 
#' 
#' @description This function downloads the PROFOUND database
#' @details This is a convenience function to quickly download the PROFOUND database. The function will query you to ask about the path to store the databse, and will return a string with the location, for use in setDB
#' @param location file system location to store the database
#' @return a string with the location of the sql database
#' @example /inst/examples/download-set-get-DBHelp.R
#' @export
#' @author Florian Hartig
downloadDatabase<- function(location=NULL){
  if(is.null(location)) location = choose_directory()
  file = paste(location, "/ProfoundData.zip", sep = "")
  download.file("http://www.pik-potsdam.de/data/doi/10.5880/PIK.2019.008/ProfoundData.zip"
, file)
  if(file.exists(file)) message("dowload successfull, trying to unzip. This may not work on some operating systems. In this case, unzip by hand.")
  oldWd <- getwd()
  setwd(location)
  decompression <- system2("unzip", args = c("-o", file), stdout = TRUE)
  setwd(oldWd)
  
  sqlFile <- paste(location, "/ProfoundData.sqlite", sep = "")
  if(file.exists(sqlFile)) message(paste("unzip successfull, your databse file is at", sqlFile, ". Please store this location for initializing the PROFOUND R functions"))
  return(sqlFile) 
}


choose_directory = function(caption = 'Select database download directory') {
  if (exists('utils::choose.dir')) {
    choose.dir(caption = caption) 
  } else {
    tcltk::tk_choose.dir(caption = caption)
  }
}