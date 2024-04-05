

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
  
}





renderiza <- function(unidades) {
  arquivo.saida <- paste0('relatorio_', unidades, '.html')
  quarto::quarto_render(execute_params = unidades[1],
                        input = 'painel.1.instancia.qmd',
                        output_file = arquivo.saida)
  fs::file_move(arquivo.saida, file.path('relatorios.1.instancia', arquivo.saida))
}

lapply(unidades, quarto::quarto_render)


# geração dos arquivos na raiz
unidades <- dados |> 
  dplyr::select(Id) |> 
  dplyr::pull()

renderiza <- function(unidades) {
  arquivo.saida <- paste0('relatorio_', unidades, '.html')
  quarto::quarto_render(execute_params = unidades,
                        input = 'painel.unidade.1.qmd',
                        output_file = arquivo.saida)
  fs::file_move(arquivo.saida, file.path('relatorios.1.instancia', arquivo.saida))
}

lapply(unidades, renderiza)








------------

endereco <-
  'https://docs.google.com/spreadsheets/d/1Nw9Xj8TcuwFxeTml8oE_fPH0-SXWjRQzOCJsP_t1sms/edit#gid=0'

dados <-
  googlesheets4::read_sheet(endereco,
                            sheet = '1InsT')

paineis <- file.path('painel.1.instancia', list.files('painel.1.instancia/', 'qmd'))

unidades <- dados |> 
  dplyr::select(Id) |> 
  dplyr::pull()

# geração dos arquivos na pasta painel.1.instancia

for (painel in paineis) {
  for (unidade in unidades) {
    arquivo.saida <- paste0('relatorio_', unidade, '.html')
    quarto::quarto_render(execute_params = unidade)
  }
}
renderiza <- function(unidades) {
  arquivo.saida <- paste0('relatorio_', unidades, '.html')
  quarto::quarto_render(execute_params = unidades,
                        input = 'painel.unidade.1.qmd',
                        output_file = arquivo.saida)
  fs::file_move(arquivo.saida, file.path('relatorios.1.instancia', arquivo.saida))
}

lapply(paineis, quarto::quarto_render)


# geração dos arquivos na raiz
unidades <- dados |> 
  dplyr::select(Id) |> 
  dplyr::pull()

renderiza <- function(unidades) {
  arquivo.saida <- paste0('relatorio_', unidades, '.html')
  quarto::quarto_render(execute_params = unidades,
                        input = 'painel.unidade.1.qmd',
                        output_file = arquivo.saida)
  fs::file_move(arquivo.saida, file.path('relatorios.1.instancia', arquivo.saida))
}

lapply(unidades, renderiza)


kableExtra::kable()





tabela <- dados |> 
  dplyr::select(Meta1Mes, Meta1Anual)