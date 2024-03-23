

dados <-
  googlesheets4::read_sheet(
    'https://docs.google.com/spreadsheets/d/1Nw9Xj8TcuwFxeTml8oE_fPH0-SXWjRQzOCJsP_t1sms/edit#gid=0'
  )

parametros <- split(dados, seq(nrow(dados)))

renderiza <- function(parametros) {
  arquivo.saida <- paste0('relatorio_', parametros$Id, '.html')
  quarto::quarto_render(
    execute_params = parametros,
    input = 'painel.unidade.qmd',
    output_file = arquivo.saida
  )
}



lapply(parametros, renderiza)
