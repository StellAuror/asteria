### Server (no ui)
getData <- function(id, path) {
  moduleServer(id, function(input, output, session) {
    print("getting data...")
    # Main gym data from mongoDB cloud service
    gdf <- mongo(collection = config$mongoCollGym, url = mongo_uri)$find() |>
      select(-MuscleGroup)
    
    # Local data - entered by user but not sent to mongoDB yet
    udf <- mongo(collection = config$mongoCollUserGym, url = mongo_uri)$find() |>
      select(-MuscleGroup)
    
    list("gD" = gdf, "uD" = udf)
  })
}
