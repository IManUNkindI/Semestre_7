#include <WiFi.h>
#include <WiFiUdp.h>

#define MIC_PIN 34 // Pin al que está conectado el micrófono
#define SPEAKER_PIN 26 // Pin al que está conectada la bocina
#define BUTTON_PIN 23 // Pin al que está conectado el botón
#define SAMPLE_WINDOW 5000 // Tiempo total de grabación en milisegundos
#define SAMPLE_DELAY 25 // Intervalo de tiempo entre cada muestra en milisegundos

bool buttonState = false;
bool prevButtonState = false;
bool recording = false;
bool playAudio = false;

unsigned int recordedAudio[SAMPLE_WINDOW / SAMPLE_DELAY]; // Arreglo para almacenar las lecturas del micrófono
int reproducir[SAMPLE_WINDOW / SAMPLE_DELAY];

const char* ssid = "ARRIS-F149";
const char* password = "A4438CB0F149";
const char* host = "192.168.0.13";
WiFiServer server(1233);

void setup() {
  Serial.begin(115200);
  pinMode(BUTTON_PIN, INPUT);
  pinMode(SPEAKER_PIN, OUTPUT);
  delay(1000);

  WiFi.begin(ssid, password);
  server.begin();
  Serial.println("Conectando al WiFi...");

  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Conectando...");
  }

  Serial.println("Conectado al WiFi");
  Serial.print("Dirección IP: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  buttonState = digitalRead(BUTTON_PIN); // Leer el estado del botón
  
  if (buttonState != prevButtonState) {
    if (buttonState == HIGH) { // Si el botón se acaba de pulsar
      recording = true; // Comenzar la grabación
      playAudio = false; // Desactivar la reproducción del audio
    } else { // Si el botón se acaba de soltar
      recording = false; // Detener la grabación
      playAudio = true; // Activar la reproducción del audio
    }
    prevButtonState = buttonState;
  }

  WiFiClient client = server.available(); // Acepta una conexión
  if (client) {
    Serial.println("Cliente conectado");
    while (client.connected()) {
      if (client.available()) {
        String data = client.readStringUntil('\n'); // Lee los datos enviados por el cliente
        Serial.println("Mensaje recibido: " + data);
        if (recording) { // Si se está grabando
        unsigned long startMillis = millis(); // Tiempo inicial de la grabación
        int index = 0; // Índice para almacenar las lecturas del micrófono
    
    // Realizar múltiples lecturas del micrófono durante el tiempo de grabación
    while (millis() - startMillis < SAMPLE_WINDOW) {
      if (millis() - startMillis > index * SAMPLE_DELAY) {
        int sample = analogRead(MIC_PIN); // Leer el valor del pin del micrófono
        recordedAudio[index] = sample; // Almacenar la lectura en el arreglo
        index++; // Incrementar el índice
      }
      delay(1); // Pequeña pausa para evitar bloqueo
    }
  }
        // Aquí puedes hacer lo que desees con el mensaje recibido
        
        client.stop(); // Cierra la conexión
        Serial.println("Cliente desconectado");
      }
    }
  }
  if (playAudio) { // Si se va a reproducir el audio
    // Reproducir el audio grabado a través de la bocina
    for (int i = 0; i < SAMPLE_WINDOW / SAMPLE_DELAY; i++) {
      dacWrite(SPEAKER_PIN, recordedAudio[i] / 4); // Escalar la amplitud para ajustarla al rango del DAC
      client.println(recordedAudio[i]);
      Serial.println(recordedAudio[i]);
      delay(SAMPLE_DELAY); // Esperar el tiempo de muestra
    }
    dacWrite(SPEAKER_PIN, 0); // Detener la reproducción
    playAudio = false; // Desactivar la reproducción del audio
  }
  
  if (WiFi.status() == WL_CONNECTED) {
    WiFiClient client;

    if (client.connect(host, 1234)) { // Conexión al servidor
      Serial.println("Conectado al servidor");
      client.println("Hola desde ESP32 - 2"); // Mensaje a enviar
      client.stop(); // Cierra la conexión
    } else {
      Serial.println("Error al conectar al servidor");
    }

    delay(500); // Espera antes de enviar otro mensaje
  }
  //for(int j = 0;j < SAMPLE_WINDOW / SAMPLE_DELAY; j++){
  //  recordedAudio[j]=0;
  //}
}