library(tidyverse)
library(lubridate)
library(ggplot2)
library(scales, warn.conflicts = FALSE)

# Read the data from the CSV file
transporte <- read.csv("datos_unidos.csv")
rutas <- read.csv("rutas.csv")

trans <- select(transporte, -consecutivoevento, -dia_hora, -dia_semana, 
        -fecha, -hora, -latitude, -longitude)
rut <- select(rutas, -estado, -troncal, -ramal)
# Fusionar los datos utilizando la columna "idsam" como clave de unión
datos_fusionados <- inner_join(trans, rut, by = "idrutaestacion")
rm(transporte)
rm(trans)
rm(rutas)
rm(rut)



# Filtro de los datos TOTALES
transporte_filtrado <- datos_fusionados %>%
  filter(tipoevento == 4, producto == "MO") %>%
  group_by(eot, fecha = as.Date(fechahoraevento)) %>%
  summarize(cantidad_viajes = n()) %>%
  ungroup()

transporte_filtrado <- arrange(transporte_filtrado, fecha)

nombre_csv <- paste0("csv/eot_monto_total.csv")
write.csv(transporte_filtrado, file = nombre_csv, row.names = FALSE)    

# Gráfico las 10 EOT
# Gráfico de líneas por EOT de las 10 con más cantidad de viajes
eotplot <- ggplot(transporte_filtrado, aes(x = fecha, y = cantidad_viajes, color = eot)) +
  geom_line(linewidth = 1) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "Fecha", y = "Cantidad de viajes", title = "Cantidad de viajes por las 10 EOT con más cantidad de viajes") +
  theme(legend.position = "bottom", 
        plot.margin = unit(c(2, 2, 0.5, 0.5), "cm"))
ggsave("eot.png", width = 48, height = 8.33, dpi = 72)

## Solo Diferencial
transporte_filtrado <- datos_fusionados %>%
  filter(tipoevento == 4, producto == "MO", tipotransporte==3) %>%
  group_by(eot, fecha = as.Date(fechahoraevento)) %>%
  summarize(cantidad_viajes = n()) %>%
  ungroup()

transporte_filtrado <- arrange(transporte_filtrado, fecha)

nombre_csv <- paste0("csv/eot_monto_total_diferencial.csv")
write.csv(transporte_filtrado, file = nombre_csv, row.names = FALSE)    

# Gráfico las 10 EOT
# Gráfico de líneas por EOT de las 10 con más cantidad de viajes
eotplot <- ggplot(transporte_filtrado, aes(x = fecha, y = cantidad_viajes, color = eot)) +
  geom_line(linewidth = 1) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "Fecha", y = "Cantidad de viajes", title = "Cantidad de viajes por las 10 EOT con más cantidad de viajes (Diferencial)") +
  theme(legend.position = "bottom", 
        plot.margin = unit(c(2, 2, 0.5, 0.5), "cm"))
ggsave("eot-diferencial.png", width = 48, height = 8.33, dpi = 72)





## Solo Normal
transporte_filtrado <- datos_fusionados %>%
  filter(tipoevento == 4, producto == "MO", tipotransporte==1) %>%
  group_by(eot, fecha = as.Date(fechahoraevento)) %>%
  summarize(cantidad_viajes = n()) %>%
  ungroup()

transporte_filtrado <- arrange(transporte_filtrado, fecha)

nombre_csv <- paste0("csv/eot_monto_total_normal.csv")
write.csv(transporte_filtrado, file = nombre_csv, row.names = FALSE)    

# Gráfico las 10 EOT
# Gráfico de líneas por EOT de las 10 con más cantidad de viajes
eotplot <- ggplot(transporte_filtrado, aes(x = fecha, y = cantidad_viajes, color = eot)) +
  geom_line(linewidth = 1) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "Fecha", y = "Cantidad de viajes", title = "Cantidad de viajes por las 10 EOT con más cantidad de viajes (Normal)") +
  theme(legend.position = "bottom", 
        plot.margin = unit(c(2, 2, 0.5, 0.5), "cm"))
ggsave("eot-normal.png", width = 48, height = 8.33, dpi = 72)



## Solo Municipal
transporte_filtrado <- datos_fusionados %>%
  filter(tipoevento == 4, producto == "MO", tipotransporte==0) %>%
  group_by(eot, fecha = as.Date(fechahoraevento)) %>%
  summarize(cantidad_viajes = n()) %>%
  ungroup()

transporte_filtrado <- arrange(transporte_filtrado, fecha)

nombre_csv <- paste0("csv/eot_monto_total_municipal.csv")
write.csv(transporte_filtrado, file = nombre_csv, row.names = FALSE)    

# Gráfico las 10 EOT
# Gráfico de líneas por EOT de las 10 con más cantidad de viajes
eotplot <- ggplot(slice_head(arrange(transporte_filtrado, desc(cantidad_viajes)), n = 10), aes(x = fecha, y = cantidad_viajes, color = eot)) +
  geom_line(linewidth = 1) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = "Fecha", y = "Cantidad de viajes", title = "Cantidad de viajes por las 10 EOT con más cantidad de viajes (Municipal)") +
  theme(legend.position = "bottom", 
        plot.margin = unit(c(2, 2, 0.5, 0.5), "cm"))
ggsave("eot-municipal.png", width = 48, height = 8.33, dpi = 72)