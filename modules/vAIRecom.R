uivAIRecom <- function(id) {
  ns <- NS(id)
    tagList(
      uiOutput(ns("ifLogged"))
    )
}

servervAIRecom <- function(id, isLogged, data, userInpt) {
  moduleServer(
    id,
    function(input, output, session) {
      
      output$ifLogged <- renderUI({
        if (!isLogged()) return()
        ns <- NS(id)
        card(
          height = "500px",
          full_screen = T,
          actionButton(ns("submit"), "Submit"),
          uiOutput(ns("response")) 
        )
      })
      
      observeEvent(input$submit, {
        if (!isLogged()) return()
        waiter_show( 
          html = spin_fading_circles(),
          color = "#171717"
        )
        
        # Generate the table in markdown format
        table <- paste0(kable(data() |> filter(Name == userInpt()$excercise) |> tail(10), format = "markdown"), collapse = "/n")

        # Create the prompt using glue
        query <- glue::glue(
          "Based on the following training data, which shows the history of one exercise over given time, generate personalized recommendations for further training. Consider the evolution of the load, the number of repetitions, and their impact on muscle strength and growth. Your recommendations should include:

          1. Suggestions for changes in load and number of repetitions for upcoming training sessions (if needed).
          2. Advice on any potential modifications in technique or exercise type that could aid in better development of similar muscles group.
          3. Justification for the proposed changes based on trends observed in the training history.
          4. Brief description of the accurate technique.
          
          **Data:**
          {table}
          
          Please ensure your recommendations are personalized and tailored to the user's level of advancement and training goals.
          Use markdown highlighting methods to emphasize important values and words"
        )
        # Generate response using the local LLM model
        response <- ollamar::generate(
          prompt = query,
          model = "llama3.1",
          output = "text"
        )
        
        waiter_hide()
        
        # Convert the Markdown response to HTML
        output$response <- renderUI({
          HTML(markdownToHTML(text = response, fragment.only = T))
        }) 
      })
    }
  )
}