# Diccionario de Datos

## Tablas entregadas

Tenemos varios conjuntos de datos que fueron proveídos:

### Tabla de Transacciones

|Campo|Descripción|Tipo de Dato|
|-----|-----------|------------|
|serialtarjeta|Identificador de la tarjeta. Puede ser nominal o no, por lo que se puede llegar a la identidad del pasajero. Para nuestro análisis asumimos que es un pasajero|hash md5|
|idsam|Identificador del chip instalado en el equipo verificador. No necesariamente permanece con el mismo equipo verificador. Puede cambiar de bus, inclusive de línea o de EOT. Asumimos que identifica al bus|string|
|fechahoraevento|Timestamp del inicio del viaje|timestamp|
|producto|Tipo de producto donde:  - CR. Crédito o saldo negativo de la tarjeta - ES. Uso Especial (Estudiante o discapacitado) - MO. Monedero o uso normal|string|
|montoevento|Monto del evento descontado de la tarjeta. |entero|
|consecutivoevento|Identificador consecutivo de numero de transacción realizado con la tarjeta identificada con serialtarjeta|entero|
|identidad|Se refiere al propietario del validador donde: - 1. VMT - 2. MAS - 3. JAHA |entero|
|tipoevento|Tipo de evento donde: - 4. Viaje Normal - 8. Devolución - 10. Recarga de la tarjeta. - 14. Devolucion. Utilizaremos solo los del tipo 4|punto flotante|
|longitude|Longitud geográfica|punto flotante|
|Latitude|Latitude geográfica|punto flotante|
|idrutaestacion|Identificador de ruta asociado a una EOT. Ver tabla adicional|string|
|tipotransporte|Tipo de transporte donde - 0. Bus municipal interno - 1. Normal  - 3. Diferencial|entero|

### Tabla de Rutas

ideot,eot,troncal,idrutaestacion,ramal,estado

|Campo|Descripción|Tipo de Dato|
|-----|-----------|------------|
|ideot|Id de la EOT en la tabla|entero|
|eot | Empresa Operadora de Transporte | string|
|troncal | identificador de troncal|string|
|idrutaestacion| Identificador hexadecimal de la ruta|string|
|ramal|descripción del ramal|string|
|estado|descripción del ramal|string|
