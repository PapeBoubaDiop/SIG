rm(list=ls())
{
  library(sf)
  library(ggplot2)
  library(dplyr)
}
setwd("C:/AS3/SIG/sig_R/data")

# Importation des routes
{
  routes <- st_read("SEN_rds/SEN_roads.shp")
  st_crs(routes)
  routes <- st_transform(routes, 32628)
}

# Importation des villages
villages <- st_read("Villages/village.shp")

# Importation des régions
{
  regions <- st_read("SEN_adm/SEN_Adm1.shp")
  st_crs(regions)
  regions <- st_transform(regions, 32628)
}
# Les villages qui sont à Saint-Louis
{
  SL <- regions %>% filter(NAME_1 == "Saint-Louis")
  villages_SL <- villages[st_intersects(villages, SL, sparse=FALSE),]
}

# Les routes qui sont à Saint-Louis
routes_SL <- routes[st_intersects(routes, SL, sparse = F),]

# Créer un buffer de 3Km sur les routes de Saint-Louis
buffer_SL <- st_buffer(routes_SL, dist = 3000)

# Sélectionner les villages de Saint-Louis qui sont à moins de 3 km des routes
is_within_3km <- st_is_within_distance(villages_SL, routes_SL, dist = 3000)

# Convertir la matrice en un vecteur logique (TRUE si le village est proche d'une route)
villages_proches_routes_SL <- villages_SL[apply(is_within_3km, 1, any), ]

plot(st_geometry(SL), col = "gray", main = "Villages proches des routes à Saint-Louis")
plot(st_geometry(villages_proches_routes_SL), add = TRUE, col = "blue", pch = 20)


# Echantillonage
village_ech <- villages_proches_routes_SL %>% sample_n(15)

plot(st_geometry(SL), col = "gray", main = "Villages proches des routes à Saint-Louis")
plot(st_geometry(village_ech), add = TRUE, col = "blue", pch = 20)

