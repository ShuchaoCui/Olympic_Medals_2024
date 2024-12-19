library(shiny)

ui <- fluidPage(
  titlePanel("2024 Paris Olympics Medal Analysis"), # Updated project title
  sidebarLayout(
    sidebarPanel(
      # Dropdown input for multiple event selection
      selectizeInput(
        "search_event",
        "Search Events",
        choices = NULL,
        selected = NULL,
        multiple = TRUE,
        options = list(placeholder = "Search and select events")
      ),
      # Dropdown for selecting medal type
      selectInput("medal_type", "Select Medal Type", choices = c("Gold", "Silver", "Bronze", "All")),
      # Dropdown for gender filter
      selectInput("gender_filter", "Select Gender", choices = c("All", "Men", "Women", "Others"), selected = "All"),
      # Button to update chart
      actionButton("update", "Update Chart")
    ),
    mainPanel(
      # Output bar plot
      plotOutput("medal_barplot")
    )
  )
)
