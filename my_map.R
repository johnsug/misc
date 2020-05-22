
library(maps)
library(Cairo)
library(ggplot2)
library(data.table)
windows.options(antialias="cleartype")
## coorinates from https://mapstogpx.com/

## to do:
# future project, map (roughly) everywhere I've been

## read in coords for points of interest
poi <- fread("https://raw.githubusercontent.com/johnsug/misc/master/coords.csv")

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

## import and parse gpx
g01 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_200516.gpx")))
g02 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_200526.gpx")))
g03 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_200532.gpx")))
g04 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_200542.gpx")))
g05 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_200558.gpx")))
g06 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_200611.gpx")))
g10 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_200642.gpx")))
g11 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_200651.gpx")))
g13 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_200709.gpx")))
g14 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_200715.gpx")))
g15 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_200724.gpx")))
g21 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_202704.gpx")))
g22 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_202942.gpx")))
g23 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_203026.gpx")))
g24 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_203103.gpx")))
g25 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_203456.gpx")))
g31 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_205646.gpx")))
g32 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_205900.gpx")))
g33 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_210356.gpx")))
g34 <- parse_gpx(data.table(read.csv("C:/Users/JohnSugden/OneDrive - Caravan Health/John_Sugden_Private/mapstogpx20200520_211735.gpx")))
gpx <- rbind(g01, g02, g03, g04, g05, g06, g10, g11, g13, g14, g15, g21, g22, g23, g24, g25, g31, g32, g33, g34)
rm(g01, g02, g03, g04, g05, g06, g10, g11, g13, g14, g15, g21, g22, g23, g24, g25, g31, g32, g33, g34)

## does rounding corrupt? not really, not much difference between 2 and 3 decimal places
gpx[, lat:=round(lat, 3)]
gpx[, long:=round(long, 3)]
gpx <- unique(gpx)

## quick plot
usa <- map_data("state")
not <- data.table(usa)
not <- not[region %in% c("washington", "montana", "north dakota", "south dakota", "wisconsin", "louisiana", "iowa", "ohio", "west virginia", "virginia", 
                         "north carolina", "south carolina", "delaware", "pennsylvania", "rhode island", "new hampshire", "vermont", "maine")]
lived <- data.table(usa)
lived <- lived[region %in% c("utah", "idaho", "georgia", "kansas", "missouri")]


ggplot() + 
  geom_polygon(data=not, aes(x=long, y=lat, group=group), fill=5, alpha=.2) + 
  geom_polygon(data=usa, aes(x=long, y=lat, group=group), size=1, color=5, fill=5, alpha=.15) + 
  geom_polygon(data=lived, aes(x=long, y=lat, group=group), size=1, fill="#ffe5b4", alpha=.3) + 
  geom_point(data=gpx, aes(x=long, y=lat), color="royalblue", size=.8) + 
  geom_point(data=poi, aes(x=Long, y=Lat), color="red", size=2) + 
  theme_minimal() + 
  theme(legend.position="none", 
        axis.text=element_blank(), 
        panel.grid=element_blank()) + 
  labs(x="", y="") + 
  coord_fixed(1.3)

#g + geom_point(data=g10, aes(x=long, y=lat), color=3, size=.8) + labs(title="g10")

