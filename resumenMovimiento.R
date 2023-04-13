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
        
        # Agregar resultados a la lista
        lista_rutas_esultados[[i]] <- monto_ruta_actual
        nombre_csv <- paste0("csv/monto", ruta_actual, "_", tipotransporte, ".csv")
        write.csv(lista_rutas_esultados[[i]], file = nombre_csv, row.names = FALSE)  
        monto_ruta_actual <- lista_rutas_esultados[[i]]
        
        ggplot(monto_ruta_actual, aes(x = fecha, y = monto_total)) +
            geom_line(color = "red", linewidth = 1.5) +
            labs(title = paste("Total de pasajes por fecha (ruta", ruta_actual)) +
            scale_y_continuous(labels = scales::label_number_si()) +
            theme(legend.position = "none")
            
        nombre_grafico <- paste0("grafico_monto", ruta_actual, "_", tipotransporte, ".png")
        ggsave(nombre_grafico, ".png"))  
 
    }
}