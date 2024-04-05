pacman::p_load(readr,lubridate,tidyverse,shiny,ggplot2,purrr)

ui <- fluidPage(
  selectInput("a","a",choices = c("COAL2","COAL4")),
  fileInput("b","b",accept = "csv"),
  downloadButton("d"),
  tableOutput("c"),
  plotOutput("e")
)

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

server <- function(input, output, session) {
  r<-reactive({
    Data<-read.csv(input$b$datapath)
    # Data <- fee(Data) %>% fei() %>% map(foe)
    # Data <- Data$input
  })
  
  output$c<-renderTable({
    print(r())
  })
  
  output$e<-renderPlot({
    plot(r())
  })
  
  output$d <- downloadHandler(
    filename = function() {
      paste0(input$a, ".csv")
    },
    content = function(file) {
      write.csv(r(), file)
    }
  )
}
shinyApp(ui, server)
