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
    newData <- reactiveVal()
    backlogData <- reactiveVal()
    wasFetched <- reactiveVal(value = F)
    # load data from server on start up
    observe({
      req(userEntered()$accept)
      if (userEntered()$accept == 1) {
        print(data())
        backlogData(
          data() |>
            mutate(Date = as.Date(Date, format = "%Y-%m-%d"))
        )
      }
      # combine entered data + backlog
      isolate(
        backlogData(
          rbind(
            backlogData(),
            data.frame(
              ID = max(
                mongo(collection = config$mongoCollGym, url = mongo_uri)$find()$ID, na.rm = T,
                backlogData()$ID
              ) + 1,
              Name = userEntered()$excercise,
              Weight = userEntered()$weight,
              Date = as.Date(userEntered()$date, origin = "1970-01-01"),
              Rep = userEntered()$reps,
              Load = userEntered()$weight * userEntered()$reps,
              Type = userEntered()$type,
              Year = year(as.Date(userEntered()$date, origin = "1970-01-01"))
            )
          )
        )
      )
    })
    
    # Sidebar buttons management
    observeEvent(NS(input$undo, "ui"), {
      req(backlogData())
      nRows  <- nrow(backlogData())
      if (nRows > 1) {
        backlogData(
          backlogData()[-nRows, ]
        )
      }
    })
    
    observeEvent(NS(input$clear, "ui"), {
      req(backlogData())
      nRows  <- nrow(backlogData())
      backlogData(
        backlogData()[1,]
      )
    })
    
    observeEvent(NS(input$add, "ui"), {
      req(input$add)
      req(backlogData())
      
      # Check the nrow to validate insert
      nRowOld <- nrow(mongo(collection = config$mongoCollGym, url = mongo_uri)$find())
      mongo(collection = config$mongoCollGym, url = mongo_uri)$insert(
        backlogData() %>% filter(ID != 0)
      )
      nRowNew <- nrow(mongo(collection = config$mongoCollGym, url = mongo_uri)$find())
      if (nRowNew == nRowOld) {
        showNotification(
          "Something went wrong! Data was not uploaded to MongoDB, please reload the webpage.",
          action = a(href = "javascript:location.reload();", "Reload page")
        )
        return(F)
      }
      
      showNotification(
        "Data Successfuly Uploaded to MongoDB",
         #action = a(href = "javascript:location.reload();", "Reload page")
      )
      ### send data to mongoDB
      newData(getData("init")[["gD"]])
      ### Clear table
      nRows  <- nrow(backlogData())
      backlogData(
        backlogData()[1,]
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
            actionButton(ns("add"), "Add"),
            actionButton(ns("undo"), "Undo"),
            actionButton(ns("clear"), "Clear")
          ),
          reactableOutput(ns("table"))
        )
      )
    })
    # Reactable output
    output$table <- renderReactable({
      req(backlogData())
      backlogData() %>% filter(ID != 1) %>%
        select(-Year) %>%
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
            Rep = colDef(
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
            )#,
            #Sets = colDef(
            #  name = "Reps Done",
            #  maxWidth = 150, 
            #  align = 'center',
            #  cell = icon_assign(
            #    data = .,
            #    fill_color = '#4361ee',
            #    empty_color = '#0c0223',
            #    empty_opacity = 0.8,
            #    icon_size = 12,
            #    icon = 'dumbbell'
            #  )
            #)
          )
        ) 
    })
    return(newData)
  }
  )
}
