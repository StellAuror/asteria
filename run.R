testApp <- function() {
  library(tidyverse)
  library(shiny)
  library(bslib)
  library(htmltools)
  library(lorem)
  library(echarts4r)
  library(reactable)
  library(reactablefmtr)
  
  # Load Shiny Core
  source("ui.R")
  source("server.R")
  # Load Shiny Modules
  modules <- dir("modules", full.names = T, recursive = T)
  lapply(modules, source)
  
  shinyApp(ui, server)  
}

testApp() 
