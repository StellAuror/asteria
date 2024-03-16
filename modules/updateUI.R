updateUI <- function(id, data, mainsession, isLogged) {
  moduleServer(
    id,
    function(input, output, session) {
      ### Enter Data
      # Entering exercise name - get from recent data 
      observe({
        updateSelectInput(
          session = mainsession,
          inputId = "ed.user.excercise",
          choices = unique(data()$Name)
        )
      })
    }
  )
}