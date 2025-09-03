#include <WiFi.h>
#include <HTTPClient.h>
#include <WebServer.h>

WiFiServer server(80);

const char* ssid = "Metali";       // Nombre de tu red Wi-Fi
const char* password = "momoko3112";   // Contraseña de tu red Wi-Fi

const char* serverIP = "192.168.191.7"; // Dirección IP de tu servidor Apache2
const int serverPort = 80;  // Puerto del servidor Apache2

const int potPin = 34;      // Pin al que está conectado el potenciómetro
const int led1 = 35;
const int led2 = 32;
const int led3 = 33;
const int led4 = 26;

int numero = 0;

void setup() {
  Serial.begin(115200);

  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(led3, OUTPUT);
  pinMode(led4, OUTPUT);

  // Conectar a la red Wi-Fi
  WiFi.begin(ssid, password);
  Serial.print("Conectando a ");
  Serial.print(ssid);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("Conexión WiFi establecida");
  server.begin();
}

void loop() {
  // Leer el valor del potenciómetro

  int potValue = analogRead(potPin);
  Serial.print("Valor del potenciómetro: ");
  Serial.println(potValue);

  // Crear la URL para enviar el valor al servidor
  String url = "http://";
  url += serverIP;
  url += "/guardar_valor.php?valor=";
  url += String(potValue);


  // Realizar la solicitud HTTP al servidor
  HTTPClient http;
  http.begin(url);
  int httpResponseCode = http.GET();
  if (httpResponseCode > 0) {
    Serial.print("Respuesta del servidor: ");
    Serial.println(httpResponseCode);
  } else {
    Serial.print("Error en la solicitud HTTP: ");
    Serial.println(httpResponseCode);
  }
  http.end();

  // Esperar a que se reciba una nueva conexión
  WiFiClient client = server.available();
  if (!client) {
    return;
  }

  // Esperar hasta que se reciba una solicitud HTTP
  while (!client.available()) {
    delay(1);
  }

  // Leer la solicitud HTTP
  String request = client.readStringUntil('\r');
  client.flush();

  // Extraer el número de la solicitud
  
  if (request.indexOf("/enviar_numero.php?numero=") != -1) {
    if (request.indexOf("GET /enviar_numero.php?numero=") != -1) {
    int inicio_numero = request.indexOf("=") + 1;
    int fin_numero = request.indexOf(" ", inicio_numero);
    String numero_str = request.substring(inicio_numero, fin_numero);
    numero = numero_str.toInt();
    Serial.println(numero);
    }
  }

  // Enviar una respuesta al cliente
  client.println("HTTP/1.1 200 OK");
  client.println("Content-Type: text/html");
  client.println(""); // Cuerpo de la respuesta
  client.println("<!DOCTYPE HTML>");
  client.println("<html>");
  client.println("<h1>Número recibido por la ESP32:</h1>");
  client.println("<p>" + String(numero) + "</p>");
  client.println("</html>");

  // Cerrar la conexión
  delay(5000);
  client.stop();

  delay(1000); // Esperar 1 segundos antes de enviar el siguiente valor
  
  digitalWrite(led1, bitRead(numero, 3));
  digitalWrite(led2, bitRead(numero, 2));
  digitalWrite(led3, bitRead(numero, 1));
  digitalWrite(led4, bitRead(numero, 0));
}