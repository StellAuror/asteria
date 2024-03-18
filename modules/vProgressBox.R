uivProgressBox <- function(id) {
  ns <- NS(id)
  
  uiOutput(ns("ui"))
}

servervProgressBox <- function(id, isLogged) {
  moduleServer(
    id,
    function(input, output, session) {
      output$ui <- renderUI({
        req(isLogged())
        tagList(
          value_box(
            title = div("Progress", style = "font-weight: 500; font-size: 30px"),
            value = div("24%", style = "font-weight: 900; font-size: 54px"),
            fill = F,
            theme = value_box_theme(bg = "#fff", fg = "#4361ee"),
            showcase = icon("dumbbell"), "correlates with the strength and force progress"
          ),
          value_box(
            title = div("Progress", style = "font-weight: 500; font-size: 30px"),
            value = div("-13%", style = "font-weight: 900; font-size: 54px"),
            fill = F,
            theme = value_box_theme(bg = "#fff", fg = "#515151"),
            showcase = icon("fire"), "correlates with the speed and power progress"
          )
        )
      })
    }
  )
}