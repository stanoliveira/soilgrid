## Arquivo com a lógica no servidor

server <- function(input,output) {
  
  ################## Lendo o conjunto de dados para uso posterior
  Data <- reactive({
    
    ## Arquivo a ser lido
    inFile <- input$file1
    
    ## Se nenhum arquivo estiver carregado não faz nada
    if (is.null(inFile))
      return(NULL)
    
    ## Se o arquivo tiver sido carregado, aqui ele é lido
    df.raw <- read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
    
    ## Pega as latitudes e longitudes
    lati = min(df.raw$lat) - 1
    latf = max(df.raw$lat) + 1
    loni = min(df.raw$lon) - 1
    lonf = max(df.raw$lon) - 1
    coordinates(df.raw) <- ~lon+lat
    
    ## Filtrando o dbf
    dbf_filtrado = dbf[dbf$X > loni & dbf$X < lonf & dbf$Y > lati & dbf$Y < latf,]
    coordinates(dbf_filtrado) <- ~X+Y
    
    ## Calcula as distâncias mínimas para cada ponto
    nn = apply(gDistance(dbf_filtrado, df.raw, byid=TRUE), 1, which.min)
    
    ## Encontra os perfis e coloca as coordenadas
    perfis = as.character(dbf_filtrado@data$SoilProfil[nn])
    coords = coordinates(dbf_filtrado)[nn,]
    
    ## Finaliza com o resultado
    resultado = data.frame(df.raw, perfis, coords)
    rownames(resultado) <- NULL
    
    ## Retorna arquivo lido
    return(resultado)
  })
  
  ## Mostra os dados que subiram em uma janela
  output$raw <- renderTable({

    ## Por segurança caso o arquivo ainda n tenha sido lido
    if (is.null(input$file1)) { return() }

    Data()
  })
  
  ## Mostra os dados filtrados pelo perfil
  output$filtrado <- renderTable({
    
    ## Por segurança caso o arquivo ainda n tenha sido lido
    if (is.null(input$file1)) { return() }
    
    ## Criando um vetor só com os perfis sem o asterisco
    perfis <- datasource$V2
    perfis <- gsub(pattern = '\\*', replacement = '', x = perfis)
    
    ## Filtrando a tabela
    tabela <- datasource[perfis %in% Data()$perfis,-1]
  })
  
  # downloadHandler() takes two arguments, both functions.
  # The content function is passed a filename as an argument, and
  #   it should write out data to that filename.
  output$downloadData <- downloadHandler(
    
    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste("arquivo_gerado", "txt", sep = ".")
    },
    
    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      
      ## Criando um vetor só com os perfis sem o asterisco
      perfis <- datasource$V2
      perfis <- gsub(pattern = '\\*', replacement = '', x = perfis)
      
      ## Filtrando a tabela
      tabela <- datasource[perfis %in% Data()$perfis,]
    
      ## Criando uma conexão para um arquivo
      con <- file(file, 'w')
      
      ## Salvando em um arquivo txt
      for (i in 1:nrow(tabela)) {
        
        ## Escreve primeiro bloco no arquivo
        writeLines(paste(tabela[i,-1]), sep = "\r\n", con = con, useBytes = T)
        
        ## Escreve uma linha em branco
        writeLines('\r', con=con, useBytes = T)
      }
      close(con)
      
    }
  )
}
