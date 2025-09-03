#include <WiFi.h>
#include <WiFiClient.h>
#include <WiFiServer.h>

#define LED_PIN_1 12
#define LED_PIN_2 13
#define LED_PIN_3 14

const int pinX = 34;  // Pin D34 para el eje X
const int pinY = 35;  // Pin D35 para el eje Y
const int pinZ = 26;  // Pin D36 para el eje Z

WiFiServer server(65432);

void setup() {
  Serial.begin(115200);
  delay(1000);

  pinMode(LED_PIN_1, OUTPUT);
  pinMode(LED_PIN_2, OUTPUT);
  pinMode(LED_PIN_3, OUTPUT);

  WiFi.begin("Metali", "momoko3112");
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Conectando a WiFi...");
  }
  Serial.println("Conectado a la red WiFi");

  Serial.print("Dirección IP asignada: ");
  Serial.println(WiFi.localIP());

  server.begin();
}

void loop() {
  WiFiClient client = server.available();
  if (client) {
    Serial.println("Cliente conectado");

    while (client.connected()) {
      if (client.available()) {
        char command = client.read();
        if (command == '5') {
          // Encender LED 1 y LED 3
          digitalWrite(LED_PIN_1, HIGH);
          digitalWrite(LED_PIN_2, LOW);
          digitalWrite(LED_PIN_3, HIGH);
          Serial.println("Comando recibido desde el cliente: 5");
        } else if (command == '8') {
          // Encender LED 1 y LED 2
          digitalWrite(LED_PIN_1, HIGH);
          digitalWrite(LED_PIN_2, HIGH);
          digitalWrite(LED_PIN_3, LOW);
          Serial.println("Comando recibido desde el cliente: 8");
        } else {
          // Otro comando
          Serial.println("Comando no reconocido");
        }
      }

      int xValue = analogRead(pinX);
      int yValue = analogRead(pinY);
      int zValue = analogRead(pinZ);

      Serial.print("xValue:");
      Serial.print(xValue);
      Serial.print(", yValue:");
      Serial.print(yValue);
      Serial.print(", zValue:");
      Serial.println(zValue);

      // Envía los valores de xValue, yValue y zValue al cliente
      client.print(xValue);
      client.print(",");
      client.print(yValue);
      client.print(",");
      client.println(zValue);
      
      delay(1000); // Ajusta el intervalo de transmisión aquí según tus necesidades
    }

    client.stop();
    Serial.println("Cliente desconectado");
  }

  delay(100);
}