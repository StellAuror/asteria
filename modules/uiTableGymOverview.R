# theme <- reactableTheme(
#   color = "hsl(233, 9%, 87%)",
#   backgroundColor = "#212121",
#   borderColor = "hsl(233, 9%, 22%)",
#   stripedColor = "hsl(233, 12%, 22%)",
#   highlightColor = "hsl(233, 12%, 24%)",
#   inputStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
#   selectStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
#   pageButtonHoverStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
#   pageButtonActiveStyle = list(backgroundColor = "hsl(233, 9%, 28%)")
# )

uiTableGymOverview <- function(id) {
  ns <- NS(id)
  tagList(
    reactableOutput(ns("table"))
  )
}

serverTableGymOverview <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    output$table <- renderReactable({
      data() %>% head(10) %>%
        select("id", "date", "name", "load", "weight", "set", "rep") %>%
        reactable(
          #theme = theme,
          defaultSorted = 'id',
          defaultPageSize = 5,
          paginationType = 'jump',
          columns = list(
            id = colDef(
              minWidth = 40,
              cell = pill_buttons(
                data = .,
                colors  = '#4361ee',
                opacity = 0.8
              )
            ),
            name = colDef(maxWidth = 100),
            load = colDef(
              name = 'Total load',
              align = 'left',
              minWidth = 250,
              cell = data_bars(
                data = .,
                fill_color = '#4361ee',
                background = "#cccccc",
                #number_fmt = scales::percent,
                text_position = 'outside-base',
                max_value = max(.$load),
                text_color = '#4361ee',
                round_edges = TRUE,
                icon = "fire-flame-curved",
                icon_color = "#2d41a1"
              )
            ),
            weight = colDef(
              name = 'Weight lifted',
              align = 'left',
              minWidth = 250,
              cell = data_bars(
                data = .,
                fill_color = '#4361ee',
                background = "#cccccc",
                #number_fmt = scales::percent,
                text_position = 'outside-base',
                max_value = max(.$weight),
                text_color = '#4361ee',
                round_edges = TRUE,
                icon = "fire-flame-curved",
                icon_color = "#2d41a1"
              )
            ),
            date = colDef(
              minWidth = 125,
              cell = pill_buttons(
                colors  = '#4361ee',
                data = .,
                opacity = 0.8
              )
            ),
            set = colDef(
              name = "Sets Done",
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
            rep = colDef(
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
