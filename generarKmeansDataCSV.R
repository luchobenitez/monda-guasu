if (!require(dplyr)) {
  install.packages("dplyr")
}

library(dplyr)
library(readr)

datos_unidos <- read_csv("datos_unidos.csv")

result <- datos_unidos %>%
  mutate(
    montoevento = as.numeric(montoevento),
    consecutivoevento = as.numeric(consecutivoevento),
    identidad = as.numeric(identidad),
    tipoevento = as.numeric(tipoevento),
    tipotransporte = as.numeric(tipotransporte)
  ) %>%
  group_by(serialtarjeta) %>%
  summarise(
    count = n(),
    avg_montoevento = mean(montoevento, na.rm = TRUE),
    stddev_montoevento = sd(montoevento, na.rm = TRUE),
    median_montoevento = median(montoevento, na.rm = TRUE),
    avg_consecutivoevento = mean(consecutivoevento, na.rm = TRUE),
    stddev_consecutivoevento = sd(consecutivoevento, na.rm = TRUE),
    median_consecutivoevento = median(consecutivoevento, na.rm = TRUE),
    avg_identidad = mean(identidad, na.rm = TRUE),
    stddev_identidad = sd(identidad, na.rm = TRUE),
    median_identidad = median(identidad, na.rm = TRUE),
    avg_tipoevento = mean(tipoevento, na.rm = TRUE),
    stddev_tipoevento = sd(tipoevento, na.rm = TRUE),
    median_tipoevento = median(tipoevento, na.rm = TRUE),
    avg_latitude = mean(latitude, na.rm = TRUE),
    stddev_latitude = sd(latitude, na.rm = TRUE),
    median_latitude = median(latitude, na.rm = TRUE),
    avg_longitude = mean(longitude, na.rm = TRUE),
    stddev_longitude = sd(longitude, na.rm = TRUE),
    median_longitude = median(longitude, na.rm = TRUE),
    avg_tipotransporte = mean(tipotransporte, na.rm = TRUE),
    stddev_tipotransporte = sd(tipotransporte, na.rm = TRUE),
    median_tipotransporte = median(tipotransporte, na.rm = TRUE)
  )

write.csv(x, file = "kmeans_data.csv")