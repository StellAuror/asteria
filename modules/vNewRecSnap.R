uivNewRecSnap <- function(id) {
  ns <- NS(id)
  tagList(
  uiOutput(ns("ui"))
  )
}

servervNewRecSnap <- function(id, data, isLogged, newRecord) {
  moduleServer(id, function(input, output, session) {
    output$ui <- renderUI({
      req(isLogged())
      ns <- NS(id)
      card(
        height = "450px",
        full_screen = T,
        echarts4rOutput(ns("chart"))
      )
    })
    
    output$chart <- renderEcharts4r({
      my_scale_small <- function(x) scales::rescale(x, to = c(10, 20))
      my_scale_large <- function(x) scales::rescale(x, to = c(30, 30))
      new <- newRecord()$weight * newRecord()$sets * newRecord()$reps
      
      data() %>% 
        filter(
          Name == newRecord()$excercise,
          Weight <= quantile(Weight, .75) + IQR(Weight) * .5,
          Weight >= quantile(Weight, .25) - IQR(Weight) * .5
        ) %>%
        arrange(ID) %>%
        mutate(
          row = row_number(),
          new_record = if_else(row_number() == round(max(row) / 2, 0), new, NA),
          new_record_size = if_else(row_number() == round(max(row) / 2, 0), 10, 1),
          normalized_weight = log((max(Weight) - Weight) / (max(Weight) - min(Weight)))
        ) %>%
        e_charts(Date) %>%
        e_line(Load, color = '#4361ee', lineStyle = list(width = 3)) %>%
        e_scatter(Load, normalized_weight, scale = my_scale_small) %>%
        e_scatter(new_record, size = new_record_size, scale = my_scale_large) %>%
        e_theme_custom(
          '{
      "backgroundColor": ["#ffffff"],
      "color": ["#4361ee", "#fe3939"],
      "legend":{"textStyle": {"color": "#676971"}}
      }'
        ) %>%
        e_tooltip() %>%
        e_bar(Weight, y_index = 1,  color = '#bbbbbb')
    })
  }
  )
}
