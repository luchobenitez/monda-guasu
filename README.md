# monda-guasu

## Diccionario de Datos

|Campo|Descripción|Tipo de Dato|
|-----|-----------|------------|
|serialtarjeta|Serial de la tarjeta que identifica al pasajero. Asumimos que identifica a un pasajero|hash|
|idsam|Identificador único de dispositivo validador instalado en el bus. Asumimos que identifica al bus|hash|
|fechahoraevento|Timestamp del inicio del viaje|timestamp|
|producto|Tipo de producto (Aparentemente CR=Crédito, ES=Especial, MO=Monedero)|string|
|montoevento|Monto del evento descontado de la tarjeta (el monto podría estar relacionado a otros campos)|entero|
|consecutivoevento|Consecutivo del evento, contador de tipo de evento asociado a serialtarjeta y otros campos|entero|
|identidad|Identidad (valores 2 y 3)|entero|
|tipoevento|Tipo de evento (4 uso del producto / 8 ? / 10 Recarga del producto)|punto flotante|
|longitude|Longitud geográfica|punto flotante|
|Latitude|Latitude geográfica|punto flotante|
|idrutaestacion|Identificador de ruta asociado a una EOT|string|
|tipotransporte|Tipo de transporte (probablemente normal y diferencial)|entero|
