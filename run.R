pacman::p_load(
  "tidyverse",
  "shiny",
  "bslib",
  "htmltools",
  "lorem",
  "plotly",
  "echarts4r",
  "reactable",
  "reactablefmtr",
  "bsicons",
  "glue",
  "mongolite",
  "config",
  "knitr",
  "markdown",
  "waiter",
  "shinycssloaders"
)
  
  # load config & establish connection with mongo
  config <- config::get(config = "default")
  mongo_uri <- glue(
    "mongodb+srv://{config$mongoLogin}:{config$mongoPass}@{config$mongoHost}.mongodb.net/{config$mongoDB}"
  )

  # Load Shiny Modules
  modules <- dir("modules", full.names = T, recursive = T)
  lapply(modules, source)
  # Load Shiny Core
  source("ui.R")
  source("server.R")
  
  shinyApp(ui, server)
  