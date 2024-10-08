uivEnterData <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("ifLogged"))
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
      
      output$ifLogged <- renderUI({
        if (!isLogged()) return()
        ns <- NS(id)
        card(
          tags$style(type = "text/css", 
                     "#weightNum.form-control.shiny-bound-input {height: 730px;}"),
          height = "450px",
          selectizeInput(
            ns("excercise"), "Excercise name", unique(data()$Name),
            options = list(create = T), width = "100%"
          ),
          selectizeInput(
            ns("type"), "Type", c("Dumbell", "Bar", "Other"),
            options = list(create = T), width = "100%"
          ),
          numericInput(
            ns("weight"), "Weight",
            100, 0, 200, .25,
            width = "100%"
          ),
          layout_columns(
            col_widths = c(6, 6, 12),
            numericInput(
              ns("reps"), "Reps",
              3, 1, 48
            ),
            dateInput(ns("date"), "Pick date")
          ),
          actionButton(ns("accept"), "Enter")
        )
      })

      # Return input values
      returnList <- reactiveValues()
      observe({
        #returnList$sets <- input$sets
        returnList$reps <- input$reps
        returnList$weight <- input$weight
        returnList$excercise <- input$excercise
        returnList$accept <- input$accept
        returnList$date <- input$date
        returnList$type <- input$type
        
        print(returnList)
      })
      return(returnList)
    }
  )
}