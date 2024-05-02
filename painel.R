
endereco <-
  'https://docs.google.com/spreadsheets/d/1Nw9Xj8TcuwFxeTml8oE_fPH0-SXWjRQzOCJsP_t1sms/edit#gid=0'

indicadores.1.instancia <-
  googlesheets4::read_sheet(endereco,
                            sheet = '1InsT')

indicadores.2.instancia <-
  googlesheets4::read_sheet(endereco,
                            sheet = '2InsT')

indicadores <- list('1InsT' = indicadores.1.instancia, '2InsT' = indicadores.2.instancia)

unidades <- list(
  '1InsT' = indicadores.1.instancia |> 
    dplyr::filter(!is.na(Unidade)) |>
    dplyr::select(Id)|> 
    dplyr::pull(),
  '2InsT' = indicadores.2.instancia |> 
    dplyr::filter(!is.na(Unidade)) |>
    dplyr::select(Id)|> 
    dplyr::pull()
)


for (instancia in names(unidades)) {
  nomes.indicadores <- colnames(indicadores[[instancia]])[-c(1,2)]

  conteudo.base.qmd <- readLines('conteudo.base.qmd.qmd')
  
  unidade.padrao <- unidades[[instancia]][1]
  conteudo.base.qmd <- gsub('{{unidade.padrao}}', unidade.padrao, conteudo.base.qmd, fixed = TRUE)

  for(indicador in nomes.indicadores) {

    conteudo.variavel.qmd <- readLines('conteudo.variavel.qmd.qmd')

    conteudo.variavel.qmd <- gsub('{{indicador}}', indicador, conteudo.variavel.qmd, fixed = TRUE)

    conteudo.base.qmd <- c(
      conteudo.base.qmd,
      conteudo.variavel.qmd
    )
  }
  
  readr::write_rds(indicadores[instancia], 'dados/Indicadores.rds')
  
  arquivo.destino <- glue::glue('painel_indicadores_{instancia}.qmd')
  
  writeLines(conteudo.base.qmd, arquivo.destino)
  
  parametros <- list(Id = unidades[[instancia]])
  arquivos.saida <- paste0(unidades[[instancia]], '.html')
  
  quarto::quarto_render(input = arquivo.destino, execute_params = parametros, output_file = arquivos.saida)

}


