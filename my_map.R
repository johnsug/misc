
library(Cairo)
library(maps)
library(data.table)
library(ggplot2)
windows.options(antialias="cleartype")
## coorinates from https://mapstogpx.com/

## to do:
# future project, map (roughly) everywhere I've been
# * powder springs to ellijay
# * oklahoma trip...
# 
# ## shade: lived (utah, idaho, georgia, texas, missouri, kansas) -- just the county?
# ## maybe shade states I HAVE NOT been to (WA, MT, ND, SD, WI, LA, IA, OH, WV, VA, NC, SC, DE, PA, RI, NH, VT, ME) 18/51 ~35%
)
# ## dots where traveled for work (SF, Reno, Oklahoma, Dallas, Austin, DC, Vegas)
# ## dots where run races (Atlanta, Chattanooga/Nashville, KC, St. George, Buckeye, Portland)


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

## does rounding corrupt? not really, not much difference between 2 and 3 decimal places
fl[, lat:=round(lat, 2)]
fl[, long:=round(long, 2)]
fl <- unique(fl)

## quick plot
usa <- map_data("state")
not <- data.table(usa)
not <- not[region %in% c("washington", "montana", "north dakota", "south dakota", "wisconsin", "louisiana", "iowa", "ohio", "west virginia", "virginia", 
                         "north carolina", "south carolina", "delaware", "pennsylvania", "rhode island", "new hampshire", "vermont", "maine")]
not[, .N, by=region]

ggplot() + 
  geom_polygon(data=not, aes(x=long, y=lat, group=group), fill="green", alpha=.1) + 
  geom_polygon(data=usa, aes(x=long, y=lat, group=group), size=1, color=5, fill=5, alpha=.15) + 
  geom_point(data=fl, aes(x=long, y=lat), color=6, size=.8) + ## takes a while
  theme_minimal() + 
  theme(legend.position="none", 
        axis.text=element_blank(), 
        panel.grid=element_blank()) + 
  labs(x="", y="") + 
  coord_fixed(1.3)
  

