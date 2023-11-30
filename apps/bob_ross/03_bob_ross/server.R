library(shiny)

function(input, output, session) {
  output$plot_proportion <- renderPlot({
    elements_prop <- elements %>% 
      group_by(season, episode) %>% 
      filter(all(input$elements %in% element[exists])) %>% 
      filter(between(season, input$seasons[1], input$seasons[2])) %>% 
      filter(!(element %in% input$elements)) %>% 
      group_by(element) %>% 
      summarise(proportion = mean(exists)) %>% 
      arrange(desc(proportion)) %>% 
      mutate(element = fct_reorder(element, proportion))
    
    elements_prop %>% 
      ggplot(aes(x = proportion, y = element)) + 
      geom_col() +
      scale_x_continuous(labels = scales::percent, limits = c(0,1))
  })
  
  output$data_proportion <- renderTable({
    elements %>% 
      group_by(season, episode) %>% 
      filter(all(input$elements %in% element[exists])) %>% 
      filter(between(season, input$seasons[1], input$seasons[2])) %>%
      filter(!(element %in% input$elements)) %>% 
      group_by(element) %>% 
      summarise(proportion = mean(exists)) %>% 
      arrange(desc(proportion)) %>% 
      mutate(element = fct_reorder(element, proportion)) %>% 
      top_n(10, proportion)
  })
}
