# Server Side
getData <- function(id, path) {
  moduleServer(id, function(input, output, session) {
    ### load config env
    config <- config::get(config = "default")
    
    ### establish connection with mongoDB
    mongo_uri <- glue(
      "mongodb+srv://{config$mongoLogin}:{config$mongoPass}@{config$mongoHost}.mongodb.net/{config$mongoDB}"
    )
    conn <- mongo(collection = config$mongoCollGym, url = mongo_uri)
    gdf <- conn$find() 
    
    ### change names & date adjustment
    gdf <- gdf %>%  mutate(Data = as.Date(Data, origin = "1900-01-01"))
    names(gdf) <- c(
      "id", "name", "weight", "set", "rep", "date", "year",
      "load", "type", "failed_reps", "failed_load"
    )
    
    gdf
  })
}
