
endereco <- 'dados/IndicadoresPainelUnidade.rds'
indicadores <- readr::read_rds(endereco)

nomes.indicadores <- colnames(indicadores[[2]])[-c(1,2)]

conteudo.base.qmd <- readLines('conteudo.base.qmd.qmd')

# Gerar o conteúdo para cada indicador
for(indicador in nomes.indicadores) {
  
  conteudo.variavel.qmd <- readLines('conteudo.variavel.qmd.qmd')
  
  conteudo.variavel.qmd <- gsub('{{indicador}}', indicador, conteudo.variavel.qmd, fixed = TRUE)
  
  conteudo.base.qmd <- c(
    conteudo.base.qmd,
    conteudo.variavel.qmd
  )
}

writeLines(conteudo.base.qmd, "painel_indicadores_dinamico.qmd")