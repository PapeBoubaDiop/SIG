rm(list=ls())
{
  library(sf)
  library(ggplot2)
  library(dplyr)
  library(readxl)
}

setwd("C:/AS3/SIG/sig_R/data")
taux_de_pauvrete <- read_excel('pauvrete_region.xlsx')

{
  regions <- st_read("SEN_adm/SEN_Adm1.shp")
  st_crs(regions)
  regions <- st_transform(regions, 32628)
}


map_data <- regions %>% inner_join(taux_de_pauvrete, by=c('NAME_1'='Région'))

ggplot(map_data) +
  geom_sf(aes(fill = pauvrete), color = "black", size = 0.2) +  
  scale_fill_gradient(low = "#FFCCCC", high = "#990000") +  
  theme_minimal() +
  labs(title = "Carte des régions",
       fill = "Taux de pauvreté")

