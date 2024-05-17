
endereco <-
  'https://docs.google.com/spreadsheets/d/1Nw9Xj8TcuwFxeTml8oE_fPH0-SXWjRQzOCJsP_t1sms/edit#gid=0'

instancias <- c('1Instancia', '2Instancia')
dados.painel <- list()
unidades <- list()

for (instancia in instancias) {
  dados <- googlesheets4::read_sheet(endereco, sheet = instancia, col_names = FALSE)
  colunas <- as.character(t(dados[1]))
  dados.painel[[instancia]] <- dados |> 
    t() |>
    tibble::as_tibble() |>
    setNames(colunas) |> 
    dplyr::slice(-1)
  
  unidades[[instancia]] <- dados.painel[[instancia]] |> 
    dplyr::filter(!is.na(Unidade)) |> 
    dplyr::select(Id) |> 
    dplyr::pull() |> 
    dplyr::first()
}

readr::write_rds(dados.painel, 'dados/dados.painel.rds')


for (instancia in instancias) {
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


