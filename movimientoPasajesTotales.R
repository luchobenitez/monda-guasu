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

# Create a plot of total montoevento by fecha and idrutaestacion
monto_fecha_ruta_plot <- transporte_pasajes %>%
  mutate(fecha = as.Date(fechahoraevento)) %>%
  group_by(fecha, idrutaestacion) %>%
  summarize(total_monto = sum(montoevento)) %>%
  ggplot(aes(x = fecha, y = total_monto, color = idrutaestacion)) +
  geom_line() +
  labs(title = "Total de montoevento por fecha por idrutaestacion")

# Save the plot as a PNG file
ggsave("grafico_monto_fecha_ruta.png", monto_fecha_ruta_plot)

# Save all the data to CSV files
write.csv(monto_fecha, file = "monto_fecha.csv", row.names = FALSE)
write.csv(monto_semana, file = "monto_semana.csv", row.names = FALSE)
write.csv(monto_mes, file = "monto_mes.csv", row.names = FALSE)
write.csv(monto_fecha_ruta, file = "monto_fecha_ruta.csv", row.names = FALSE)

# Combine all the plots into a single PDF file
pdf("graficos.pdf")
ggplot(monto_fecha, aes(x = fecha, y = total_monto)) +
  geom_line() +
  labs(title = "Total de montoevento por fecha")
ggplot(monto
