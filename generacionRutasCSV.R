library(data.table)

# Leer los datos desde el archivo RDS y almacenar en 'datos'
datos <- readRDS("datos_unidos.rds")

# Seleccionar sólo las columnas de interés: latitude, longitude e idrutaestacion
datos_seleccionados <- datos[, .(latitude, longitude, idrutaestacion)]

# Guardar los resultados en un archivo CSV
fwrite(datos_seleccionados, "rutas.csv")