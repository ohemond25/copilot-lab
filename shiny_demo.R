# Let's make a Shiny app to present my simulations

library(shiny)
library(tidyverse)

load(here::here('data', 'onegambound_3_11.Rdata'))

# Filter the data to exclude betak of -0.9 and sigmaw of 0.1
one_gambound_3_11 <- one_gambound_3_11 %>%
  filter(betak != -0.9, sigmaw != 0.1)

# Create a Shiny UI from the one_gambound_3_11 data. With a dropdown input for sigmaw, a, and wtrig
ui <- fluidPage(
  titlePanel("One Gam Bound"),
  sidebarLayout(
    sidebarPanel(
      selectInput("sigmaw", "Select sigmaw", choices = unique(one_gambound_3_11$sigmaw)),
      selectInput("a", "Select a", choices = unique(one_gambound_3_11$a)),
      selectInput("wtrig", "Select wtrig", choices = unique(one_gambound_3_11$wtrig))
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Create a Shiny server from the one_gambound_3_11 data with a reactive function to filter the data and make a bar plot of betak vs pct_h and fill with alphak
server <- function(input, output) {
  output$plot <- renderPlot({
    one_gambound_3_11 %>%
      filter(sigmaw == input$sigmaw, a == input$a, wtrig == input$wtrig) %>%
      ggplot(aes(x = betak, y = pct_h, fill = as.factor(alphak))) +
      geom_bar(stat = "identity") +
      labs(title = "One Gam Bound",
           x = "betak",
           y = "pct_h",
           fill = "alphak")
  })
}

# Run the Shiny app
shinyApp(ui = ui, server = server)

