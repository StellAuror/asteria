# Server Side
getGymData <- function(id, path) {
  moduleServer(id, function(input, output, session) {
    ### Load data
    gdf <- read_delim(
      path, 
      delim = ";",
      escape_double = F,
      locale = locale(encoding = "WINDOWS-1252", asciify = T), 
      na = "empty", 
      trim_ws = T
    )
    
    ### Proper names
    gdf <- janitor::clean_names(gdf)
    gdf <- gdf %>%  mutate(data = as.Date(data, origin = "1900-01-01"))
    names(gdf) <- c(
      "id", "name", "weight", "set", "rep", "date", "year",
      "load", "type", "failed_reps", "failed_load"
    )
    
    gdf
  })
}
