server <- function(input, output, session) {
  ### Temporary source() workaround
  modules <- dir("modules", full.names = T, recursive = T)
  lapply(modules, source)
  
  ### Loading Data into app
  dataList <- reactiveValues()
  userCred <- reactiveVal() 
  
  
  observe({
    print("Inital refresh")
    initialData <- getData("init")
    
    dataList$main <- initialData[["gD"]]
    dataList$user <- initialData[["uD"]]
    
    #userCred(credentials()$user_auth)
    userCred(TRUE)
  })
  
  observe({
    print("Attempt to refresh...")
    print(freshData())
    if (is.data.frame(freshData())) {
      print("Data refreshed")
      dataList$main <- freshData()
    } else {print("Hesitate with refreshing")}
  })
  
  ### Login
  credentials <- shinyauthr::loginServer(
    id = "login",
    data = mongo(collection = config$mongoCollCredentials, url = mongo_uri)$find(),
    user_col = user,
    pwd_col = password,
    log_out = reactive(logout_init())
  )
  
  # call the logout module with reactive trigger to hide/show
  logout_init <- shinyauthr::logoutServer(
    id = "logout",
    active = reactive(credentials()$user_auth)
  )
  
  ### Processing modules server side
  observe({
    dataList$enteredData <- 
      servervEnterData(
        "EnterData1",
        reactive(dataList$main), reactive(userCred())
      )
  })
  servervNewRecSnap(
    "EnterData2",
    reactive(dataList$main), reactive(userCred()),
    reactive(dataList$enteredData)
  )
  servervProgressBox(
    "EnterData3",
    reactive(dataList$main), reactive(userCred()),
    reactive(dataList$enteredData)
  )
  
  freshData <- servervAddedRecs(
    "EnterData4",
    reactive(dataList$user), reactive(userCred()),
    reactive(dataList$enteredData)
  )

  servervAIRecom(
    "EnterData5",
    reactive(userCred())
  )
  
  ### update UI
  updateUI("init", reactive(dataList$main), session, reactive(userCred()))
}
