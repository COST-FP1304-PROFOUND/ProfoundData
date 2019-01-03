#@title A function check the DB version
#
#@description You might want to futher edit this.
#@return warning f
#@export
#@note To report errors in the package or the data, please use the issue tracker
# in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
# (preferred, but requires that you have access to our GitHub account) or
# or use this google form http://goo.gl/forms/e2ZQCiZz4x
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
