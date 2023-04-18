library(ggplot2)
library(sf)
library(RColorBrewer)
library(ggmap)
library(sp)
library(tidyverse)
library(lubridate)
library(ggplot2)
library(scales, warn.conflicts = FALSE)
library(ggspatial)

datos_unidos <- read.csv("datos_unidos.csv")
rutas <- read.csv("rutas.csv")

transacciones <- select(datos_unidos, -consecutivoevento, -dia_hora, -dia_semana, -fechahoraevento, -hora, -idsam)
eots <- select(rutas, -estado, -troncal, -ramal)

eotsn <- unique(eots$eot)
datos_fusionados <- inner_join(transacciones, eots, by = "idrutaestacion")
datos_fusionados$fecha <- as.Date(datos_fusionados$fecha)

rm(datos_unidos)
rm(rutas)
rm(transacciones)
rm(eots)

for (j in 1:length(eotsn)) {

    eot_actual <- eotsn[j]

    ## Filtro de los datos TOTALES
    transporte_filtrado <- datos_fusionados %>%
        filter(eot==eotsn[j], tipoevento == 4, producto == "MO") %>%
        group_by(fecha ) %>%
        summarize(cantidad_viajes = n()) %>%
        ungroup()
    if (sum(transporte_filtrado$cantidad_viajes) == 0) {
        message("No hay datos para eot: ", eotsn[j])
    } else {
        puntos_transacciones <- datos_fusionados %>%
            filter(eot==eotsn[j], tipoevento == 4, producto == "MO")  %>%
            select(latitude, longitude)
        transporte_filtrado <- arrange(transporte_filtrado, fecha)
        nombre_csv <- paste0("csv/viajes_total/eot_viajes_total_",eotsn[j], ".csv")
        write.csv(transporte_filtrado, file = nombre_csv, row.names = FALSE)    
        titulo <- paste("Total de viajes (eot:", eot_actual, ")")
        eotplot <- ggplot(transporte_filtrado, aes(x = fecha, y = cantidad_viajes)) +
            geom_line(linewidth = 1) +
            scale_y_continuous(expand = c(0, 0)) +
            labs(x = "Fecha", y = "Cantidad de viajes", title = titulo) +
            theme(legend.position = "bottom", plot.margin = unit(c(2, 2, 0.5, 0.5), "cm"))
        nombre_png <- paste0("png/viajes_total/eot_viajes_total_",eotsn[j], ".png")
        ggsave(nombre_png, width = 48, height = 8.33, dpi = 72)
        mapa_puntos <- ggplot(puntos_transacciones, aes(x = longitude, y = latitude)) +
            geom_point(alpha = 0.5) +
            theme_minimal()
        nombre_puntos <- paste0("Mapas/rutas/viajes_total/eot_",eotsn[j], ".png")
        ggsave(nombre_puntos, mapa_puntos, width = 10, height = 6, dpi = 300)
        mapa_calor <- ggplot(puntos_transacciones, aes(x = longitude, y = latitude)) +
            geom_point(alpha = 0.1) +
            geom_density2d(colour = "black") +
            theme_minimal()
        nombre_calor <- paste0("Mapas/calor/viajes_total/eot_", eotsn[j], ".png")
        ggsave(nombre_calor, mapa_calor, width = 10, height = 6, dpi = 300)

    }
}
