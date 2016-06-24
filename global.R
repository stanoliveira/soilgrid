#datasource <- read.fwf(file="BR.SOL", widths = list(c(1,10,189), c(200), c(200), c(200), c(200),c(200),c(200),c(200),c(200),c(200),c(200),c(200),c(0)), n=102731, as.is=TRUE)
#save(datasource, 'datasource.rda')

## Carregando todos os pacotes necessários
library(maptools)
library(foreign)
library(rgeos)

## Carregando o arquivo fonte que será filtrado
load("data/datasource.rda")

## Carregando o arquivo com as fontes dos perfis
dbf = read.dbf('data/soilgrid_br.dbf')
