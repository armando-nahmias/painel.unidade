
#testes
Teste <- TRUE

endereco <-
  'https://docs.google.com/spreadsheets/d/1Nw9Xj8TcuwFxeTml8oE_fPH0-SXWjRQzOCJsP_t1sms/edit#gid=0'

indicadores <-
  googlesheets4::read_sheet(endereco,
                            sheet = '1InsT')


readr::write_rds(indicadores, 'dados/IndicadoresPainelUnidade.rds')

unidades <- dados |> 
  dplyr::select(Id) |> 
  dplyr::pull() |>
  setNames(rep('Id', nrow(dados)))

for (unidade in unidades) {
  unidade.nomeada <- list(Id = unidade)

  arquivo.saida <- paste0('relatorio_', unidade, '.html')  
  
  quarto::quarto_render(execute_params = unidade.nomeada, input = 'painel.1.instancia.qmd', output_file = arquivo.saida)
  
  fs::file_move(arquivo.saida, file.path('docs', arquivo.saida))
  
  if (Teste) {
    next
  } else {
    source('source/enviar.mensagem.R')
    
    enviar.mensagem(dados$Unidade[dados$Id == unidade], arquivo.saida)
    
  }
  
}

quarto::quarto_render('docs/index.qmd')

