#simply run the entire script if Data.csv is in working dir 


pacman::p_load(readr,lubridate,tidyverse,shiny,ggplot2,purrr)
Data <- read_csv("Data.csv")
fee <- function(Data) {
  Data$delvdate <- paste("1", Data$`DELIVERY MONTH`, Data$`DELIVERY YEAR`)
  Data$delvdate <- dmy(Data$delvdate)
  Data$`DEAL DATE` <- dmy(Data$`DEAL DATE`)
  Data$datediff <- Data$delvdate - Data$`DEAL DATE`
  Data$ID<-NULL
  Data$`DELIVERY MONTH`<-NULL
  Data$`DELIVERY YEAR`<-NULL
  Data$delvdate<-NULL
  Data <- Data[Data$datediff >= 0 & Data$datediff <= 180, ]
  Data <- Data[Data$COMMODITY == "Coal", ]
  return(Data)
}

fei <- function(Data) {
  eu <- Data[Data$`DELIVERY LOCATION` %in% c("ARA", "AMS", "ROT", "ANT"), ]
  sa <- Data[Data$`DELIVERY LOCATION` %in% c("SOT", "UK"), ]
  return(list(eu = eu, sa = sa))
}

foe <- function(x) {
  x <- x %>%
    group_by(`DEAL DATE`) %>%
    summarise(VOLUME = sum(VOLUME), PRICE = sum(PRICE))
  x$VOLUME<-NULL
  colnames(x[1])<-"COAL2"
  colnames(x[2])<-"COAL4"
  print(x)
}

Data<-fee(Data) %>% fei() %>% map(foe)
colnames(Data$eu)<-c("DealDate","VWAP")
colnames(Data$sa)<-c("DealDate","VWAP")
names(Data)[names(Data) == "eu"] <- "COAL2"
names(Data)[names(Data) == "sa"] <- "COAL4"
plot(Data$COAL2)
plot(Data$COAL4)

