  library(tidyverse)
  library(shiny)
  library(bslib)
  library(htmltools)
  library(lorem)
  library(echarts4r)
  library(reactable)
  library(reactablefmtr)
  library(bsicons)
  
  # Load Shiny Modules
  modules <- dir("modules", full.names = T, recursive = T)
  lapply(modules, source)
  # Load Shiny Core
  source("ui.R")
  source("server.R")

  
  shinyApp(ui, server)  
