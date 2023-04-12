# Instalar y cargar el paquete 'data.table' si aún no lo ha hecho
if (!require(data.table)) {
  install.packages("data.table")
  library(data.table)
}
if (!require(lubridate)) {
  install.packages("lubridate")
  library(lubridate)
}
if (!require(magrittr)) {
  install.packages("magrittr")
  library(magrittr)
}
if (!require(dplyr)) {
  install.packages("dplyr")
  library(dplyr)
}

##############################
# OJO OJO OJO OJO OJO
# Se necesitan al menos 32G RAM
##############################

# Función para convertir un archivo CSV a RDS
convertir_csv_a_rds <- function(ruta_csv, ruta_rds) {
  datos <- fread(ruta_csv)
  # Cambiar de String a timestamp
  datos[, fechahoraevento := as.POSIXct(fechahoraevento, format = "%Y/%m/%d %H:%M:%S")]
  # Agregar columnas para el día, la hora y la combinación de día y hora
  datos <- datos[, fecha := as.Date(fechahoraevento)]
  datos <- datos[, hora := hour(fechahoraevento)]
  datos <- datos[, dia_hora := interaction(fecha, hora, sep="_")]
  datos <- datos[, dia_semana := lubridate::wday(fecha, label = TRUE)]
  datos <- datos[, serialtarjeta := as.factor(serialtarjeta)]
  datos <- datos[, idsam := as.factor(idsam)]
  saveRDS(datos, file = ruta_rds)
}

# Lista de archivos
archivos <- c(
  "1- Enero_2022.csv",
  "2- Febrero_2022.csv",   
  "3- Marzo_2022.csv",     
  "4- Abril_2022.csv",     
  "5- Mayo_2022.csv",      
  "6- Junio_2022.csv",     
  "7- Julio_2022.csv",     
  "8- Agosto_2022.csv",    
  "9- Setiembre_2022.csv", 
  "10- Octubre_2022.csv",  
  "11- Noviembre_2022.csv",
  "12- Diciembre_2022.csv",
  "13- Enero_2023.csv",    
  "14- Febrero_2023.csv",  
  "15- Marzo_2023.csv"
)

# Bucle para convertir todos los archivos CSV a RDS
for (archivo_csv in archivos) {
  # Extraer año y mes del nombre del archivo CSV
  anio <- gsub(".*[^0-9](\\d{4}).*\\.csv", "\\1", basename(archivo_csv))
  mes_texto <- gsub(".* ([A-Za-z]+)_\\d{4}\\.csv", "\\1", basename(archivo_csv))
  meses <- c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Setiembre", "Octubre", "Noviembre", "Diciembre")
  mes_numero <- which(meses == mes_texto)
  if (mes_numero < 10) {
    mes_numero <- paste0("0", mes_numero)
  }
  # Generar el nombre del archivo RDS en formato YYYYMM.rds
  archivo_rds <- paste0(anio, mes_numero, ".rds")
  ruta_rds <- file.path(".", archivo_rds)
  convertir_csv_a_rds(archivo_csv, ruta_rds)
  cat("Archivo", archivo_csv, "convertido a", ruta_rds, "\n")
}

# Lista todos los archivos RDS en el directorio Transporte/RDS
archivos_rds <- list.files(path = ".", pattern = "\\.rds$", full.names = TRUE)

# Carga y une todos los archivos RDS en un solo conjunto de datos
datos_unidos <- lapply(archivos_rds, readRDS) %>% 
  do.call(rbind, .)

# Convierte el conjunto de datos unido en un data.table
datos_unidos <- as.data.table(datos_unidos)

# Guarda el conjunto de datos unido en un nuevo archivo RDS
saveRDS(datos_unidos, file = "datos_unidos.rds")

# Guarda el conjunto de datos unido en un archivo CSV
fwrite(datos_unidos, file = "datos_unidos.csv")