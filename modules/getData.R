# Server Side
getData <- function(id, path) {
  moduleServer(id, function(input, output, session) {
    ### Main gym data from mongoDB cloud service
    gdf <- mongo(collection = config$mongoCollGym, url = mongo_uri)$find() 
    
    ### Local data - entered by user but not sent to mongoDB yet
    udf <- mongo(collection = config$mongoCollUserGym, url = mongo_uri)$find() 
    
    list("gD" = gdf, "uD" = udf)
  })
}
