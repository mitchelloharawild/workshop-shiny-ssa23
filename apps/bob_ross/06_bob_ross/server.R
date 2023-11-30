library(shiny)

function(input, output, session) {
  elements_filter <- reactive({
    elements %>% 
      group_by(season, episode) %>% 
      filter(all(input$elements %in% element[exists])) %>% 
      filter(between(season, input$seasons[1], input$seasons[2])) %>% 
      filter(!(element %in% input$elements))
  })
  
  elements_prop <- reactive({
    elements_filter() %>% 
      group_by(element) %>% 
      summarise(proportion = mean(exists)) %>% 
      arrange(desc(proportion)) %>% 
      mutate(element = fct_reorder(element, proportion))
  })
  
  output$plot_proportion <- renderPlot({
    elements_prop() %>% 
      ggplot(aes(x = proportion, y = element)) + 
      geom_col(fill = "white") +
      scale_x_continuous(labels = scales::percent, limits = c(0,1)) + 
      theme(
        panel.background = element_rect(fill='transparent'),
        plot.background = element_rect(fill='transparent', color=NA),
        legend.background = element_rect(fill='transparent'),
        legend.box.background = element_rect(fill='transparent'),
        text = element_text(colour = "white"),
        axis.text = element_text(colour = "white")
      )
  }, bg = "transparent")
  
  output$data_proportion <- renderTable({
    elements_prop() %>% 
      top_n(10, proportion)
  })
}
