# Produce sample data 
df <- data.frame(lat = rep(20, 10),
                 lon = rep(30, 10),
                 time = seq(1920, 2010, 10),
                 dbh_total = c(10:19),
                 nee_total = rnorm(10, -0.5, 0.25),
                 evap = rnorm(10, 0.001, 0.0001),
                 cwood_fasy = seq(40, 85, 5))

# Convert multi-variable data.frame into single-variable netCDFs using ISIMIP naming conventions
writeSim2netCDF(df = df,
                comment1 = NA,
                comment2 = NA,
                institution = 'PIK',
                contact = 'isi-mip@pik-potsdam.de',
                modelname = "formind",
                GCM = "hadgem",
                RCP = "rcp85",
                ses = "nat",
                ss = "co2const",
                region = "Kroof",
                start = '1920',
                folder = "tempdir")
