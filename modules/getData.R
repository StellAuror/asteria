# Server Side
getData <- function(id, path) {
  moduleServer(id, function(input, output, session) {
    ### Main gym data from mongoDB cloud service
    # load config & establish connection with mongo
    config <- config::get(config = "default")
    mongo_uri <- glue(
      "mongodb+srv://{config$mongoLogin}:{config$mongoPass}@{config$mongoHost}.mongodb.net/{config$mongoDB}"
    )
    gdf <- mongo(collection = config$mongoCollGym, url = mongo_uri)$find() 
    
    ### Local data - entered by user but not sent to mongoDB yet
    udf <- mongo(collection = config$mongoCollUserGym, url = mongo_uri)$find() 
    
    list("gD" = gdf, "uD" = udf)
  })
}
