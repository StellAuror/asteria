uiLineGymNew <- function(id) {
  ns <- NS(id)
  tagList(
    echarts4rOutput(ns("chart"))
  )
}

serverLineGymNew <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    output$chart <- renderEcharts4r({
      my_scale_small <- function(x) scales::rescale(x, to = c(10, 20))
      my_scale_large <- function(x) scales::rescale(x, to = c(30, 30))
      
      data() %>% 
        filter(
          name == "Wyciskanie",
          weight <= quantile(weight, .75) + IQR(weight) * .5,
          weight >= quantile(weight, .25) - IQR(weight) * .5
        ) %>%
        arrange(id) %>%
        mutate(
          row = row_number(),
          new_record = if_else(row_number() == round(max(row), 0), 2100, NA),
          new_record_size = if_else(row_number() == round(max(row), 0), 10, 1),
          normalized_weight = log((max(weight) - weight) / (max(weight) - min(weight)))
        ) %>%
        e_charts(row) %>%
        e_line(load, color = '#4361ee', lineStyle = list(width = 3)) %>%
        e_scatter(load, normalized_weight, scale = my_scale_small) %>%
        e_scatter(new_record, size = new_record_size, scale = my_scale_large) %>%
        e_theme_custom(
          '{
          "backgroundColor": ["#ffffff"],
          "color": ["#4361ee", "rgba(24, 34, 83, 1)"],
          "legend":{"textStyle": {"color": "#676971"}}
          }'
        ) %>%
        e_tooltip() %>%
        e_bar(weight, y_index = 1,  color = '#a6c0ee')
    })
  }
  )
}
