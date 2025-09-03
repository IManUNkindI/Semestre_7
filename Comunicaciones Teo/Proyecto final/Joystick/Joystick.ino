#include <WiFi.h>
#include <HTTPClient.h>

// Definir los pines de entrada para el joystick
const int pinX = 35;
const int pinY = 34;

// Configurar los datos de la red WiFi
const char* ssid = "Metali";
const char* password = "momoko3112";

// Dirección del servidor
const char* serverName = "http://192.168.175.7:3112/Joystick_Data";

void setup() {
  Serial.begin(115200);

  // Conectar a la red WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Conectando a WiFi...");
  }
  Serial.println("Conectado a WiFi");
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;

    int rawX = analogRead(pinX);
    int rawY = analogRead(pinY);

    int coordX = map(rawX, 0, 4095, -2047, 2047);
    int coordY = map(rawY, 0, 4095, -2047, 2047);

    http.begin(serverName);
    http.addHeader("Content-Type", "application/x-www-form-urlencoded");

    String httpRequestData = "x=" + String(coordX) + "&y=" + String(coordY);
    int httpResponseCode = http.POST(httpRequestData);

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println(httpResponseCode);
      Serial.println(response);
    } else {
      Serial.print("Error en la petición: ");
      Serial.println(httpResponseCode);
    }

    http.end();
  } else {
    Serial.println("WiFi no conectado");
  }

  delay(500); // Esperar 0.5 segundos antes de la siguiente lectura
}
