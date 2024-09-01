options(scipen = 999)
spl <- function(df) {
  plotly::layout(
    df,
    xaxis = list(visible = F, showgrid = F, title = ""),
    yaxis = list(visible = F, showgrid = F, title = ""),
    hovermode = "x",
    margin = list(t = 0, r = 0, l = 0, b = 0),
    font = list(color = "white"),
    paper_bgcolor = "transparent",
    plot_bgcolor = "transparent"
  ) |>
  plotly::config(displayModeBar = F) |>
  htmlwidgets::onRender(
    "function(el) {
      el.closest('.bslib-value-box')
        .addEventListener('bslib.card', function(ev) {
          Plotly.relayout(el, {'xaxis.visible': ev.detail.fullScreen});
        })
    }"
  )
}


ui <- page_navbar(
  bg = "#313131",
  lang = "en",
  position = "static-top",
  fillable = F,
  title = "Asteria",
  sidebar = sidebar(
    width = 270, position = "left",
    open = T, bg = "#313131", 
    tagList(
      selectInput(
        "exercise", "Select an exercise",
        lapply(split(gdf$Name, gdf$Type), function(x) as.vector(x)) |> lapply(unique)
      ),
      uiOutput("yearui")
    )
  ),
  nav_spacer(),
  nav_panel(
    "main",
    # First Level
    layout_columns(
      col_widths = c(12),
      card(echarts4rOutput("p1"))
    ),
    uiOutput("vs"),
    # Second Level
    layout_columns(
      col_widths  = c(4, 4, 4),
      card(echarts4rOutput("p2a"), height = "300px"),
      card(echarts4rOutput("p2b"), height = "300px"),
      card(echarts4rOutput("p2c"), height = "300px")
    ),
    echarts4rOutput("s1")
  )
)

server <- function(input, output) {
  output$yearui <- renderUI(
    histoslider::input_histoslider(
      "year", "", gdf |> filter(Name == input$exercise) |> pull(Date)
    )
  )
  
  filtered_data <- reactive({
    req(input$year)
    
    x <- input$year
    if (x[1] == x[2]) {
      return()
    } else {
      gdf |>
        filter(
          Name == isolate(input$exercise),
          between(Date, x[1], x[2])
        ) 
    }
  })
  
  output$p1 <- renderEcharts4r({
    req(filtered_data())
    filtered_data() |>
      mutate(DateNumeric = as.numeric(Date - min(Date))) |>
      arrange(DateNumeric) |>
      e_charts(Date) |>
      e_scatter(Load, size = Weight, name = "Training Load", color = "#5662f6", itemStyle = list(opacity = 0.9), symbol_size = 4) |>
      e_loess(Load ~ DateNumeric, name = "Progress Curve", color = "#382365", lineStyle = list(width = 5), itemStyle =  list(opacity = 0)) |>
      e_brush() |> 
      e_tooltip() 
  })
  
  hover <- reactive({input$p1_brush$batch$selected[[1]]$dataIndex[[1]]}) |> throttle(3000)
  
  hovered_data <- reactive({
    hover()
    isolate({
      req(filtered_data())
      id <- hover()
      if (is.null(id) | length(id) == 0) 
        id <- 1:nrow(filtered_data())
      
      (filtered_data() |> arrange(Date))[id, ]
    })
  })
  
  
  output$p2a <- renderEcharts4r({
    req(filtered_data())
    hovered_data() |>
      e_charts() |> 
      e_histogram(serie = Rep, name = "Times Occured: ", legend = F) |> 
      e_tooltip(trigger = "axis") |>
      e_title("The Number of Repeats")
  })

  output$p2c <- renderEcharts4r({
    req(filtered_data())
    hovered_data() |>
      e_charts() |> 
      e_histogram(serie = Load, name = "Times Occured: ", legend = F) |> 
      e_tooltip(trigger = "axis") |>
      e_title("The Total Load (per exercise)")
  })
  
  output$p2b <- renderEcharts4r({
    req(filtered_data())
    hovered_data() |>
      e_charts() |> 
      e_histogram(serie = Weight, name = "Times Occured: ", legend = F) |> 
      e_tooltip(trigger = "axis") |>
      e_title("The Weight Lifted")
  })
  
  output$vs <- renderUI({
    req(filtered_data())
    
    data <- hovered_data() |> arrange(ID)
    name <- c("Total Load", "Power", "Durability", "Intensity")
    value <- c(
      sum(data$Load),
      sum(data$Load) / sum(data$Rep),
      mean(data$Rep),
      mean(data$Weight)
    ) |> round(1)
    
    
    sparkline <- list(
      plot_ly(data |> mutate(L = cumsum(Load)), x = ~ID, y = ~L, color = I("#5662f6"), type = 'scatter', mode = 'lines', fill = 'tozeroy') |> spl(),
      plot_ly(data, x = ~ID, y = ~Load, color = I("#5662f6"), type = 'scatter', mode = 'lines', fill = 'tozeroy') |> spl(),
      plot_ly(data, x = ~ID, y = ~Rep, color = I("#5662f6"), type = 'scatter', mode = 'lines', fill = 'tozeroy') |> spl(),
      plot_ly(data, x = ~ID, y = ~Weight, color = I("#5662f6"), type = 'scatter', mode = 'lines', fill = 'tozeroy') |> spl()
    )
    
    
    # bgtheme <- c("bg-gradient-indigo-blue", "bg-gradient-blue-indigo", "bg-gradient-purple-indigo", "bg-gradient-indigo-red")
    
    v <- lapply(1:4, function(x) {
      value_box(
        name[x],
        h1(span(HTML(value[x]), style = 'font-size: 32px; font-weight: bold;')),
        theme = value_box_theme(bg = "#ffffff", fg = "#5b7ad8"),
        height = 150,
        showcase = sparkline[[x]]
      )
    })
    
    layout_columns(
      col_widths = rep(3, 4),
        v[1],
        v[2],
        v[3],
        v[4]
    )
  })
  
  output$s1 <- renderEcharts4r({
    max <- list(
      name = "Max",
      type = "max"
    )
    
    min <- list(
      name = "Min",
      type = "min"
    )
    
    avg <- list(
      type = "average",
      name = "AVG"
    )
    
    filtered_data() |>
      group_by_all() |>
      summarise(
        Set = n(),
        Total = Rep * Set
      ) |>
      ungroup() |>
      group_by(Year) |>
      e_chart(Load) |>
      e_scatter(
        Weight, size = Total, 
        itemStyle = list(opacity = 0.6)
      ) |>
      e_tooltip() |>
      e_color(c("#5662f6", "#382365")) |>
      e_mark_point(data = max) |> 
      e_mark_point(data = min) |> 
      e_mark_point(data = avg)
  })
}

shinyApp(ui = ui, server = server)
