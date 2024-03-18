uivEnterData <- function(id) {
  ns <- NS(id)
  uiOutput(ns("ui"))
}

servervEnterData <- function(id, isLogged) {
  moduleServer(
    id,
    function(input, output, session) {
      output$ui <- renderUI({
        req(isLogged())
        tagList(
          card(
            height = "400px",
            selectizeInput(
              "excercise", "Excercise name", "",
              options = list(create = T)
            ),
            sliderInput("weight", "Weight", 0, 200, 100, 0.25, T, F, dragRange = T), 
            layout_columns(
              col_widths = c(6, 6),
              numericInput("sets", "Sets", 3, 1, 24),
              numericInput(".reps", "Reps", 3, 1, 48)
            ),
            actionButton("accept", "Enter")
          )
        )
      })
    }
  )
}