#include <WiFi.h>
#include <WiFiUdp.h>

const char* ssid = "Dime lindura";
const char* password = "lindura ";
const char* ip = "192.168.21.102";
const int udpPort = 12345;
WiFiUDP udp;

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Conectando al WiFi...");
  }
  Serial.println("Conectado al WiFi");
  
  udp.begin(udpPort);
  Serial.printf("Servidor UDP iniciado en el puerto %d\n", udpPort);
}

void loop() {
  // Envía datos al dispositivo a
  String message = "Hola desde dispositivo B, miVariable: ";
  int miVariable = 2; // Aquí defines tu variable
  message += String(miVariable); // Agrega la variable al mensaje
  udp.beginPacket(ip, udpPort);
  udp.print(message);
  udp.endPacket();
  Serial.println("Mensaje enviado");
    // Espera a recibir datos
  int packetSize = udp.parsePacket();
  if (packetSize) {
    // Lee los datos recibidos
    char packetBuffer[255];
    int len = udp.read(packetBuffer, 255);
    if (len > 0) {
      packetBuffer[len] = 0;
    }
    Serial.printf("Recibido desde %s:%d: %s\n", udp.remoteIP().toString().c_str(), udp.remotePort(), packetBuffer);
  }
  delay(5000); // Espera 5 segundos antes de enviar el próximo mensaje
}

