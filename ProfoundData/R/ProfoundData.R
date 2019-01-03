#' @docType package
#' @aliases ProfoundData
#' @name ProfoundData-package
#' @title Overview of the functions in the ProfoundData package
#' @description The ProfoundData package provides functions to explore, visualize and get data from the PROFOUND
#' database. The package is particularly convenient for working with forest models on an R environment.
#'
#' A brief description of the PROFOUND database is avalaible in the vignette 'PROFOUNDdatabase' (
#' you can open it by running this command: \code{vignette('PROFOUNDdatabase')}).
#'
#' Below is a list of the package's functions grouped by theme. See the package
#' vignette for more information and examples (\code{vignette('ProfoundData')}).
#'
#'
#' @section I. Browse the database: Functions to explore the database.
#' \itemize{
#'   \item \code{\link{browseData}} To check
#'   \itemize{
#'    \item  available sites
#'    \item  available datasets
#'    \item  available variables for a dataset
#'    \item  available datasets for a site
#'    \item  database version
#'    \item  metadata
#'    \item  policy
#'    \item  source
#'    \item  site description
#'    }
#'    \item \code{\link{summarizeData}} To obtain
#'     \itemize{
#'    \item  data overviews
#'    \item  data summaries
#'    }
#'
#' }
#'
#' @section II. Download data: Functions to download data. Data can be downloaded for one site and one dataset at a time.
#' \itemize{
#'  \item \code{\link{getData}} To download data
#' }
#'
#'
#' @section III. Visualize data: Functions to plot data from the database.
#' \itemize{
#'   \item \code{\link{plotData}} To plot data
#' }
#'
#' @section IV. Utilities: Miscellanous
#' \itemize{
#'  \item \code{\link{setDB}} To set the connection to the database
#'  \item \code{\link{getDB}} To retrieve the filepath to the database
#'   \item \code{\link{queryDB}} To pass self-defined queries
#'  \item \code{\link{reportDB}} To create a site-by-site report of the database
#'   \item \code{\link{writeSim2netCDF}} To write netCDF-files
#' }
#'
#' @author Except where indicated otherwise, the functions in this package were
#'  written by Ramiro Silveyra Gonzalez, Christopher Reyer and Florian Hartig.
#' @keywords package
#' @keywords Profound DB
#' @import methods sqldf RSQLite DBI stats utils graphics RNetCDF settings

globalVariables(c("table_id", "DateSubset"))


NULL

# here is good place for imports
