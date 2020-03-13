
# Note: this is from BayesianTools, should be removed as soon as a BT udpate with export is on CRAN

#' getPanels
#' 
#' Calculates the argument x for par(mfrow = x) for a desired number of panels
#' 
#' @author Florian Hartig
#' @param x the desired number of panels 
#' @export
getPanels <- function(x){
  if (x <= 0) stop("number can't be < 1")
  
  lower = floor(sqrt(x))
  upper = ceiling(sqrt(x))
  
  if (lower == upper) return(c(lower, lower))
  else{
    if (lower * upper >= x) return(c(lower, upper))
    else return(c(upper, upper))    
  }
}  