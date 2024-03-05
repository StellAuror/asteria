api_key <- "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" 

# data.frame - anlyze
## gpt.ask.stats

library(httr)
library(stringr)

##  GPT ASK question
gpt.ask <- function(prompt) {
  prompt <- paste0(
    "Wybieraj tylko najistotniejsze informacje. Stwórz story z najważniejszymi i kluczowymi informacjami na podstawie tekstu: ",
    prompt
  )
  response <- POST(
    url = "https://api.openai.com/v1/chat/completions", 
    add_headers(Authorization = paste("Bearer", api_key)),
    content_type_json(),
    encode = "json",
    body = list(
      model = "gpt-3.5-turbo",
      messages = list(list(
        role = "user", 
        content = prompt
      ))
    )
  )
  str_trim(content(response)$choices[[1]]$message$content)
}

## Calls the ChatGPT API with the given prompt and returns the answer
gpt.ask.stats <- function(stats, context, qstn) {
  promp <- NULL
  prompt <- paste(qstn, context, "A teraz dane do analizy: ", stats)
  response <- POST(
    url = "https://api.openai.com/v1/chat/completions", 
    add_headers(Authorization = paste("Bearer", api_key)),
    content_type_json(),
    encode = "json",
    body = list(
      model = "gpt-3.5-turbo",
      messages = list(list(
        role = "user", 
        content = prompt
      ))
    )
  )
  str_trim(content(response)$choices[[1]]$message$content)
}

gpt.ask.stats(
  stats = "Aktualne obciążenie 100kg (60% poprzedniego obciążenia), uwzględniając powtórzenia i serie zwiększa to postep w treningu o 140%",
  context = "Chcę ćwiczyć trening siłowy",
  qstn = "Czy mój aktualny program jest odpowiedni?"
)
