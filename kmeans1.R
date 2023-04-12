if (!require(knitr)) {
  install.packages("knitr")
  library(knitr)
}

# Instalar y cargar los paquetes necesarios
if (!require(dplyr)) {
  install.packages("dplyr")
  library(dplyr)
}

if (!require(ggplot2)) {
  install.packages("ggplot2")
  library(ggplot2)
}

if (!require(cluster)) {
  install.packages("cluster")
  library(cluster)
}

if (!require(factoextra)) {
  install.packages("factoextra")
  library(factoextra)
}

if (!require(scales)) {
  install.packages("scales")
  library(scales)
}

if (!require(umap)) {
  install.packages("umap")
  library(umap)
}

if (!require(plotly)) {
  install.packages("plotly")
  library(plotly)
}

# Leer el CSV resultante del query de SQL
# Asegúrate de tener el archivo kmeans_data.csv en tu directorio de trabajo
df <- read.csv("kmeans_data.csv")

# Ordenar df por count y limitar a los primeros 100000 por razones computacionales. Eliminar valores NA
df <- df %>%
  arrange(desc(count)) %>%
  head(100000) %>%
  na.omit()

# Separar la columna id
id_col <- df$serialtarjeta
df_corr <- df %>% select(-serialtarjeta)

# Encontrar las mejores columnas para el clustering usando correlación
corr_matrix <- cor(df_corr)
corr_with_id <- corr_matrix[1,]
best_cols <- names(corr_with_id[abs(corr_with_id) > 0.1])
cat("Best columns for clustering:", best_cols, "\n")

# Graficar la matriz de correlación usando un mapa de calor
# Guardar la matriz de correlación como objeto
heatmap <- ggplot(corr_matrix, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile() +
  scale_fill_gradient2(low="white", high="blue") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Normalizar los datos
df_norm <- scale(df[best_cols])

# Determinar el número óptimo de clusters usando KneeLocator
distortions <- c()
n_columns <- length(best_cols) + 1

for (k in 1:(n_columns - 1)) {
  kmeans <- kmeans(df_norm, centers = k)
  distortions <- c(distortions, kmeans$tot.withinss)
}

# Guardar gráfico de número óptimo de clusters
kl_plot <- fviz_nbclust(df_norm, FUN = kmeans, method = "wss") + theme_minimal()

# Ajustar el modelo KMeans utilizando el número óptimo de clusters
optimal_clusters <- kl$data$NbCluster[which.min(kl$data$gap)]
kmeans <- kmeans(df_norm, centers = optimal_clusters)

# Agregar las etiquetas de cluster y la columna id al dataframe
df$cluster <- kmeans$cluster
df$serialtarjeta <- id_col

# Imprimir los tamaños de los clusters
print(table(df$cluster))

# Crear un gráfico de dispersión de los datos coloreados por cluster
# Guardar el gráfico de dispersión
scatter_plot <- ggplot(df, aes(x = avg_consecutivoevento, y = count, color = as.factor(cluster))) +
  geom_point() +
  scale_y_log10() +
  scale_x_log10() +
  theme_minimal()


# Abrir dispositivo de gráficos PDF
pdf("results.pdf")

# Imprimir gráficos en el archivo PDF
print(heatmap)
print(kl_plot)
print(scatter_plot)

# Cerrar dispositivo de gráficos PDF y guardar el archivo
dev.off()

# Ajustar UMAP a los datos normalizados
set.seed(42)
umap_model <- umap(df_norm, metric = "euclidean")

# Agregar las coordenadas UMAP al dataframe
df$umap_x <- umap_model$layout[, 1]
df$umap_y <- umap_model$layout[, 2]

# Crear un gráfico de dispersión de los datos coloreados por cluster
umap_plot <- ggplot(df, aes(x = umap_x, y = umap_y, color = as.factor(cluster))) +
  geom_point() +
  theme_minimal()

# Imprimir el gráfico de dispersión UMAP
print(umap_plot)

# Para guardar el gráfico de dispersión UMAP en el archivo PDF
pdf("results_with_umap.pdf")
print(heatmap)
print(kl_plot)
print(scatter_plot)
print(umap_plot)
dev.off()
