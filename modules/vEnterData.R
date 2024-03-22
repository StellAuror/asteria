uivEnterData <- function(id) {
  ns <- NS(id)
  tagList(
    conditionalPanel(
      condition = "isLogged()",
      card(
        tags$style(type = "text/css", 
                   "#weightNum.form-control.shiny-bound-input {height: 730px;}"),
        height = "450px",
        selectizeInput(
          ns("excercise"), "Excercise name", unique(data()$Name),
          options = list(create = T)
        ),
        sliderInput(
          ns("weight"), "Weight",
          0, 200, 100, .25,
          round = T, ticks = F, dragRange = T
        ),
        numericInput(
          ns("weightNum"), "",
          100, 0, 200, .25,
          
        ),
        layout_columns(
          col_widths = c(6, 6),
          numericInput(
            ns("sets"), "Sets",
            3, 1, 24
          ),
          numericInput(
            ns("reps"), "Reps",
            3, 1, 48
          )
        ),
        actionButton(ns("accept"), "Enter")
      )
    )
  )
}

servervEnterData <- function(id, data, isLogged) {
  moduleServer(
    id,
    function(input, output, session) {
      # Adjust values to users' profile
      observe({
        updateSelectInput(
          session = session, inputId = "excercise",
          choices =  unique(data()$Name)
        )
      })
      # Numeric/Slider Input synergy
      observe({
        updateSliderInput(session, "weight", value = input$weightNum)
      })
      observe({
        updateNumericInput(session, "weightNum", value = input$weight)
      })
      
      # Return input values
      returnList <- reactiveValues()
      observe({
        returnList$sets <- input$sets
        returnList$reps <- input$reps
        returnList$weight <- input$weight
        returnList$excercise <- input$excercise
      })
      return(returnList)

    }
  )
}