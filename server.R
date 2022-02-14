
shinyServer(function(input, output, session) {

    dfreact <- reactive(read.csv("WorldBankData.csv"))
    
    # observe whether input region changes, if so update country dropdown
    observeEvent(list(input$region), {
        if (list(input$region) != "All Regions") {
            updateSelectInput(session, "country", choices = c("All Countries", unique(dfreact()$Country[dfreact()$Region == input$region])))
        }
        else {
            updateSelectInput(session, "country", choices = c("All Countries", unique(dfreact()$Country)))
        }
    })
    
    # filter data based on selections in drop-down menus and plot accordingly
    output$scatter <- renderPlotly({
        
        if (input$region == "All Regions" & input$country == "All Countries") {
            plot <- dfreact() %>% filter(Year == input$yeardata)
        }
        else if (input$region != "All Regions" & input$country == "All Countries") {
            plot <- dfreact() %>% filter(Region == input$region) %>% filter(Year == input$yeardata)
        }
        else {
            plot <- dfreact() %>% filter(Country == input$country) %>% filter(Year == input$yeardata)
        }
        
            
        plot_ly(data=plot,
                type = "scatter",
                mode = "markers",
                x = ~Fertility,
                y = ~LifeExpectancy,
                size = ~Population,
                color = ~Region,
                text = plot$Country,
                hoverinfo = 'text'
                
        ) %>%
            layout(
                title = list(text="World Bank Data for Life Expectancy and Fertility", xref="paper"),
                xaxis = list(title="Fertility (births per woman)", range=c(0,10), zeroline=FALSE),
                yaxis = list(title="Life Expectancy (years)", range=c(0,90))
            )
    })
    
    
})