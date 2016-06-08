#datasource <- read.fwf(file="data/testRead.tst", widths = list(c(6), c(12), c(9), c(0)), n=2)
load("data/datasource.rda")

server <- function(input,output) {
  
  output$latitudeSelecionada <- renderText({
    paste("Latitude selecionada = ", input$latitude)
    })

  output$longitudeSelecionada <- renderText({
    paste("Longitude selecionada = ", input$longitude)
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
      
      # Write to a file specified by the 'file' argument
      registerIndex = which(datasource$V2 == input$coordenadaID)
      writeLines(c(paste0(datasource[registerIndex, 1], datasource[registerIndex, 2], datasource[registerIndex, 3]), paste(datasource[registerIndex, 4]), paste(datasource[registerIndex, 5]), paste(datasource[registerIndex, 6]), paste(datasource[registerIndex, 7]), paste(datasource[registerIndex, 8]), paste(datasource[registerIndex, 9]), paste(datasource[registerIndex, 10]), paste(datasource[registerIndex, 11]), paste(datasource[registerIndex, 12]), paste(datasource[registerIndex, 13]), paste(datasource[registerIndex, 14])), file, sep = "\r\n")
    }
  )
}
