
Sys.setenv("R_TESTS" = "")

library(ProfoundData)
library(testthat)

# Replace this with zyour for local tests!
databaseLocation = "/Users/florian/Downloads/ProfoundData.sqlite 2"

test_check("ProfoundData")


