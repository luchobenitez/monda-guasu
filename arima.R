# Instalar paquetes necesarios
install.packages("forecast")
install.packages("xts")
install.packages("ggplot2")
install.packages("gridExtra")
install.packages("kableExtra")

# Cargar paquetes
library(data.table)
library(forecast)
library(xts)
library(ggplot2)
library(gridExtra)
library(kableExtra)

####################
# Analisis por hora
####################

# Leer los datos desde el archivo RDS y almacenar en 'datos_unidos'
datos_unidos <- readRDS("datos_unidos.rds")

# Agrupar eventos por idrutaestacion, idsam, y hora
conteo_eventos <- datos_unidos[, .N, by = .(idrutaestacion, idsam, hora)]

# Crear objeto xts
eventos_xts <- xts(conteo_eventos$N, order.by = conteo_eventos$hora)


# Descomposición STL y predicción ARIMA por hora
eventos_stl_plot <- autoplot(eventos_stl)
prediccion_arima_plot <- autoplot(prediccion_arima)

# Descomposición STL y predicción ARIMA por día de la semana
stl_plots <- list()
prediccion_plots <- list()

for (dia in dias_semana) {
  resultados_dia <- resultados_dia_semana[[dia]]
  stl_plots[[dia]] <- autoplot(resultados_dia$stl)
  prediccion_plots[[dia]] <- autoplot(resultados_dia$prediccion)
}

pdf(file = "todos_los_graficos_y_tablas.pdf")

# Descomposición STL y predicción ARIMA por hora
grid.arrange(eventos_stl_plot, prediccion_arima_plot, ncol = 2)

# Descomposición STL y predicción ARIMA por día de la semana
for (dia in dias_semana) {
  grid.arrange(stl_plots[[dia]], prediccion_plots[[dia]], ncol = 2)
}

# Tablas de conteo de eventos
conteo_eventos_kable <- kable(conteo_eventos, "latex", booktabs = T, longtable = T) %>% kable_styling(latex_options = "scale_down")
conteo_eventos_dia_semana_kable <- kable(conteo_eventos_dia_semana, "latex", booktabs = T, longtable = T) %>% kable_styling(latex_options = "scale_down")

cat(kableExtra::latex_dependency_scale_down(), file = "todos_los_graficos_y_tablas.tex", sep = "\n", append = TRUE)
cat(conteo_eventos_kable, file = "todos_los_graficos_y_tablas.tex", sep = "\n", append = TRUE)
cat(conteo_eventos_dia_semana_kable, file = "todos_los_graficos_y_tablas.tex", sep = "\n", append = TRUE)

dev.off()

tools::texi2pdf("todos_los_graficos_y_tablas.tex")
