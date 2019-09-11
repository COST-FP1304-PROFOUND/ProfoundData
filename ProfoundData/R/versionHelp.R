#@title A function check the DB version
#
#@description You might want to futher edit this.
#@return warning f
#@export
#@author Ramiro Silveyra Gonzalez
#@import sqldf RSQLite DBI
versionHelp <- function(){
  # if no version available
  if(!"VERSION" %in% getDatasets()){
    warning("DB is outdated. Please update you local DB version", call. = FALSE)
    warning("Package functionality could be compromised", call. = FALSE)
  }else{
    version <- getVersion()
    currentVersion <- version[nrow(version), "version"]
    if(compareVersion(currentVersion, "0.2.0") < 0){
      warning("DB is outdated. Please update you local DB version", call. = FALSE)
      warning("Package functionality could be compromised", call. = FALSE)
    }
    message(paste("Database version is ", currentVersion, sep = ""))
  }
}
