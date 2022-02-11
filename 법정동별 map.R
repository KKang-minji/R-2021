
#shape 파일로부터 단계구분도 그리기
# 대전 법정동 단계구분도
library(raster)
library(leaflet)
library(sp)
library(rgdal)

shp.file <- file.choose()
map <- shapefile(shp.file)
map <- spTransform(map, CRSobj = CRS(
  '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'
))
slotNames(map)    #"SpatialPolygonsDataFrame"

leaflet(map) %>% 
  setView(lng=127.39, lat = 36.35, zoom = 11) %>% 
  addProviderTiles('Stamen.TonerLite') %>% 
  addPolygons(
    fillColor = 'yellow',
    weight = 2,
    opacity = 1,   #불투명도
    color = 'blue',  #선색색
    dashArray = '3',
    fillOpacity = 0.7
  )

#동별로 단계 구분도 그리기
head(map@data)   #EMD_NM: 동이름
rand <- sample(100:1000, 177)
map@data$rand <- rand    #rand기준으로
EM <- map@data$EMD_NM 
typeof(EM)
as.vector(EM)
pal <- colorNumeric('RdPu', NULL)
leaflet(map) %>% 
  setView(lng=127.39, lat = 36.35, zoom = 11) %>% 
  addProviderTiles('Stamen.TonerLite') %>% 
  addPolygons(
    fillColor = ~pal(rand),
    weight = 2,
    opacity = 1,   #불투명도
    color = 'white',  #선색
    dashArray = '3',
    fillOpacity = 0.7,
    highlight= highlightOptions(
      weight = 3, color = '#999', dashArray = '',
      fillColor = 0.7, bringToFront = T
    ),
    label = ~EMD_NM
  ) %>% 
  addLegend(pal=pal, values = ~rand, opacity = 0.7, 
            title = '랜덤값', position='bottomright')





shp <- rgdal::readOGR(shp.file)

shp@data

file.choose()



