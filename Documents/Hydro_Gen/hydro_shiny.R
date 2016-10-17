
library(shiny)
library(plotly)


ui <- shinyUI(fluidPage(

   titlePanel("Mexico's Hydro Generation 2016"),

   sidebarLayout(
      sidebarPanel(
         sliderInput("slider1", "Choose a Month:", min = 1, max = 12, value = 1),
         width = 3
      ),

      mainPanel(
        plotlyOutput("plot")
      ))
))

server <- shinyServer(function(input, output) {

  days_m <- reactive({
    hydro_gen <- read.csv("generacionHidro.csv")
    hydro_gen$FECHA <- as.Date(hydro_gen$FECHA, "%d/%m/%y")
    month <- sprintf("%02d",input$slider1)
    hydro_month <- subset(hydro_gen, format.Date(FECHA, "%m")== month)
    dup <- duplicated(format.Date(hydro_month$FECHA, "%d"))
    days <- format.Date(hydro_month[!dup,]$FECHA, "%d")
    matrix(hydro_month$TOTAL, nrow = 24, ncol = length(days))
  })

  output$plot <- renderPlotly({
    plot_ly(z=days_m(), type="surface") %>%
    layout(
      scene =
        list(
          xaxis = list(title="Days"),
          yaxis = list(title="Hours"),
          zaxis = list(title="MWh", range=c(0,9000))
      ),
      autosize=F, width=1000, height=800
    )
  })

})

# Run the application
shinyApp(ui = ui, server = server)

