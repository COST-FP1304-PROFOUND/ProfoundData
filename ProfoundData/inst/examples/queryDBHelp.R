\dontrun{
# main directory
mainDir <- "/some/absolute/path/mainDir"
list.files(mainDir)
[1] "guess" or "guesscmd.exe"  # link to the model executable
[2] "gridlist.txt"      # list of gridcells
[3] "global.ins"        # template1 (optional)
[4] "global_cru.ins"    # template2 (optional)

# The run directory that is whithin the mainDir
runDir <- "/some/absolute/path/mainDir/runDirectory"

## mode cru ##
# The template2 of the model what is within the runDirectoy.
template2 <- "global_cru.ins"
template2 <- "europe_cru.ins"

# Call the model
callLPJ(mainDir = mainDir, runDir = runDir, template2 = template2, mode = "cru")

## mode cf ##
# The template2 of the model what is within the runDirectoy.
template2 <- "global_cf.ins"
template2 <- "europe_cf.ins"

# Call the model
callLPJ(mainDir = mainDir, runDir = runDir, template2 = template2, mode = "cf")
}
