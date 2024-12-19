library(shiny)
library(dplyr)
library(ggplot2)
library(targets)

server <- function(input, output, session) {
  # Load preprocessed data from targets pipeline
  medals <- tar_read(processed_data)
  
  # Dynamically update event names based on fuzzy search
  observe({
    # Get the unique event names
    event_list <- unique(medals$event)
    updateSelectizeInput(session, "search_event", choices = event_list, server = TRUE)
  })
  
  # Reactive dataset for filtered and sorted data
  filtered_data <- reactive({
    data <- medals
    
    # Filter based on multiple selected events
    if (!is.null(input$search_event) && length(input$search_event) > 0) {
      data <- data %>% filter(event %in% input$search_event)
    }
    
    # Filter based on selected medal type
    if (input$medal_type != "All") {
      data <- data %>% filter(medal_type == paste(input$medal_type, "Medal"))
    }
    
    # Filter based on gender
    if (input$gender_filter == "Men") {
      data <- data %>% filter(grepl("Men", event, ignore.case = TRUE))
    } else if (input$gender_filter == "Women") {
      data <- data %>% filter(grepl("Women", event, ignore.case = TRUE))
    } else if (input$gender_filter == "Others") {
      data <- data %>%
        filter(!grepl("Men", event, ignore.case = TRUE) & !grepl("Women", event, ignore.case = TRUE))
    }
    
    # Group by country and calculate total medals, sorted by descending count
    data <- data %>%
      group_by(country) %>%
      summarise(total_medals = n()) %>%
      arrange(desc(total_medals)) %>%
      slice(1:30) # Limit to top 30 countries
    
    return(data)
  })
  
  # Render bar plot
  output$medal_barplot <- renderPlot({
    data <- filtered_data()
    
    # Bar plot showing total medals by country
    ggplot(data, aes(x = reorder(country, -total_medals), y = total_medals, fill = country)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(
        title = "Top 30 Countries by Medals (2024 Paris)",
        x = "Country",
        y = "Total Medals"
      ) +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Rotate x-axis labels
  })
}
