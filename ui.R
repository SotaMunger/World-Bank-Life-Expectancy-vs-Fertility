#read in world bank csv file and omit na's (which includes 2018 data)
df <- read.csv("WorldBankData.csv")
df <- na.omit(df)

#import libraries
library(shiny)
library(dplyr)
library(plotly)

# Define UI for region, country, and year selection, and plotly graph output 
shinyUI(

  fluidPage(
    sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "region",
                    label = "Select a Region",
                    choices = c("All Regions", unique(df$Region))
        ),
        selectInput(inputId = "country",
                    label = "Select a Country",
                    choices = NULL
        ),
        sliderInput(inputId = 'yeardata',
                    label = "Select a Year",
                    min = min(df$Year),
                    max = max(df$Year),
                    value = min(df$Year),
                    step = 1,
                    sep = '',
                    ticks = FALSE,
                    animate = animationOptions(interval = 200,
                                               loop = FALSE))
      ),
      mainPanel(
        plotlyOutput("scatter", height = "400px")
      )
    )
  )
)