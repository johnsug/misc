
library(Cairo)
library(maps)
library(data.table)
library(ggplot2)
windows.options(antialias="cleartype")
## coorinates from https://mapstogpx.com/

## custom formula to parse coordinates
parse_gpx <- function(data){
  require(data.table)
  
  ## rename 
  names(data) <- "col"
  
  ## drop unnecessary columns (keep only rows with lat/long coordinates)
  data <- data[col %like% "lat"]
  
  ## trim unnecessary characters
  data[, col:=gsub("<trkpt lat=", "", col)]
  data[, col:=gsub("<wpt lat=", "", col)]
  data[, col:=gsub(">", "", col)]
  
  ## split lat/long
  data[, c("lat", "long"):=tstrsplit(col, "lon=")]
  
  ## convert to numeric
  data[, lat:=as.numeric(lat)]
  data[, long:=as.numeric(long)]
  
  ## drop unnecessary column
  data[, col:=NULL]
  
  ## return cleaned data.table
  return(data)
}

## import
fl1 <- data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200519_132301.gpx"))
fl2 <- data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200519_135528.gpx"))

## parse gpx
fl1 <- parse_gpx(fl1)
fl2 <- parse_gpx(fl2)

fl <- rbind(fl1, fl2)

## quick plot
usa <- map_data("state")

ggplot() + 
  geom_polygon(data=usa, aes(x=long, y=lat, group=group), size=1, color=5, fill=5, alpha=.15) + 
  geom_point(data=fl, aes(x=long, y=lat), color="dodgerblue", size=.5) + ## takes a while
  theme_minimal() + 
  theme(legend.position="none", 
        axis.text=element_blank(), 
        panel.grid=element_blank()) + 
  labs(x="", y="") + 
  coord_fixed(1.3)
  

