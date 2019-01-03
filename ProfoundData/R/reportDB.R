#' @title A function report data
#'
#' @description This functions creates a site-by-site report of all avalaible data
#' in the PROFOUND database. The summary is created with a rmarkdown document, which
#' is rendered and saved as a html document.
#' @param outDir a character string indicating the output directory in which the
#' html file will be saved. If no value is provided, the working directory will be
#' used as output directory. 
#' @return a html file with the database report
#' @export
#' @example /inst/examples/reportDBHelp.R
#' @details Please note that creating the report it might take several minutes.
#' @note To report errors in the package or the data, please use the issue tracker
#' in the GitHub repository of ProfoundData \url{https://github.com/COST-FP1304-PROFOUND/ProfoundData}
reportDB <- function(outDir=NULL){
  if(is.null(outDir)==TRUE){
    outDir <- getwd()
  }else{
    if(!file.exists(outDir)){stop("Invalid output directory") }
  }
  
  conn <- try(makeConnection(), T)
  if ('try-error' %in% class(conn)){
    stop("Invalid database connection", call. = FALSE)
  }else{
    RSQLite::dbDisconnect(conn)
    rmarkdown::render(system.file("rmd", "PROFOUNDsites.Rmd", package = "ProfoundData"),
                      params = list(myDB = dbConnection()$dbname), output_dir = outDir)
  }
}
