rm(list=ls())
{
  library(sf)
  library(ggplot2)
}
setwd("C:/AS3/SIG/sig_R/data")

regions <- st_read("SEN_adm/SEN_Adm1.shp")
departements <- st_read("SEN_adm/SEN_Adm2.shp")
routes <- st_read("SEN_rds/SEN_roads.shp")

# regions <- unique(regions$NAME_1)

thies <- regions[regions$NAME_1 == "Thiès",]
dakar <- regions[regions$NAME_1 == "Dakar",]
departements_thies <- st_intersection(departements, thies)
routes_thies <- st_intersection(routes, thies)
plot(departements_thies["NAME_2"], main = "Départements de la région de Thiès")

plot(st_geometry(thies), col='lightblue')
plot(st_geometry(routes_thies["NAME_1"]),add=T)








