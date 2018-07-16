##############
# Plot locations on forest map of europe
#######################
# libaries
require(rgdal)
require(raster)
require(sp)
require(ggmap)
require(RgoogleMaps)

## Read locations ##
# 1. Open locations
inFile <- "/home/trashtos/GitHub/PROFOUND-Code/Data/processsing/LocationsCoordinates.txt"
Locations <- read.table(inFile, sep=",", dec=".", header = TRUE)
Locations <- Locations[-2,]
Locations$Location <- as.character(Locations$Location )
Locations$Location[2] <- "Solling"
Locations$Location[3] <- "Peitz"
Locations$Location[4] <- "Sorø"
Locations$Location[9] <- "Freising"

## 2. Create SpatialPoints 
coordinates(Locations)<-~X+Y
proj4string(Locations) <- CRS("+proj=longlat +datum=WGS84")
plot(Locations)
data <- as.data.frame(cbind( Location = (Locations@data), lat=  as.vector(coordinates(Locations)[,1]), lon =as.vector(coordinates(Locations)[,2])) )
    # you could skip this point and just use the coordinates table for the google map,
    # but if you create the spatialpoints, then you can  write the locations to shapefile, 
    # which migth be interesting at some point 

# 3. Get Europe Map
CenterOfMap <- geocode("Europe")
# now only option I know to have googlemaps witout label
Europe <- get_googlemap(c(lon=CenterOfMap$lon, lat=CenterOfMap$lat),zoom = 4, maptype = "terrain", style = "feature:all|element:labels|visibility:off")
Europe <- ggmap(Europe)
EuropeLoc <- Europe + geom_point(data = data , size=5, color='red', shape = 9, aes(lat = data$lat, lon =data$lon, label=data$Location)) 
# use jitter to avoid overlapping of labels
finalMap <- EuropeLoc + geom_text(data = data , aes(label=data$Location), color = "black", size=7, position=position_jitter(width=1, height=1.5))#vjust=-1, hjust=0.5
#png(filename =  "/home/trashtos/GitHub/PROFOUND-Code/Data/processsing/locations.png",  width = 1200, height = 1200,)
finalMap
#dev.off()

## Extra 1: create a shapefile 
writeOGR(Locations , "/home/trashtos/GitHub/PROFOUND-Code/Data/processsing/locationsfour.shp" , "locationsfour", driver="ESRI Shapefile")

## Extra 2: Get Forest Map of Europe

# 1. Download forest map of europe
url = "http://www.pik-potsdam.de/~reyer/EFI_Forest_cover_map/GIS/forest_v2011_GISdata.zip"
destFile = "/home/trashtos/ForestMap.zip"
download.file(url, destFile, "wget", quiet = FALSE, mode = "w",  cacheOK = TRUE )

# 2. Unzip files 
imageFiles <- unzip(destFile,  exdir = "/home/trashtos/ForestMap", unzip = "internal")

# 3. Read the file
forestMap <- raster(imageFiles[1])
plot(forestMap)
# get the extemtz
extentMap <- extent(forestMap)
  # Create the legend
breakpoints <- c(0, 10,25,50,75,100,200,300)
colors <- c("white","greenyellow","green1","green3","green4","skyblue", "darkgrey")
# Expand right side of clipping rect to make room for the legend
plot(forestMap,breaks=breakpoints,col=colors,
     main= "FOREST MAP OF EUROPE" , legend =FALSE)
     

#legend(  extentMap[2]+100,extentMap[4]--100 ,
 #       legend = c("<1",">1-10", ">10-25", ">25-50", ">50-75", ">75-100", "Water", "No data"), 
#        fill = colors)
legend(  "topright" ,cex = 0.25,
         legend = c("<1",">1-10", ">10-25", ">25-50", ">50-75", ">75-100", "Water", "No data"), 
         fill = colors)


              