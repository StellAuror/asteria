server <- function(input, output, session) {
  ### Temporary source() workaround
  modules <- dir("modules", full.names = T, recursive = T)
  lapply(modules, source)
  
  ### Raw data in data frame convention
  dfGymRaw <- reactiveVal(NULL)
  observe(dfGymRaw(getData("init" ,"data/gymdata.csv")))
  
  ### Processing modules server side
  serverTableGymOverview("EnterData1", reactive(dfGymRaw()))
  serverLineGymNew("EnterData2", reactive(dfGymRaw()))
  
  
  ### update UI
  updateUI("init", reactive(dfGymRaw()), session)
}
