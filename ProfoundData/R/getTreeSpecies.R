# @title A get treespecies function
# @description  A function to provide information on available tree species in the
# ProfoundData database
# @param species a character string providing the name of the species
# @return a table with the species if not arguments are passed. Otherwise, it returns the
# species ID.
# @export
# @examples \dontrun{
# treeSpecies <- getTreeSpecies()
# }
# @note To report errors in the package or the data, please use the issue tracker
# in the github repository of TG2 https://github.com/COST-FP1304-PROFOUND/TG2/issues
# (preferred, but requires that you have access to our GitHub account) or
# or use this google form http://goo.gl/forms/e2ZQCiZz4x
# @keywords ProfoundData
# @author Ramiro Silveyra Gonzalez
getTreeSpecies <- function(species){
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection", call. = FALSE)
  }
  table <- RSQLite::dbGetQuery(conn, "SELECT * FROM TREESPECIES")
  RSQLite::dbDisconnect(conn)
  if(!is.null(species)){
    if (species %in% table[["species"]]){
      species_id <- table[table$species==species,]$species_id
    }else if(species %in% table[["species_id"]]){
      species_id <- table[table$species_id==species,]$species_id
    }else{
      stop("Invalid tree species", call. = FALSE)
    }
  }else{
    stop("Invalid tree species", call. = FALSE)
  }
  return(species_id)
}
