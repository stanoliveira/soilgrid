## Arquivo da interface

ui <- fluidPage (
  
  ## Título da página  
  titlePanel('Escolha uma coordenada geografica'),
    
    ## Definição do layout com barra lateral
    sidebarLayout(
      
      ## Definições da ui para a barra lateral
      sidebarPanel(
        
        ## Input para arquivo
        fileInput('file1', 'Escolha um arquivo CSV',
                  accept=c('text/csv', 
                           'text/comma-separated-values,text/plain', 
                           '.csv')),
        tags$hr(),
        
        ## Checkbox para o arquivo com cabeçalho ou não
        checkboxInput('header', 'Cabeçalho', TRUE),
        
        ## Indicação para separador
        radioButtons('sep', 'Separador',
                     c(Comma=',',
                       Semicolon=';',
                       Tab='\t'),
                     ','),
        
        ## Indicação de quota
        radioButtons('quote', 'Quote',
                     c(None='',
                       'Double Quote'='"',
                       'Single Quote'="'"),
                     '"')
      ),
      
      ## Painel principal
      mainPanel(
        
        ## Define conjunto de abas
        tabsetPanel(
          
          ## Primeira aba
          tabPanel("Dados",
                   h4(textOutput("caption1")),
                   tableOutput('raw'),
                   value = 1),
          
          ## Segunda aba
          tabPanel("Download",
                   tableOutput('filtrado'),
                   downloadButton('downloadData', 'Download')
                   )
        )
      )
    )
  )
  
  