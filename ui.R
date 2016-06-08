ui <- fluidPage (
  
    titlePanel('Escolha uma coordenada geografica'),
    sidebarLayout(
      sidebarPanel(
        numericInput("latitude", label = "Latitude", value=0),
        numericInput("longitude", label = "Longitude", value=0),
        textInput("coordenadaID", label = "ID da Coordenada"),
        downloadButton('downloadData', 'Download')
      ),
      mainPanel(
       textOutput("latitudeSelecionada"),
       textOutput("longitudeSelecionada")
      )
    )
  )
  
  