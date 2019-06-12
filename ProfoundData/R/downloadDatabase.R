# @title Dowloads the PROFOUND databse
# @description  A function to provide information on the version of the DB
# @return a string with the location of the sql database
# @examples \dontrun{
# versionDB <- getVersion()
# }
# @export
# @author Florian Hartig
downloadDatabase<- function(location=NULL){
  if(is.null(location)) location = choose_directory()
  file = paste(location, "/ProfoundData.zip", sep = "")
  download.file("http://www.pik-potsdam.de/data/doi/10.5880/PIK.2019.008/ProfoundData.zip"
, file)
  if(file.exists(file)) message("dowload successfull, trying to unzip. This may not work on some operating systems. In this case, unzip by hand.")
  oldWd <- setwd(location)
  decompression <- system2("unzip", args = c("-o", file), stdout = TRUE)
  setsd(setwd(location))
  
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