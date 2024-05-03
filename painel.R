
endereco <-
  'https://docs.google.com/spreadsheets/d/1Nw9Xj8TcuwFxeTml8oE_fPH0-SXWjRQzOCJsP_t1sms/edit#gid=0'

dados.1.instancia <-
  googlesheets4::read_sheet(endereco,
                            sheet = '1InsT')

dados.2.instancia <-
  googlesheets4::read_sheet(endereco,
                            sheet = '2InsT')

dados.painel <- list('1InsT' = dados.1.instancia, '2InsT' = dados.2.instancia)
readr::write_rds(dados.painel, 'dados/dados.painel.rds')


unidades <- list(
  '1InsT' = dados.1.instancia |> 
    dplyr::filter(!is.na(Unidade)) |>
    dplyr::select(Id)|> 
    dplyr::pull(),
  '2InsT' = dados.2.instancia |> 
    dplyr::filter(!is.na(Unidade)) |>
    dplyr::select(Id)|> 
    dplyr::pull()
)

for (instancia in names(unidades)) {
  nomes.indicadores <- colnames(dados.painel[[instancia]])[-c(1,2)]
  unidade.padrao <- unidades[[instancia]][1]
  
  conteudo.base.qmd <- readLines('modelo/conteudo.base.qmd.qmd') |> 
    stringi::stri_replace_all_fixed('{{unidade.padrao}}', unidade.padrao)

  for(indicador in nomes.indicadores) {

    conteudo.variavel.qmd <- readLines('modelo/conteudo.variavel.qmd.qmd') |> 
      stringi::stri_replace_all_fixed('{{indicador}}', indicador)

    conteudo.base.qmd <- c(
      conteudo.base.qmd,
      conteudo.variavel.qmd
    )
  }
  
  readr::write_rds(dados.painel[instancia], 'dados/indicadores.rds')
  
  arquivo.destino <- glue::glue('painel_indicadores_{instancia}.qmd')
  
  writeLines(conteudo.base.qmd, arquivo.destino)
  
  parametros <- list(Id = unidades[[instancia]])
  arquivos.saida <- paste0('relatorio_', unidades[[instancia]], '.html')
  diretorio.destino <- 'pagina/'

    
  for (i in seq_along(unidades[[instancia]])) {
    quarto::quarto_render(
      input = arquivo.destino,
      execute_params = list(Id = unidades[[instancia]][i]),
      output_file = arquivos.saida[i]
    )
    
    file.rename(arquivos.saida[i], paste0(diretorio.destino, arquivos.saida[i]))
  }
  
  file.rename(arquivo.destino, paste0(diretorio.destino, arquivo.destino))

}

quarto::quarto_render(
  input = 'modelo/index.qmd',
  output_file = 'index.html'
)
