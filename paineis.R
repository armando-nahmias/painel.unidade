
endereco <- 'dados/IndicadoresPainelUnidade.rds'
indicadores <- readr::read_rds(endereco)

nomes.indicadores <- colnames(indicadores)[-c(1,2)]

conteudo_qmd <- c(
  "---",
  "format: ",
  "  revealjs:",
  "    css: 'configuracao/painel.unidade.css'",
  "    slide-number: c/t",
  "    embed-resources: true",
  "    auto-slide: 3000",
  "    transition: slide",
  "    transition-speed: fast",
  "    background-transition: fade",
  "    loop: true",
  "    menu: false",
  "params:",
  "  Id: '3VCv'",
  "---",
  "",
  "```{r setup, include=FALSE}",
  "endereco <- 'dados/IndicadoresPainelUnidade.rds'",
  "selecao <- c(params$Id, 'Limite', 'Nome', 'Descrição')",
  "indicadores <- readr::read_rds(endereco)",
  "dados <- dplyr::filter(indicadores, Id %in% selecao)",
  "unidade <- dados$Unidade[1]",
  "criar.tabela <- function(tabela) {",
  "  valor <- tabela$Valor |> ",
  "    stringr::str_remove('%') |>",
  "    stringr::str_replace(',', '.') |> ",
  "    as.numeric()",
  "",
  "  limite <- as.numeric(tabela$Limite)",
  "",
  "  cor.fonte <- ifelse(valor > limite, 'blue', 'red')",
  "",
  "  tabela <- tabela |> dplyr::select(-Limite) |> tidyr::pivot_longer(cols = everything(), values_to = 'Valores') |> dplyr::select(-name)",
  "",
  "  kableExtra::kable(",
  "    tabela,",
  "    align = 'c',",
  "    escape = FALSE,",
  "    row.names = FALSE,",
  "    col.names = NULL",
  "  ) |>",
  "    kableExtra::kable_styling(font_size = '1.5em',",
  "                              full_width = TRUE,",
  "                              position = 'center') |>",
  "    kableExtra::row_spec(0:nrow(tabela), extra_css = 'border-bottom: none;') |>",
  "    kableExtra::row_spec(1, bold = T, font_size = '1.5em') |>",
  "    kableExtra::row_spec(2, bold = T, font_size = '2em', color = cor.fonte) |>",
  "    kableExtra::row_spec(3, bold = T, font_size = '.5em')",
  "}",
  "```",
  "",
  "# Painel da Unidade <br> `r unidade` {background-image=\"imagens/0.painel.unidade.png\" background-opacity=\".2\"}",
  ""
)

# Gerar o conteúdo para cada indicador
for(indicador in nomes.indicadores) {
  
  
  conteudo_qmd <- c(conteudo_qmd,
                    "## {background-image=\"imagens/1.TJRR.png\" background-opacity=\".2\"}",
                    "### `r unidade`",
                    "::: {.columns}",
                    "::: {.column width=\"100%\"}",
                    "```{r}",
                    paste0("indicador <- '", indicador, "'"),
                    # Aqui, criamos a tabela diretamente com a coluna do indicador específico
                    paste0("tabela <- dplyr::tibble(Nome = dplyr::pull(dados[3, ], indicador), Valor = dplyr::pull(dados[1, ], indicador), Descrição = dplyr::pull(dados[4, ], indicador), Limite = dplyr::pull(dados[2, ], indicador))"),
                    "criar.tabela(tabela)",
                    "```",
                    ":::",
                    ":::",
                    ""
  )
}

writeLines(conteudo_qmd, "painel_indicadores_dinamico.qmd")