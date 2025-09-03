#include "Arduino.h"
#include <WiFi.h>

// Definir el SSID y contraseña de la red WiFi
const char* ssid = "APS_PUB_R";
const char* password = "";

// Dirección IP del servidor
IPAddress serverIP(10, 0, 200, 38); // Cambia la dirección IP por la del servidor

// Definir el puerto del servidor
const int serverPort = 90;

// Definir los pines
const int pinMicrofono = 34;
const int pinBoton = 23;
const int pinDAC = 26;

// Definir la frecuencia de muestreo
const int frecuenciaMuestreo = 2205;

// Definir la duración de la grabación en segundos
const int duracionGrabacionSegundos = 5;

// Buffer para almacenar los datos de audio en la RAM
const size_t bufferSize = frecuenciaMuestreo * duracionGrabacionSegundos;
uint16_t buffer[bufferSize];

// Definir el servidor TCP
WiFiServer server(80);

bool grabar = false;
int salida = 0;

void setup() {
  Serial.begin(115200);
  pinMode(pinBoton, INPUT);
  pinMode(pinDAC, OUTPUT);

  // Configurar el ADC para obtener lecturas de 12 bits
  analogReadResolution(12);

    // Conectar a la red WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Conectando a la red WiFi...");
  }
  Serial.println("Conectado a la red WiFi");
  Serial.println(WiFi.localIP());

  // Configurar el servidor TCP
  server.begin();
  Serial.println("Servidor TCP iniciado");
  // Esperar a que un cliente se conecte
}
void loop() {
  grabar = digitalRead(pinBoton);
  if(grabar==true){
    Serial.println("Grabando...");

    // Leer datos del micrófono y almacenarlos en el buffer en la RAM
    for (size_t i = 0; i < bufferSize; i++) {
      buffer[i] = analogRead(pinMicrofono);
      delayMicroseconds(1000000 / frecuenciaMuestreo);
    }

    Serial.println("Grabación completa");
    
    Serial.println("Esperando cliente...");
    WiFiClient client = server.available();
    if (client) {
      Serial.println("Cliente conectado");
      // Enviar los datos de audio al cliente
      sendAudioData(client);
    }
    reproducirAudio();
    grabar = false;
  }
  // Conectar al servidor
  Serial.println("Conectando al servidor...");
  WiFiClient client;
  if (client.connect(serverIP, serverPort)) {
    Serial.println("Conectado al servidor");
    recibirYReproducirAudio(client);
  } else {
    Serial.println("Error al conectar al servidor");
  }
  delay(1000);
}
void recibirYReproducirAudio(WiFiClient& client) {
  Serial.println("Recibiendo audio...");

  // Recibir datos de audio y enviarlos al pin DAC para reproducción
  while (client.connected() && salida == 0) {
    salida = 1;
    if(client.available() != 0){
      while (client.available() < 2); // Esperar hasta que haya suficientes datos disponibles
      salida = 0;
      uint16_t datoAudio = client.read(); // Leer un byte (dato de audio)
      datoAudio |= (client.read() << 8); // Leer el siguiente byte (dato de audio) y combinarlo con el anterior
      dacWrite(pinDAC, datoAudio); // Enviar el dato de audio al pin DAC
      delay(5000);
    }
  }

  Serial.println("Reproducción completa");
}
void reproducirAudio() {
  Serial.println("Reproduciendo audio...");

  // Reproducir el audio almacenado en el buffer
  for (size_t i = 0; i < bufferSize; i++) {
    // Convertir la muestra digital a una señal analógica y enviarla al pin DAC
    dacWrite(pinDAC, buffer[i] >> 4); // El ESP32 DAC es de 8 bits, por lo que necesitamos desplazar 4 bits
    delayMicroseconds(1000000 / frecuenciaMuestreo);
  }

  Serial.println("Reproducción completa");
}
void sendAudioData(WiFiClient client) {
  // Enviar los datos de audio al cliente
  for (size_t i = 0; i < bufferSize; i++) {
    client.write(buffer[i] >> 4); // Enviar un byte a la vez
  }
  // Cerrar la conexión con el cliente
  client.stop();
}