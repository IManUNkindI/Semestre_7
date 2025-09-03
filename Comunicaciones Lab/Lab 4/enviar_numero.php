<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Obtener el número entero enviado desde el formulario
    $numero = $_POST['numero'];

    // Enviar el número entero a la ESP32
    $esp32_ip = '192.168.191.251'; // Cambia esto por la dirección IP de tu ESP32
    $esp32_url = "http://$esp32_ip/enviar_numero.php?numero=$numero";
    $response = file_get_contents($esp32_url);
}

header("refresh:1;url=http://192.168.191.7/");
?>
