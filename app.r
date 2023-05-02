library(shiny)
library(shinyWidgets)
library(shinyalert)
library(htmlwidgets)
library(bs4Dash)
library(waiter)
library(tidyverse)
library(echarts4r)
library(plotly)
library(lubridate)
library(DT)
library(reactable)
library(reactablefmtr)

shinyApp(
  ui = bs4DashPage(
    title = "3Art",
    fullscreen = T,
    scrollToTop = T,
    dark = NULL,
#### BODY ####
    body = bs4DashBody(
      includeCSS("page.css"),
      tabItems(
        tabItem(
          tabName = "newt",
          uiOutput("newt.datebar"),
          # New training
          fluidRow(
            column(
              width = 4,
              uiOutput("newt.add")
            ),
            column(
              width = 8,
              uiOutput("newt.live")
            )
          )
        )
      )
    ),
#### SIDEBAR ####
    sidebar = bs4DashSidebar(
      collapsed = T,
      minified = T,
      elevation = 5,
      fixed = T,
      expandOnHover = F,
      sidebarMenu(
        id = "sidebar.main",
        menuItem(
          text = "New Training", tabName = "newt",
          icon = icon("compass")
        ),
        menuItem(
          text = "Data", tabName = "data",
          icon = icon("cogs"),
          badgeLabel = "loaded",
          badgeColor = "success"
        ),
        menuItem(
          text = "Filter", tabName = "filter",
          icon = icon("filter")
        )
      )
    ),
#### HEADER ####
    header = bs4DashNavbar(
      
    ),
#### CONTROLBAR ####
    control = bs4DashControlbar(
      
    )
  ),



#### SERVER ####
  server = function(output, input, session) {
    ### SERVER TO BODY ###
    # g.UI: Top bar - date & basic stats
    output$newt.datebar <- renderUI({
      fluidRow(
        column(
          width = 3
        ),
        column(
          width = 3
        ),
        column(
          width = 3,
          bs4Dash::valueBox(
            value = h1(Sys.Date()),
            subtitle = h3("Today's date"),
            icon = icon("calendar"),
            width = 12,
            elevation = 5,
            color = "info"
          )
        ),
        column(
          width = 3,
          bs4Dash::valueBox(
            value = h1(Sys.Time.Delay()),
            subtitle = h3("Current time"),
            icon = icon("clock"),
            width = 12,
            elevation = 5,
            color = "info"
          )
        )
      )
    })
    # g.server: Top bar - date & basic stats
    Sys.Time.Delay <- reactive({
      invalidateLater(as.integer(1000), session)
      format(Sys.time())
    })
    
    # newt.UI: new trainng poll
    output$newt.add <- renderUI({
      box(
        width = 12,
        height = "800px",
        solidHeader = T,
        status = "gray-dark",
        collapsible = T,
        maximizable = F,
        elevation = 3,
        knobInput(
          "nwet.add.weight", label = "Select a value:",
          value = 50, min = 0, max = 150
        )
      )
    })
  } 
)








