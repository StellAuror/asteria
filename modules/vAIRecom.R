uivAIRecom <- function(id) {
  ns <- NS(id)
  
  uiOutput(ns("ui"))
}

servervAIRecom <- function(id, isLogged) {
  moduleServer(
    id,
    function(input, output, session) {
      output$ui <- renderUI({
        req(isLogged())
        card(
          height = "500px",
          full_screen = T,
          card_body(
            tags$h4("GPT 3.5 Suggestions"),
            lorem::ipsum(paragraphs = 3, sentences = 5)
          )
        )
      })
    }
  )
}