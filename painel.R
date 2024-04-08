

endereco <-
  'https://docs.google.com/spreadsheets/d/1Nw9Xj8TcuwFxeTml8oE_fPH0-SXWjRQzOCJsP_t1sms/edit#gid=0'

dados <-
  googlesheets4::read_sheet(endereco,
                            sheet = '1InsT')

write.csv2(dados, 'dados/IndicadoresPainelUnidade.csv', row.names = F)

unidades <- dados |> 
  dplyr::select(Id) |> 
  dplyr::pull() |>
  setNames(c('Id', 'Id'))

for (unidade in unidades) {
  unidade.nomeada <- list(Id = unidade)

  arquivo.saida <- paste0('relatorio_', unidade, '.html')  
  
  quarto::quarto_render(execute_params = unidade.nomeada, input = 'painel.1.instancia.qmd', output_file = arquivo.saida)
  
  fs::file_move(arquivo.saida, file.path('relatorios.1.instancia', arquivo.saida))
  
  source('source/enviar.mensagem.R')
  
  enviar.mensagem(dados$Unidade[dados$Id == unidade], arquivo.saida)
  
}


