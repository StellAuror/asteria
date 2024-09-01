uivProgressBox <- function(id) {
  ns <- NS(id)
  
  uiOutput(ns("ui"))
}

servervProgressBox <- function(id, data, isLogged, newRecord) {
  moduleServer(
    id,
    function(input, output, session) {
      output$ui <- renderUI({
        req(isLogged())
        req(newRecord())
        req(data())
        
        if (is.null(newRecord()$excercise)) return()
        
        paste0(round(newRecord()$weight / (
          data() %>% 
            filter(
              Name == newRecord()$excercise,
            ) %>%
            group_by(Name) %>%
            summarise(Weight = mean(Weight, na.rm = T))
        )$Weight, 2) * 100, "%") -> force
        
        paste0(round(newRecord()$weight * newRecord()$reps / (
          data() %>% 
            filter(
              Name == newRecord()$excercise,
            ) %>%
            group_by(Name) %>%
            summarise(Load = mean(Load, na.rm = T))
        )$Load, 2) * 100, "%") -> power
        
        tagList(
          value_box(
            title = div("Force Progression", style = "font-weight: 500; font-size: 30px"),
            value = div(force, style = "font-weight: 900; font-size: 54px"),
            fill = F,
            theme = value_box_theme(bg = "#fff", fg = "#4361ee"),
            showcase = icon("dumbbell"), "correlates with the strength progress"
          ),
          value_box(
            title = div("Energy Progression", style = "font-weight: 500; font-size: 30px"),
            value = div(power, style = "font-weight: 900; font-size: 54px"),
            fill = F,
            theme = value_box_theme(bg = "#fff", fg = "#ff6723"),
            showcase = icon("fire"), "correlates with the speed and power progress",
            height = "225px"
          )
        )
      })
    }
  )
}