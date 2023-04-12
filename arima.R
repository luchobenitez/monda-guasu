# Instalar paquetes necesarios
install.packages("forecast")
install.packages("xts")

# Cargar paquetes
library(data.table)
library(forecast)
library(xts)

####################
# Analisis por hora
####################

# Agregar la columna 'hora' a los datos
#datos_unidos[, hora := as.POSIXct(cut(fechahoraevento, "hour"))]

# Agrupar eventos por idrutaestacion, idsam, y hora
conteo_eventos <- datos_unidos[, .N, by = .(idrutaestacion, idsam, hora)]

# Crear objeto xts
eventos_xts <- xts(conteo_eventos$N, order.by = conteo_eventos$hora)

# Descomposición STL
eventos_stl <- stl(eventos_xts, s.window = "periodic")

# Graficar la descomposición
plot(eventos_stl)

# Ajustar un modelo ARIMA automático
eventos_arima <- auto.arima(eventos_xts)

# Predecir los próximos 24 puntos de datos (por ejemplo, 24 horas en el futuro)
prediccion_arima <- forecast(eventos_arima, h = 24)

# Graficar la predicción
plot(prediccion_arima)

####################
# Analisis por dia de la semana
####################

# Agregar columna para el día de la semana
datos_unidos[, dia_semana := weekdays(fecha)]

# Agrupar eventos por idrutaestacion, idsam, día de la semana y hora
conteo_eventos_dia_semana <- datos_unidos[, .N, by = .(idrutaestacion, idsam, dia_semana, hora)]


# Crear una lista para almacenar los resultados del análisis por día de la semana
resultados_dia_semana <- list()

dias_semana <- unique(conteo_eventos_dia_semana$dia_semana)

for (dia in dias_semana) {
  # Filtrar datos por día de la semana
  datos_dia <- conteo_eventos_dia_semana[dia_semana == dia]
  
  # Crear objeto xts
  eventos_dia_xts <- xts(datos_dia$N, order.by = datos_dia$hora)
  
  # Descomposición STL
  eventos_dia_stl <- stl(eventos_dia_xts, s.window = "periodic")
  
  # Ajustar un modelo ARIMA automático
  eventos_dia_arima <- auto.arima(eventos_dia_xts)
  
  # Predecir los próximos 24 puntos de datos
  prediccion_dia_arima <- forecast(eventos_dia_arima, h = 24)
  
  # Almacenar resultados en la lista
  resultados_dia_semana[[dia]] <- list(stl = eventos_dia_stl,
                                       arima = eventos_dia_arima,
                                       prediccion = prediccion_dia_arima)
}

# Ejemplo de cómo acceder a los resultados de un día específico
resultados_lunes <- resultados_dia_semana[["Monday"]]  # Reemplace "Monday" con el nombre del día en su idioma local

# Graficar la descomposición STL para el lunes
plot(resultados_lunes$stl)

# Graficar la predicción ARIMA para el lunes
plot(resultados_lunes$prediccion)


