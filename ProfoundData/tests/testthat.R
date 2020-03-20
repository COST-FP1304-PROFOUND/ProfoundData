
Sys.setenv("R_TESTS" = "")

library(ProfoundData)
library(testthat)

# Replace this with your for local tests!
databaseLocation = "/Users/florian/temp/ProfoundData.sqlite"

test_check("ProfoundData")


