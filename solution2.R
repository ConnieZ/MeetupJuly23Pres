#Solution to transforming the Shiny app code to work for exercise plot

#server.R
library(shiny)
require(rCharts)
library(nycflights13)
library(reshape2)


#reading and manipulating data
delayed <- aggregate(flights$dep_delay, by=list(carrier = flights$carrier, origin = flights$origin), mean, na.rm = TRUE)
delayed <- melt(dcast(delayed, carrier ~ origin, value.var = "x", sum), id="carrier")
delayed <- merge(delayed, airlines)
names(delayed) <- c("carrier", "origin", "delay", "name")
delayed$delay <- round(delayed$delay, digits = 1)


#actual server code
shinyServer(function(input, output) {
  output$myChart <- renderChart({
    delayedPlot <- hPlot(x="name", y="delay", type="bar", group = "origin", data=delayed, title = "Average Delay Time by Carrier")
    delayedPlot$xAxis(type = "category", title = list(text = "Delay in Min"))
    delayedPlot$yAxis(title = list(text = "Carrier"))
    delayedPlot$chart(width = 700, height = 600)
    delayedPlot$addParams(dom = "myChart")
    return(delayedPlot)
  })
})

#ui.R
library(shiny)
require(rCharts)

shinyUI(fluidPage(
  titlePanel("Delay by Airline and Airport"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("See the delay time for Airlines that flew from NYC in 2013."),
      br(),
      helpText("Hover over the data point to see the values."),
      br()
      #       selectInput(inputId = "x",
      #                   label = "Choose Type of Base",
      #                   choices = c("Air Force Bases" = "AirForce", "All Military Bases" = "Total"),
      #                   selected = "Total")
    ),
    mainPanel(
      div(class='wrapper',
          tags$style(".highcharts{ height: 600px; width: 700px;}"),
          showOutput("myChart","highcharts")
      )
    )
  )))