
# this function comes from the BayesianTools package. Remove and import once the BT package is on CRAN


#' Calculates the panel combination for par(mfrow = )
#' @param x the desired number of panels
#' @export
getPanels <- function(x){
  if (x <= 0){
    warning("number can't be < 1")
    ownMfrow <-  c(1,1)
  }

  lower = floor(sqrt(x))
  upper = ceiling(sqrt(x))

  if (lower == upper) ownMfrow <-c(lower, lower)
  else{
    if (lower * upper >= x) ownMfrow <-c(lower, upper)
    else  ownMfrow <-c(upper, upper)
  }
  return(ownMfrow)
}



