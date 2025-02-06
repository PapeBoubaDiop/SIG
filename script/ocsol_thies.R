library(sf)
library(ggplot2)

rm(list=ls())

regions <- st_read('C://AS2//Sem2//SIG//Données SIG//SEN_adm//SEN_adm1.shp')

regions$var <- runif(nrow(regions), min = 0, max = 100)
ggplot(regions) +
  geom_sf(aes(fill = var)) + 
  scale_fill_viridis_c() +  # Palette adaptée aux cartes
  theme_minimal()


library(terra)
raster_2016 <- rast("C:/AS3/SIG/eg3/ext_2016.tif")
raster_2025 <- rast("C:/AS3/SIG/eg3/img_11janv2025.tif")

# plot(raster)

NIR_2016 <- raster_2016[[1]]
NIR_2025 <- raster_2025[[5]]

RED_2016 <- raster_2016[[3]]
RED_2025 <- raster_2025[[4]]

NDVI_2016 <- (NIR_2016 - RED_2016)/(NIR_2016 + RED_2016)
NDVI_2025 <- (NIR_2025 - RED_2025)/(NIR_2025 + RED_2025)
# ggplot(raster_2025) +
#   geom_sf(fill = NDVI_2025) +  
#   scale_fill_gradient(low = "#000000", high = "#FFFFFF") +  
#   theme_minimal() +
#   labs(title = "NDVI 2025")


plot(NDVI_2016, col = terrain.colors(9), main = "Carte NDVI 2016")
plot(NDVI_2025, col = terrain.colors(10), main = "Carte NDVI 2025")

NDVI_2025 <- crop(NDVI_2025, NDVI_2016)
NDVI_2016 <- crop(NDVI_2016, NDVI_2025)

NDVI_diff <- NDVI_2016 - NDVI_2025

plot(NDVI_diff, col = terrain.colors(10), main = "Carte NDVI différence")


GREEN_2025 <- raster_2025[[3]]
BRI_2025 <- RED_2025 / GREEN_2025

plot(BRI_2025, col=(gray.colors(100)))





band1 <- rast("C:/AS3/SIG/eg3/img_11janv2025.tif")
band2 <- resample(band1, NDVI_2025)
band3 <- resample(band2, BRI_2025)
raster_multi <- c(NDVI_2025, band2, band3)

writeRaster(raster_multi, 'C:/AS3/SIG/eg3/Image_2025.tif', overwrite=TRUE)
