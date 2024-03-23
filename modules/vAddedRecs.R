### UI Side
uivAddedRecs <- function(id) {
  ns <- NS(id)
  tagList(
    uiOutput(ns("ui"))
  )
}
### Server Side
servervAddedRecs <- function(id, data, isLogged, userEntered) {
  moduleServer(id, function(input, output, session) {
    # Data
    backlogData <- reactiveVal()
    # load data from server on start up
    observe({
      req(userEntered()$accept)
      if (userEntered()$accept == 1) {
        backlogData(data())
      }
      # combine entered data + backlog
      isolate(
        backlogData(
          rbind(
            backlogData(),
            data.frame(
              ID = max(backlogData()$ID, na.rm = T) + 1,
              Name = userEntered()$excercise,
              Weight = userEntered()$weight,
              Date = Sys.Date(),
              Sets = userEntered()$sets,
              Reps = userEntered()$reps
            )
          )
        )
      )
    })
    
    # UI output
    output$ui <- renderUI({
      req(isLogged())
      ns <- NS(id)
      card(
        height = "500px",
        full_screen = T,
        layout_sidebar(
          open = F,
          sidebar = sidebar(
            width = 160,
            actionButton("add", "Add"),
            actionButton("undo", "Undo"),
            actionButton("clear", "Clear")
          ),
          reactableOutput(ns("table"))
        )
      )
    })
    # Reactable output
    output$table <- renderReactable({
      req(backlogData())
      backlogData() %>% filter(ID != 0) %>%
        mutate(Load = Weight * Reps * Sets) %>%
        reactable(
          defaultSorted = 'ID',
          defaultPageSize = 8,
          paginationType = 'jump',
          columns = list(
            ID = colDef(
              minWidth = 40,
              cell = pill_buttons(
                data = .,
                colors  = '#4361ee',
                opacity = 0.8
              )
            ),
            Name = colDef(maxWidth = 100),
            Load = colDef(
              name = 'Total load',
              align = 'left',
              minWidth = 250,
              cell = data_bars(
                data = .,
                fill_color = '#4361ee',
                background = "#cccccc",
                #number_fmt = scales::percent,
                text_position = 'outside-base',
                max_value = max(.$Load),
                text_color = '#4361ee',
                round_edges = TRUE,
                icon = "fire-flame-curved",
                icon_color = "#2d41a1"
              )
            ),
            Weight = colDef(
              name = 'Weight lifted',
              align = 'left',
              minWidth = 250,
              cell = data_bars(
                data = .,
                fill_color = '#4361ee',
                background = "#cccccc",
                #number_fmt = scales::percent,
                text_position = 'outside-base',
                max_value = max(.$Weight),
                text_color = '#4361ee',
                round_edges = TRUE,
                icon = "fire-flame-curved",
                icon_color = "#2d41a1"
              )
            ),
            Date = colDef(
              minWidth = 125,
              cell = pill_buttons(
                colors  = '#4361ee',
                data = .,
                opacity = 0.8
              )
            ),
            Reps = colDef(
              name = "Reps Done",
              maxWidth = 150, 
              align = 'center',
              cell = icon_assign(
                data = .,
                fill_color = '#4361ee',
                empty_color = '#0c0223',
                empty_opacity = 0.8,
                icon_size = 12,
                icon = 'dumbbell'
              )
            ),
            Sets = colDef(
              name = "Reps Done",
              maxWidth = 150, 
              align = 'center',
              cell = icon_assign(
                data = .,
                fill_color = '#4361ee',
                empty_color = '#0c0223',
                empty_opacity = 0.8,
                icon_size = 12,
                icon = 'dumbbell'
              )
            )
          )
        ) 
    })
  }
  )
}
