#R로 인터렉티브 지도 그리기(leaflet)
#install.packages('leaflet')
library(leaflet)

# 기본 지도, 대전광역시
leaflet() %>% 
  setView(lng=127.39, lat=36.35, zoom=12) %>% 
  addTiles()

# 3rd party 제공 지도

leaflet() %>% 
  setView(lng=127.39, lat=36.35, zoom=12) %>% 
  addProviderTiles('Stamen.TonerLite')
leaflet() %>% 
  setView(lng=127.39, lat=36.35, zoom=12) %>% 
  addProviderTiles('CartoDB.Positron')
leaflet() %>% 
  setView(lng=127.39, lat=36.35, zoom=12) %>% 
  addProviderTiles('Esri.NatGeoWorldMap')

# Marker 달기
leaflet() %>% 
  setView(lng=127.39, lat=36.35, zoom=12) %>% 
  addTiles() %>% 
  addMarkers(lng=127.3862, lat=36.3508, label = '대전시청')

leaflet() %>% 
  setView(lng=127.39, lat=36.35, zoom=12) %>% 
  addTiles() %>% 
  addMarkers(lng=127.3862, lat=36.3508, label = '대전시청',
             labelOptions=labelOptions(textsize='50px'))

leaflet() %>% 
  setView(lng=127.39, lat=36.35, zoom=12) %>% 
  addTiles() %>% 
  addMarkers(lng=127.3862, lat=36.3508, label = '대전시청',
             labelOptions=labelOptions(
               style=list(
                 'color'='red',
                 'font-size' = '15px',
                 'font-style'='italic'
               )
             ))

leaflet() %>% 
  setView(lng=127.39, lat=36.35, zoom=12) %>% 
  addTiles() %>% 
  addCircles(lng=127.3862, lat=36.3508, label = '대전시청', radius=1000,
             weight=1, color='#dd0022')

# 사각형 Marker
leaflet() %>% 
  setView(lng=127.39, lat=36.35, zoom=12) %>% 
  addTiles() %>% 
  addRectangles(lng1=127.39, lat1=36.34,lng2=127.38, lat2=36.36, fillColor = 'transparent')

library(dplyr)
library(httr)
library(jsonlite)
a <- c('place','addr','pop')
b <- c('대전광역시청','대전광역시 서구 둔산로 100','1551931')
c <- c('동구청','대전광역시 동구 동구청로 147','251209')
d <- c('중구청','대전광역시 중구 중앙로 100','264529')
e <- c('서구청','대전광역시 서구 둔산서로 100','499143')
f <- c('유성구청','대전광역시 유성구 대학로 211','332418')
g <- c('대덕구청','대전광역시 대덕구 대전로1033번길 20','204632')
df <- rbind(a,b,c,d,e,f,g)
df <- data.frame(df)
names(df) <- df[1,]
df <- df[-1,]
str(df)
df$pop <- as.integer(df$pop)
str(df)

addr <- df$addr[1]

## 카카오 디벨롭으로 경도 위도 뽑기
library(httr)
library(jsonlite)
library(stringr)
kakao_api_key <- readLines('OpenAPI/kakao_api_key.txt',encoding = 'UTF-8')
kakao_api_key

base_url <- 'https://dapi.kakao.com/v2/local/search/address'
keyword <- URLencode(iconv(addr, to='UTF-8'))
keyword
query <- paste0('.json&query=', keyword)
url <- paste(base_url, query, sep='?')
url
auth_key <- paste('KakaoAK', kakao_api_key)
auth_key
res <- GET(url, add_headers('Authorization'=auth_key))  #사이트에서 get 방식으로 요청했기에 get으로 함 post면 post
res
result <- fromJSON(as.character(res))
result
result$documents$x #경도
as.numeric(result$documents$x) #경도
as.numeric(result$documents$y) #위도

# df DataFrame에 위도, 경도 정보 추가하기
lngs <- c()
lats <- c()
base_url <- 'https://dapi.kakao.com/v2/local/search/address'
auth_key <- paste('KakaoAK', kakao_api_key)
for (i in 1:nrow(df)) {
  keyword <- URLencode(iconv(df$addr[i], to='UTF-8'))
  query <- paste0('.json&query=', keyword)
  url <- paste(base_url, query, sep='?')
  res <- GET(url, add_headers('Authorization'=auth_key))
  result <- fromJSON(as.character(res))
  lngs <- c(lngs, as.numeric(result$documents$x))
  lats <- c(lats, as.numeric(result$documents$y))
}
df$lng <- lngs
df$lat <- lats
df
#지도로 찍기
leaflet(df) %>% 
  setView(lng=127.39, lat=36.35, zoom=12) %>% 
  addTiles() %>% 
  addMarkers(lng=~lng, lat=~lat, 
             label = ~place, popup = ~addr) #팝업으로 찍기

df$color <- ifelse(str_length(df$place)>5,'#dd0022','#1133ee')
leaflet(df) %>% 
  setView(lng=mean(df$lng), lat=mean(df$lat), zoom=12) %>% 
  addTiles() %>% 
  addCircles(lng=~lng, lat=~lat, 
             label = ~place, popup = ~addr,
             weight=1,radius = ~pop/1000, color = ~color) 