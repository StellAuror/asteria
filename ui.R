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
  href = "https://github.com/StellAuror/asteria",
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
    open = F, bg = "#171717",
    tagList(
      useWaiter(),
      uiOutput("sidebarUI1"),
      uiOutput("sidebarUI2")
    )
  ),
  nav_spacer(),
  ### Panel - Entering Data
  nav_panel(
    "New Training",
    # add login panel UI function
    shinyauthr::loginUI(id = "login"),
    # First Level
    layout_columns(
      col_widths  = c(2, 7, 3),
      uivEnterData("EnterData1"),
      uivNewRecSnap("EnterData2"),
      layout_column_wrap(uivProgressBox("EnterData3"))
    ),
    # Second Level
    layout_columns(
      col_widths = c(9, 3),
      uivAddedRecs("EnterData4"),
      uivAIRecom("EnterData5")
    )
  ),
  nav_panel(
    "Exercise", 
    uiDashExercise("dashExercise")
  ),
  ### Panel - Items
  nav_item(uiPanelGitHub),
  nav_item(input_dark_mode(id = "dark_mode", mode = "light")),
  nav_item(div(class = "pull-right", shinyauthr::logoutUI(id = "logout")))
)
