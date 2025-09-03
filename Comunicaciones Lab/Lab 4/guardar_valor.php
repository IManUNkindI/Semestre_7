<?php
$valor = $_GET['valor']; // Obtener el valor enviado por el ESP32

$archivo = 'valor_potenciometro.txt';
file_put_contents($archivo, $valor); // Limpiar el archivo y guardar el nuevo valor
echo "¡Valor guardado correctamente!";
?>
