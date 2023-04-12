library(sf)
library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)

# Primero generar un csv solo con los datos de latitude,longitude y idrutaestacion
# Con estos datos se grafican cada una de las rutas posibles
# Leer los datos desde el archivo CSV y almacenar en 'datos_lineas'
datos_lineas <- read_csv("rutas.csv")

# Eliminar filas con valores NA
datos_lineas <- datos_lineas %>%
  drop_na() %>%
  filter(latitude != 0, longitude != 0, # Remover ceros
         latitude < -23, # Remover latitudes fuera de Asunción
         longitude < -56) # Remover longitudes fuera de Asunción

# Mostrar 10 filas aleatorias
#print(sample_n(datos_lineas, 10))

# Leer el archivo GeoJSON y almacenar en 'mapa_paraguay'
# Bajado de la STP en formato json. es un mapa distrital viejo
# la STP aún no provee un mapa actualizado con todos los distritos nuevos creados despues del 2012
# https://analisis.stp.gov.py/user/ine/tables/paraguay_2019_distritos/public
mapa_paraguay <- st_read('Mapas/paraguay_2019_distritos.geojson')

lineas <- unique(datos_lineas$idrutaestacion)

for (linea in lineas) {
  datos_linea <- datos_lineas[datos_lineas$idrutaestacion == linea,]
  latlon_por_linea <- st_as_sf(datos_linea, coords = c("longitude", "latitude"), crs = 4326)
  
  # Calcular los límites para centrar el gráfico
  bbox <- st_bbox(latlon_por_linea)
  margin <- 0.01

  # Generar gráfico
  gg <- ggplot() +
    geom_sf(data = mapa_paraguay, fill = "lightgrey", color = "darkgrey") +
    geom_sf(data = latlon_por_linea, size = 0.4, color = "red") +
    ggtitle(paste0("Datos para idrutaestacion ", linea)) +
    coord_sf(xlim = c(bbox["xmin"] - margin, bbox["xmax"] + margin),
             ylim = c(bbox["ymin"] - margin, bbox["ymax"] + margin)) +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5))
  
  # Guardar gráfico como archivo PNG
  ggsave(paste0("Mapas/Rutas/", linea, ".png"), gg, dpi = 900, width = 10, height = 10, units = "cm")
}
