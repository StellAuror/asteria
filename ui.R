#### External UI --------------------------
## Panel - Header Constants
uiTitle <- tags$span(
  tags$img(
    src = "www/tk.png",
    height = "50px",
    class = "me-3",
    alt = "Shiny hex logo"
  ),
  "myDay"
)
## Panel - Reference to GitHub Repo
uiPanelGitHub <- tags$a(
  tags$span(bsicons::bs_icon("code-slash"), "Source code"),
  href = "https://github.com/",
  target = "_blank"
)

#### UI --------------------------
ui <- page_navbar(
  bg = "#171717",
  lang = "en",
  position = "static-top",
  fillable = F,
  title = "Asteria",
  sidebar = sidebar(
    width = 270, position = "left",
    open = F, bg = "#171717", "left"
  ),
  nav_spacer(),
  ### Panel - Entering Data
  nav_panel(
    "Enter Data",
    # add login panel UI function
    shinyauthr::loginUI(id = "login"),
    # First Level
    layout_columns(
      col_widths  = c(2, 7, 3),
      card(
        height = "400px",
        selectizeInput(
          "ed.user.excercise", "Excercise name", "",
          options = list(create = T)
        ),
        sliderInput("ed.user.weight", "Weight", 0, 200, 100, 0.25, T, F, dragRange = T), 
        layout_columns(
          col_widths = c(6, 6),
          numericInput("ed.user.sets", "Sets", 3, 1, 24),
          numericInput("ed.user.reps", "Reps", 3, 1, 48)
        ),
        actionButton("ed.user.accept", "Enter")
      ),
      uiLineGymNew("EnterData2"),
      layout_column_wrap(
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
    ),
    # Second Level
    layout_columns(
      col_widths = c(10, 2),
      uiTableGymOverview("EnterData1"),
      card(
        height = "500px",
        full_screen = T,
        card_body(
          tags$h4("GPT 3.5 Suggestions"),
          lorem::ipsum(paragraphs = 3, sentences = 5)
        )
      )
    )
  ),
  ### Panel - Items
  nav_item(uiPanelGitHub),
  nav_item(input_dark_mode(id = "dark_mode", mode = "light")),
  nav_item(div(class = "pull-right", shinyauthr::logoutUI(id = "logout")))
)