#' @docType package
#' @aliases ProfoundData
#' @name ProfoundData-package
#' @title Overview of the functions in the ProfoundData package
#' @description The ProfoundData package provides functions to access the Profound
#' database. The database is designed to provide data needed by forest
#' models. The package allow users to explore the available dataset and locations
#' in the database, as well as download and visualize data. ProfoundData should be particularly
#' useful for users working with models on a R environment.
#'
#' Below is a list of the functions grouped by theme. See the vignette for more
#' information and some examples (you can open it by running this command:
#' \code{vignette('ProfoundDataVignette')})
#'
#' @section I. Browse the database: Functions to explore what datasets, variables, locations are available.
#' \itemize{
#'   \item \code{\link{browseData}} To check
#'   \itemize{
#'    \item  available locations
#'    \item  available datasets
#'    \item  available variables for a dataset
#'    \item  available datasets for a location
#'    \item  database version
#'    \item  metadata
#'    \item  policy
#'    \item  source
#'    \item  site description
#'    }
#' }
#'
#' @section II. Download data: Functions to download data. Data can be download for one location and one dataset at a time.
#' \itemize{
#'  \item \code{\link{getData}} To download data
#' }
#'
#'
#' @section III. Visualize data: Functions to plot data from the database
#' \itemize{
#'   \item \code{\link{plotData}} To plot data
#' }
#'
#' @section IV. Utilities: Miscellanous
#' \itemize{
#'  \item \code{\link{setDB}} To set the connection to the database
#'  \item \code{\link{getDB}} To retrieve the filepath to the database
#'   \item \code{\link{writeSim2netCDF}} To write netCDF-files
#'   \item \code{\link{summarizeData}} To summarize data from the database.
#'   \item \code{\link{queryDB}} To pass self-defined queries
#' }
#'
#' @author Except where indicated otherwise, the functions in this package were
#'  written by Ramiro Silveyra Gonzalez
#' @section Acknowledgements:
#' TODO
#' @keywords package
#' @keywords Profound DB
#' @import methods sqldf RSQLite DBI stats utils graphics

globalVariables(c("table_id", "DateSubset"))


NULL

# here is good place for imports
