library(shiny)
library(rmarkdown)

# Definindo a UI
library(shiny)

ui <- fluidPage(
  titlePanel("Cadastro de Indicadores"),
  sidebarLayout(
    sidebarPanel(
      selectInput("indicador", "Escolha o Indicador:",
                  choices = c("Meta1", "Meta2", "Meta3", "TCL", "Parados30", "Parados100", "Audiencias", "TMT", "IAD", "Cadastrar Novo Indicador")),
      uiOutput("inputUI")  # UI dinâmica que será atualizada com base na escolha do usuário
    ),
    mainPanel(
      textOutput("outputText")
    )
  )
)


# Definindo o servidor
server <- function(input, output) {
  # UI dinâmica baseada na escolha do indicador
  output$inputUI <- renderUI({
    if (input$indicador == "Cadastrar Novo Indicador") {
      tagList(
        textInput("novoIndicador", "Nome do Novo Indicador"),
        textAreaInput("descricao", "Descrição"),
        selectInput("polaridade", "Polaridade", choices = c("maior melhor", "menor melhor")),
        textInput("medida", "Medida"),
        actionButton("btnSalvar", "Salvar Novo Indicador")
      )
    } else {
      tagList(
        numericInput("valor", "Valor", value = NA),
        actionButton("btnSalvar", "Salvar")
      )
    }
  })
  
  # Processamento após salvar
  observeEvent(input$btnSalvar, {
    if (input$indicador == "Cadastrar Novo Indicador") {
      # Aqui você pode adicionar a lógica para salvar o novo indicador
      output$outputText <- renderText(paste("Novo Indicador Cadastrado:", input$novoIndicador))
    } else {
      # Aqui você pode adicionar a lógica para salvar o valor do indicador existente
      output$outputText <- renderText(paste("Valor salvo para", input$indicador, ":", input$valor))
    }
  })
}


shinyApp(ui = ui, server = server)