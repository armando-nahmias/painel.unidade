
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

  conteudo.base.qmd <- readLines('qmd/conteudo.base.qmd.qmd')

  for(indicador in nomes.indicadores) {

    conteudo.variavel.qmd <- readLines('qmd/conteudo.variavel.qmd.qmd')

    conteudo.variavel.qmd <- gsub('{{indicador}}', indicador, conteudo.variavel.qmd, fixed = TRUE)

    conteudo.base.qmd <- c(
      conteudo.base.qmd,
      conteudo.variavel.qmd
    )
  }
  
  
  
  arquivo.destino <- glue::glue('qmd/painel_indicadores_{instancia}.qmd')
  
  writeLines(conteudo.base.qmd, arquivo.destino)
  
  quarto::quarto_render(input = arquivo.destino)

}


