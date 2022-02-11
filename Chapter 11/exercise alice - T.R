# Alice in Wonderland - Word Cloud 그리기
library(tm)        # Text Mining 라이브러리
library(SnowballC) # 어간 추출 라이브러리
library(stringr)

doc <- readLines('data/Alice.txt')

doc <- Corpus(VectorSource(doc))
doc <- tm_map(doc, content_transformer(tolower))  # 소문자 변환
doc <- tm_map(doc, removeNumbers)                 # 숫자 제거
stop_words <- c(stopwords('en'), 'said')
doc <- tm_map(doc, removeWords, stop_words)       # 불용어 제거
doc <- tm_map(doc, removePunctuation)             # 구둣점 제거
doc <- tm_map(doc, stripWhitespace)               # 앞뒤 공백 제거

dtm <- DocumentTermMatrix(doc)
dim(dtm)

m <- as.matrix(dtm)   # DTM list를 matrix로 변환
v <- sort(colSums(m), decreasing = T)
df <- data.frame(word=names(v), freq=v)
head(df)

library(wordcloud2)
# library(htmlwidgets)
# library(htmltools)
# library(jsonlite)
# library(yaml)
# library(base64enc)

alice <- df[1:500,]
wordcloud2(alice, shape='cardioid')
# wordcloud2(alice, figPath='data/Alice_mask.png', size=1.5,
#            color='skyblue', backgroundColor='white')
# letterCloud(alice, 'A', wordSize = 2)