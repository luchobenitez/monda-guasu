# Este código carga un archivo CSV de datos de transporte público, 
# filtra los datos para obtener solo los viajes realizados (tipoevento = 4) 
# que fueron pagados (producto = "MO") y que corresponden a viajes internos 
# o municipales (tipotransporte = 0). Luego, itera sobre cada serialtarjeta 
# y calcula el monto total de los pasajes por fecha para cada ruta y los cuenta. Cada 
# resultado se guarda en una lista, se crea un archivo CSV con el monto total 
# de los pasajes para cada ruta y se genera un gráfico que muestra la evolución 
# del monto de pasajes por fecha para cada ruta.
library(tidyverse)
library(lubridate)
library(ggplot2)
library(scales, warn.conflicts = FALSE)



# Read the data from the CSV file
transporte <- read.csv("datos_unidos.csv")
rutas <- read.csv("rutas.csv")

# Fusionar los datos utilizando la columna "idsam" como clave de unión
datos_fusionados <- inner_join(transporte, rutas, by = "idsam")
rm(rutas)


# Filtro de los datos
transporte_filtrado <- datos_fusionados %>%
  filter(tipoevento == 4, producto == "MO") %>%
  group_by(eot, fecha = as.Date(fechahoraevento)) %>%
  summarize(cantidad_viajes = n()) %>%
  ungroup()

# Gráfico de líneas por EOT
eotplot <- ggplot(transporte_filtrado, aes(x = fecha, y = cantidad_viajes, color = eot)) +
  geom_line(size = 1) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "Fecha", y = "Cantidad de viajes", title = "Cantidad de viajes por EOT") +
  theme_minimal(legend.position = "none")


eotplot <- ggplot(transporte_filtrado, aes(x = fecha, y = cantidad_viajes, color = eot)) +
  geom_line(size = 1) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "Fecha", y = "Cantidad de viajes", title = "Cantidad de viajes por EOT") +
  theme(legend.position = "bottom", 
        plot.margin = unit(c(2, 2, 0.5, 0.5), "cm"))


ggsave("eot.png", width = 6.25, height = 8.33, dpi = 72)


