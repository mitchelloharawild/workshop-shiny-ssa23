library(shiny)
library(dplyr)

starwars <- dplyr::starwars %>%
  select(-films, -vehicles, -starships)

ui <- fluidPage(titlePanel("Starwars characters"), sidebarLayout(
  sidebarPanel(
    sliderInput("height", "Height: ", min = 0, max = max(starwars$heihgt, na.rm = TRUE), value = c(0, max(starwars$height, na.rm = TRUE))),
    sliderInput(
      min = 0, "mass", "Mass: ",
      max = max(starwars$mass,
        na.rm = TRUE
      ),
      value = c(0, max(starwars$mass, na.rm = TRUE))
    ),
    checkboxGroupInput("gender", "Gender:",
      choices = trimws(format(unique(starwars$gender))),
      selected = trimws(format(unique(starwars$gender)))
    ),
    selectizeInput("Species:",
      inputId = "species",
      choices = trimws(format(unique(starwars$species))), ,
      selected = trimws(format(unique(starwars$species))), multiple = TRUE
    )
  ),

  mainPanel(
    tableOutput("characters")
  )
))

server <- function(input, output, session) {
  character_data <- reactive({
    starwars %>%
      filter(
        between(height, input$height[1], input$height[2]),
        between(mass, input$mass[1], input$mass[2])
      ) %>%
      filter(
        trimws(format(gender)
  ) %in% input$gender,trimws(format(species)) %in% input$species
      )
  })

  output$characters <- renderTable({
    character_data()
  })
}

shinyApp(ui, server)
