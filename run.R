  library(tidyverse)
  library(shiny)
  library(bslib)
  library(htmltools)
  library(lorem)
  library(echarts4r)
  library(reactable)
  library(reactablefmtr)
  library(bsicons)
  library(glue)
  # library(config) - better to use namespace:: due to the conflicting funs
  library(mongolite)
  
  # Load Shiny Modules
  modules <- dir("modules", full.names = T, recursive = T)
  lapply(modules, source)
  # Load Shiny Core
  source("ui.R")
  source("server.R")
  
  # load config & establish connection with mongo
  config <- config::get(config = "default")
  mongo_uri <- glue(
    "mongodb+srv://{config$mongoLogin}:{config$mongoPass}@{config$mongoHost}.mongodb.net/{config$mongoDB}"
  )
  
  shinyApp(ui, server)
  