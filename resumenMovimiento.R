# Este código carga un archivo CSV de datos de transporte público, 
# filtra los datos para obtener solo los viajes realizados (tipoevento = 4) 
# que fueron pagados (producto = "MO") y que corresponden a viajes internos 
# o municipales (tipotransporte = 0). Luego, itera sobre cada idrutaestacion 
# y calcula el monto total de los pasajes por fecha para cada ruta. Cada 
# resultado se guarda en una lista, se crea un archivo CSV con el monto total 
# de los pasajes para cada ruta y se genera un gráfico que muestra la evolución 
# del monto de pasajes por fecha para cada ruta.
library(tidyverse)
library(lubridate)
library(ggplot2)
library(scales, warn.conflicts = FALSE)



# Read the data from the CSV file
transporte <- read.csv("datos_unidos.csv")

trans <- unique(transporte$tipotransporte)

lista_trans_esultados <- vector("list", length = length(trans))


# Iterar sobre cada idrutaestacion y calcular el monto total por fecha
for (j in 1:length(trans)) {
    trans_actual <- trans[j]

    # Filter to only include pasajes
    # tipoevento == 4 se refiere a un viaje
    # producto == "MO" se refiere que se pago un viaje 
    # tipotransporte == 0 se tomaran solo los viajes interno o municipales
    transporte_pasajes <- transporte %>%
        filter(tipoevento == 4, producto == "MO", tipotransporte == trans_actual)
    # Obtener valores únicos de idrutaestacion
    rutas <- unique(transporte_pasajes$idrutaestacion)
    # Crear lista vacía para guardar resultados por ruta
    lista_rutas_esultados <- vector("list", length = length(rutas))

    for (i in 1:length(rutas)) {
        ruta_actual <- rutas[i]
        monto_ruta_actual <- transporte_pasajes %>%
            filter(idrutaestacion == ruta_actual) %>%
            mutate(fecha = as.Date(fechahoraevento)) %>%
            group_by(fecha) %>%
            summarize(monto_total = sum(montoevento))
        
        nombre_csv <- paste0("csv/monto_", ruta_actual, "_", trans_actual, ".csv")
        write.csv(monto_ruta_actual, file = nombre_csv, row.names = FALSE)  
        
        ggplot(monto_ruta_actual, aes(x = fecha, y = monto_total)) +
            geom_line(color = "red", linewidth = 1.5) +
            labs(title = paste("Total de pasajes por fecha (ruta", ruta_actual, "/", trans_actual, ")"),
                y = "Monto total de pasajes (en millones Gs)") +
            scale_y_continuous(labels = scales::label_number(big.mark = ",", scale = 1e-6)) +
            theme(legend.position = "none")
            
        nombre_grafico <- paste0("Grafico/monto_", ruta_actual, "_", trans_actual, ".png")
        ggsave(nombre_grafico, width = 6.25, height = 8.33, dpi = 72)
 
    }
}