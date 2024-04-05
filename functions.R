fee <- function(Data) {
  Data$delvdate <- paste("1", Data$`DELIVERY MONTH`, Data$`DELIVERY YEAR`)
  Data$`DEAL DATE` <- lubridate::as_date(Data$`DEAL DATE`)
  Data$delvdate <- dmy(Data$delvdate)
  Data$`DEAL DATE` <- as.Date(Data$`DEAL DATE`)
  Data$datediff <- Data$delvdate - Data$`DEAL DATE`
  Data$ID<-NULL
  Data$`DELIVERY MONTH`<-NULL
  Data$`DELIVERY YEAR`<-NULL
  Data$delvdate<-NULL
  Data <- Data[Data$datediff >= 0 & Data$datediff <= 180, ]
  Data <- Data[Data$COMMODITY == "Coal", ]
  Data<-print(Data)
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
