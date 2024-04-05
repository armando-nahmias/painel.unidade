enviar.mensagem <-
  function(unidade, arquivo.saida) {
    assunto <- paste('Painel da Unidade:', unidade)
    corpo <-
      epoxy::epoxy(
        'Em anexo, segue o arquivo {arquivo.saida}, referente ao Painda da Unidade da {unidade}.'
      )
    anexo <- arquivo.saida
    DESTINATARIOS <- 'armando.nahmias@tjrr.jus.br'
    # DESTINATARIOS <- c('armando.nahmias@tjrr.jus.br', 'rafael.costa@tjrr.jus.br')
    
    
    configuracao <-
      jsonlite::fromJSON('configuracao/configuracao.json')
    
    mensagem <- emayili::envelope(
      to = DESTINATARIOS,
      from = configuracao$usuario.smtp,
      subject = assunto,
      text = corpo
    )
    
    mensagem <-
      mensagem |> emayili::attachment(file.path('relatorios.1.instancia', arquivo.saida))
    
    configuracao.servidor <- emayili::server(
      host = "smtp.gmail.com",
      port = 465,
      username = configuracao$usuario.smtp,
      password = configuracao$senha.smtp
    )
    
    configuracao.servidor(mensagem)
    
    if (exists('mensagem')) {
      logger::log_info('Mensagem enviada com sucesso!')
    } else {
      logger::log_error('Falha ao enviar a mensagem.')
      
    }
  }
