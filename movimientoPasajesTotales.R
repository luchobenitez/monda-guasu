library(tidyverse)
library(lubridate)

# Read the data from the CSV file
transporte <- read.csv("datos_unidos.csv")

# Filter to only include pasajes
transporte_pasajes <- transporte %>%
  filter(tipoevento == 4, producto == "MO")

rm(transporte)

# Calculate the total montoevento
monto_total <- sum(transporte_pasajes$montoevento)

# Create a plot of total montoevento by fecha
monto_fecha_plot <- transporte_pasajes %>%
  mutate(fecha = as.Date(fechahoraevento)) %>%
  group_by(fecha) %>%
  summarize(total_monto = sum(montoevento)) %>%
  ggplot(aes(x = fecha, y = total_monto)) +
  geom_line() +
  labs(title = "Total de montoevento por fecha")

# Save the plot as a PNG file
ggsave("grafico_monto_fecha.png", monto_fecha_plot)

# Create a plot of total montoevento by semana
monto_semana_plot <- transporte_pasajes %>%
  mutate(semana = week(fechahoraevento)) %>%
  group_by(semana) %>%
  summarize(total_monto = sum(montoevento)) %>%
  ggplot(aes(x = semana, y = total_monto)) +
  geom_line() +
  labs(title = "Total de montoevento por semana")

# Save the plot as a PNG file
ggsave("grafico_monto_semana.png", monto_semana_plot)

# Create a plot of total montoevento by mes
monto_mes_plot <- transporte_pasajes %>%
  mutate(mes = month(fechahoraevento)) %>%
  group_by(mes) %>%
  summarize(total_monto = sum(montoevento)) %>%
  ggplot(aes(x = mes, y = total_monto)) +
  geom_bar(stat = "identity") +
  labs(title = "Total de montoevento por mes")

# Save the plot as a PNG file
ggsave("grafico_monto_mes.png", monto_mes_plot)

# Obtener valores únicos de idrutaestacion
rutas <- unique(transporte_pasajes$idrutaestacion)

# Crear lista vacía para guardar resultados por ruta
lista_resultados <- vector("list", length = length(rutas))

# Iterar sobre cada idrutaestacion y calcular el monto total por fecha
for (i in 1:length(rutas)) {
  ruta_actual <- rutas[i]
  monto_ruta_actual <- transporte_pasajes %>%
    filter(idrutaestacion == ruta_actual) %>%
    mutate(fecha = as.Date(fechahoraevento)) %>%
    group_by(fecha) %>%
    summarize(monto_total = sum(montoevento))
  
  # Agregar resultados a la lista
  lista_resultados[[i]] <- monto_ruta_actual
}

# Guardar resultados en archivos CSV
for (i in 1:length(rutas)) {
  ruta_actual <- rutas[i]
  nombre_archivo <- paste0("monto_", ruta_actual, ".csv")
  write.csv(lista_resultados[[i]], file = nombre_archivo, row.names = FALSE)
}

# Generar gráficos por ruta
for (i in 1:length(rutas)) {
  ruta_actual <- rutas[i]
  monto_ruta_actual <- lista_resultados[[i]]
  
  ggplot(monto_ruta_actual, aes(x = fecha, y = monto_total)) +
    geom_line() +
    labs(title = paste("Total de montoevento por fecha para la ruta", ruta_actual)) +
    ggsave(paste0("grafico_monto_", ruta_actual, ".png"))
}
