library(RMySQL)
db <- RMySQL::dbConnect(MySQL(),
                 user="profound", password="profoundData",
                 dbname="test3", host="localhost")
