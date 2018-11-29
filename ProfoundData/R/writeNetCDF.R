#' @title A function to write netCDF-files
#' @description This function transforms simulation results into netCDF files following the ISIMIP2 protocol
#'
#' @param df A data.frame containing in the first three columns longitude latitude
#'  and time. These columns are followed by columns containing the output variables.
#'   The columns have to be named with the output variable name as required by the
#'   protocol. See table 13.
#' @param modelname The name of the used forest model
#' @param GCM The climate model which created the used climate time series
#' @param RCP The RCP scenario
#' @param ses The scenario describing forest management. UMsoc equals the "nat"
#' settings and histsoc and 2005soc equal the "man" settings in the ISIMIP2a
#' protocol. Default value: "nat".
#' @param ss  "co2" for all experiments other than the sensitivity experiments
#' for which 2005co2 is explicitly written.  Note: even models in which CO2 has
#' no effect should use the co2 identifier relevant to the experiment.  Default
#' value: "co2const".
#' @param start the start year of the simulation. Default value: 1980.
#' @param region the region or site of the simulation
#' @param folder The folder in which all netCDF files will be written
#' @param contact Your mail address
#' @param institution Your institution
#' @param comment1 Optional comment regarding your simulation
#' @param comment2 Optional comment regarding your simulation
#'
#' @details
#' The function transforms your simulation output data frame into several netCDF
#' -files and writes them into the indicated folder using the naming convention of
#'  the ISIMIP2-protocol (https://www.isimip.org/protocol/). Units and long names
#'  of variables  (table 13) will be created automatically.
#' @export
#' @author Friedrich J. Bohn

writeSim2netCDF<-function(df
                          , comment1= NA
                          , comment2=NA
                          , institution= 'PIK'
                          , contact= 'isi-mip@pik-potsdam.de'
                          , modelname="formind"
                          , GCM="hadgem"
                          , RCP="rcp85"
                          , ses ="nat"
                          , ss="co2const"
                          , region="Kroof"
                          , start='1980'
                          , folder="ISI-MIP"){
  
  # cheque if data frame
  if ( !class(df)[1] %in% 'data.frame') {
    message( paste('Error: input data must be a data.frame, not a ', class(df)[1]))
    return(FALSE)
  }
  
  if(length(comment1)==1)

    if(is.na(comment1))comment1<-rep("",length(colnames(df)))
    if(length(comment2)==1)
      if(is.na(comment2))comment2<-rep("",length(colnames(df)))

      for( i in 4:length(colnames(df))){
        variable<-colnames(df)[i]
        code<-strsplit(variable,"_")[[1]]
        # swith code part 1
        {switch(code[1],
                dbh={
                  unit<-"cm"
                  variable_long<-"mean DBH"
                },
                Dbh={
                  unit<-"cm"
                  variable_long<-"Mean DBH of 100 highest trees"
                },
                height={
                  unit<-"m"
                  variable_long<-"Stand Height "
                },
                Dbh={
                  unit<-"c
                  m"
                  variable_long<-"Mean DBH of 100
                  highest trees "
                },
                dom={
                  unit<-"m"
                  variable_long<-"Dominant Height"
                },
                density={
                  unit<-"Trees ha-1"
                  variable_long<-"Stand Density"
                },
                ba={
                  unit<-"m2 ha-1"
                  variable_long<-"Basal Area"
                },
                mort={
                  unit<-"m-3 ha-1"
                  variable_long<-"Volume of Dead Trees"
                },
                harv={
                  unit<-"m-3 ha-1"
                  variable_long<-"Harvest by dbh-class"
                },
                stemno={
                  unit<-"Trees ha-1"
                  variable_long<-"Remaining stem number after disturbance and management by dbh class"
                },
                vol={
                  unit<-"m3 ha-1"
                  variable_long<-"Stand Volum"
                },
                cveg={
                  unit<-"kg C m2"
                  variable_long<-"Carbon Mass in Vegetation biomass"
                },
                clitter={
                  unit<-"kg C m2"
                  variable_long<-"Carbon Mass in Litter Pool"
                },
                cvegag = {
                  unit <- "kg C m2"
                  variable_long <- "Carbon Mass in aboveground vegetation biomass"
                },cvegbg = {
                  unit <- "kg C m2"
                  variable_long <- "Carbon Mass in belowground vegetation biomass"
                },
                csoil={
                  unit<-"kg C m2"
                  variable_long<-"Carbon Mass in Soil Pool"
                },
                age={
                  unit<-"yr"
                  variable_long<-"Tree age by dbh class"
                },
                gpp={
                  unit<-"kg m-2 s-1"
                  variable_long<-"Gross Primary Production"
                },
                npp={
                  unit<-"kg m-2 s-1"
                  variable_long<-"Net Primary Production"
                },
                ra={
                  unit<-"kg m-2 s-1"
                  variable_long<-"Autotrophic (Plant) Respiration"
                },
                rh={
                  unit<-"kg m-2 s-1"
                  variable_long<-"Heterotrophic Respiration"
                },
                nee={
                  unit<-"kg m-2 s-1"
                  variable_long<-"Net Ecosystem Exchange"
                },
                mai={
                  unit<-"m3 ha-1"
                  variable_long<-"Mean Annual Increment"
                },
                fapar={
                  unit<-"%"
                  variable_long<-"Fraction of absorbed photosynthetically active radiation"
                },
                lai={
                  unit<-"m2 m-2"
                  variable_long<-"Leaf Area Index"
                },
                species={
                  unit<-"%"
                  variable_long<-"Species composition"
                },
                evap={
                  unit<-"kg m-2 s-1"
                  variable_long<-"Total Evapotranspiration "
                },
                intercept={
                  unit<-"kg m-2 s-1"
                  variable_long<-"Evaporation from Canopy (interception) "
                },
                esoil={
                  unit<-"kg m-2 s-1"
                  variable_long<-"Water Evaporation from Soil"
                },
                trans={
                  unit<-"kg m-2 s-1"
                  variable_long<-"Transpiration"
                },
                soilmoist={
                  unit<-"kg m-2"
                  variable_long<-"Soil Moisture"
                },
                {
                  message(paste("error:colname",variable,"does not correspond to the ISI-MIP convention of the ISI.MIP simulation protocol 2.1"))
                  return(FALSE)
                }
        )
      }
        # switch code part 2
        if (length(code)>1){
          switch(code[2],
                 total={variable_long<-paste(variable_long,"Total")},
                 fasy={variable_long<-paste(variable_long,"Fagus sylvatica")},
                 quro={variable_long<-paste(variable_long,"Quercus robur")},
                 qupe={variable_long<-paste(variable_long,"Quercus petraea")},
                 pisy={variable_long<-paste(variable_long,"Pinus sylvestris")},
                 piab={variable_long<-paste(variable_long,"Pinus pinaster ")},
                 lade={variable_long<-paste(variable_long,"Larix decidua")},
                 eugl={variable_long<-paste(variable_long,"Eucalyptus globulus")},
                 acpl={variable_long<-paste(variable_long,"Acer platanoides ")},
                 bepe={variable_long<-paste(variable_long,"Betula pendula")},
                 frex={variable_long<-paste(variable_long,"Fraxinus excelsior")},
                 poni={variable_long<-paste(variable_long,"Populus nigra")},
                 rops={variable_long<-paste(variable_long,"Robinia pseudoacacia")},
                 hawo={variable_long<-paste(variable_long,"Fagus sylvatica")},
                 domhei={},
                 height={},
                 {
                   message(paste("error:colname",variable,"does not correspond to the ISI-MIP convention of the ISI.MIP simulation protocol 2.1"))
                   return(FALSE)
                 }
          )
        }
        # switch code part 3
        if (length(code)>2){
          class<-as.numeric(strsplit(code[3],"c")[[1]][2])
          if(class >140 || class <0 )           {
            message(paste("error:colname",variable,"does not correspond to the ISI-MIP convention of the ISI.MIP simulation protocol 2.1"))
            return(FALSE)
          }
          variable_long<-paste(variable_long,"DBH_class_",class,"-",class+5)

        }

        # write netCDF file
        write.netCDF(df
                     ,variable
                     ,variable_long=variable_long
                     ,unit= unit
                     ,comment1=comment1[i]
                     ,comment2=comment2[i]
                     ,institution=institution
                     ,contact= contact
                     ,modelname=modelname
                     ,GCM=GCM
                     ,RCP=RCP
                     ,ses =ses
                     ,ss=ss
                     ,region=region
                     ,folder=folder)
        }
      return (TRUE)
      }


write.netCDF<-function(df
                       ,variable
                       ,variable_long=  'precipitation'
                       ,unit= 'kg  m-2  s-1'
                       , comment1=  ""
                       , comment2=""
                       ,institution= 'PIK'
                       , contact= 'isi-mip@pik-potsdam.de'
                       ,modelname="formind"
                       , GCM="hadgem"
                       ,RCP="rcp85"
                       ,ses ="nat"
                       ,ss="co2const"
                       ,region="Kroof"
                       ,folder="ISI-MIP"){
  # cheques
  if (colnames(df)[1] != "lon" && colnames(df)[1] != "lat" && colnames(df)[1] != "time") {
    message('Error: First 3 columns must be named "lon", "lat", "time".')
    return(FALSE)
  }
  if(length(unique(df$lon))>1||length(unique(df$lat))>1){
    message("Error: more than one coordinate in data")
    return(FALSE)
  }

  # filenameconstructtion
  timestep="annual"
  start<-df$time[1]
  end<-df$time[nrow(df)]
  filename<-paste(modelname,GCM,RCP,ses,ss,variable,region,timestep,start,end,sep="_")
  filename<-paste0(folder,"/",filename,".nc")
  title<-paste(modelname,GCM,RCP,ses,ss)
  #df$time<-paste0(df$time,"-01-01")


  #create file
  ncout <- RNetCDF::create.nc(filename, large=TRUE)

  #definitions
  RNetCDF::dim.def.nc(ncout, "lon", 1)
  RNetCDF::dim.def.nc(ncout, "lat", 1)
  RNetCDF::dim.def.nc(ncout, "time", unlim=TRUE)

  # variables
  RNetCDF::var.def.nc(ncout, "lon", "NC_FLOAT", "lon")
  RNetCDF::att.put.nc(ncout, "lon", "long_name", "NC_CHAR", "longitude")
  RNetCDF::att.put.nc(ncout, "lon", "standard_name", "NC_CHAR", "longitude")
  RNetCDF::att.put.nc(ncout, "lon", "unit", "NC_CHAR", "degrees_east")

  RNetCDF::var.def.nc(ncout, "lat", "NC_INT", "lat")
  RNetCDF::att.put.nc(ncout, "lat", "long_name", "NC_CHAR", "latitude")
  RNetCDF::att.put.nc(ncout, "lat", "standard_name", "NC_CHAR", "latitude")
  RNetCDF::att.put.nc(ncout, "lat", "unit", "NC_CHAR", "degrees_north")

  RNetCDF::var.def.nc(ncout, "time", "NC_INT", "time")
  RNetCDF::att.put.nc(ncout, "time", "units", "NC_CHAR", "years since 1901-01-01")
  RNetCDF::att.put.nc(ncout, "time", "calendar", "NC_CHAR", "standard")

  RNetCDF::var.def.nc(ncout, variable, "NC_FLOAT", c(0:2))
  RNetCDF::att.put.nc(ncout, variable, "_FillValue", "NC_FLOAT", 1.e+20)
  RNetCDF::att.put.nc(ncout, variable, "short_field_name", "NC_CHAR", variable)
  RNetCDF::att.put.nc(ncout, variable, "long_field_name", "NC_CHAR", variable_long)
  RNetCDF::att.put.nc(ncout, variable, "units", "NC_CHAR", unit)

  RNetCDF::att.put.nc(ncout, "NC_GLOBAL", "title", "NC_CHAR", title)
  RNetCDF::att.put.nc(ncout, "NC_GLOBAL", "comment1", "NC_CHAR", comment1)
  RNetCDF::att.put.nc(ncout, "NC_GLOBAL", "comment2", "NC_CHAR", comment2)
  RNetCDF::att.put.nc(ncout, "NC_GLOBAL", "institute", "NC_CHAR", institution)
  RNetCDF::att.put.nc(ncout, "NC_GLOBAL", "contact", "NC_CHAR", contact)

  # data
  RNetCDF::var.put.nc(ncout,"lon",df$lon[1],1,1)
  RNetCDF::var.put.nc(ncout,"lat",df$lat[1],1,1)
  RNetCDF::var.put.nc(ncout,"time",df$time-1901,1,length(df$time))
  collumn<-which(colnames(df)==variable)
  RNetCDF::var.put.nc(ncout,variable,df[,collumn],c(1,1,1),c(1,1,nrow(df)))

  RNetCDF::close.nc(ncout)
}


