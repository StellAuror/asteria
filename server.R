server <- function(input, output, session) {
  ### Temporary source() workaround
  modules <- dir("modules", full.names = T, recursive = T)
  lapply(modules, source)
  
  ### Raw data in data frame convention
  dfGymRaw <- reactiveVal(NULL)
  observe(dfGymRaw(getGymData("init" ,"data/gymdata.csv")))
  
  serverTableGymOverview("EnterData", reactive(dfGymRaw()))
}