#Application works perfectly

if (!requireNamespace("pacman", quietly = TRUE)) {
  install.packages("pacman")
}
pacman::p_load(readr, lubridate, shiny, ggplot2, DT, testthat)

ui <- fluidPage(
  titlePanel("Argus Commodities Indices Calculator"),
  theme = bslib::bs_theme(bootswatch = "darkly"),
  fluidRow(
    column(4, fileInput("b", "Upload Data.csv", accept = "csv")),  
    column(4, selectInput("a", "Select Index", choices = c("COAL2", "COAL4"))),  
    column(4)  
  ),  
  fluidRow(
    column(6, DT::dataTableOutput("c")),  
    column(6, plotOutput("e"))  
  ),  
  fluidRow(
    column(12, downloadButton("d"))  
  )  
)


server <- function(input, output, session) {
  thematic::thematic_shiny()
  s<-reactive({
    req(input$b)
    read.csv(input$b$datapath)})

  r<-reactive({
    req(input$b)
    Data<-read.csv(input$b$datapath)
    Data$delvdate <- paste("1", Data$DELIVERY.MONTH, Data$DELIVERY.YEAR)
    # Assumed the delivery date was "1st" of the month
    Data$DEAL.DATE <- dmy(Data$DEAL.DATE)
    Data$delvdate <- dmy(Data$delvdate)
    Data$datediff <- Data$delvdate - Data$DEAL.DATE
    Data$ID<-NULL
    Data$DELIVERY.MONTH<-NULL
    Data$DELIVERY.YEAR<-NULL
    Data$delvdate<-NULL
    Data <- Data[Data$datediff >= 0 & Data$datediff <= 180, ]
    Data <- Data[Data$COMMODITY == "Coal", ]
    eu <- Data[Data$DELIVERY.LOCATION %in% c("ARA", "AMS", "ROT", "ANT"), ]
    sa <- Data[Data$DELIVERY.LOCATION %in% "SOT", ]
    Data<-list(COAL2 = eu, COAL4 = sa)
    Data<-Data[[input$a]]
    Data$Value <- Data$VOLUME * Data$PRICE
    agg_data <- aggregate(cbind(Volume = Volume, Value = Value) ~ DEAL.DATE, data = Data, FUN = sum)
    agg_data$VWAP <- agg_data$Value / agg_data$Volume    
    #Avoided dplyr due to tidy evaluation inconsistencies in shiny
    Data$VOLUME<-NULL
    Data$VWAP<-Data$PRICE
    Data$PRICE<-NULL
    print(Data)
  })
  
  observeEvent(input$b, {
    test_that("Check Input Data Columns", {
      expect_true(ncol(s()) >= 9, "Input data does not have at least 9 columns")
    })
  })
  #check if input is correct
  
  output$c<-DT::renderDataTable({
    r()
  })
  #Use DT always 
  output$e<-renderPlot({
    ggplot(r(), aes(x = DEAL.DATE, y = VWAP)) +
      geom_line(color = "#00891a") +
      geom_point() +
      geom_smooth(method = "lm", se =T, color = "#0275d8") +  # Add linear regression line
      labs(x = "Date", y = "VWAP", title = "Volume Weighted Average Price (VWAP) Over Time") +
      theme(panel.grid.major = element_blank(), 
            panel.grid.minor = element_line(color = "white", size = 0.1))
    
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
