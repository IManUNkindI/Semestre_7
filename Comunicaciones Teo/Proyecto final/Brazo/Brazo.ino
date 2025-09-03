#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>

// Definimos los pines a los que conectaremos los servomotores
const int servoPin1 = 12;
const int servoPin2 = 13;
const int servoPin3 = 14;

// Definimos la frecuencia de la señal PWM para los servomotores (50 Hz)
const int servoFreq = 50;

// Definimos la resolución del PWM (bits)
const int pwmResolution = 16;

// Definimos los canales de PWM que vamos a usar (hay 16 canales disponibles en el ESP32)
const int servoChannel1 = 0;
const int servoChannel2 = 1;
const int servoChannel3 = 2;

// Constantes para el cálculo del ciclo de trabajo
const int minDutyCycle = 1360;  // Correspondiente a 1 ms (mínimo ángulo)
const int maxDutyCycle = 7640;  // Correspondiente a 2 ms (máximo ángulo)

int PWM1 = 90; //Eje perpendicular a la base
int PWM2 = 90; //Eje Y1
int PWM3 = 90; //Eje Y2
int PWM4 = 90; //Garra

const char* ssid = "Metali";
const char* password = "momoko3112";
const char* serverAddress = "http://192.168.175.7:3112/Brazo";
const size_t capacity = JSON_OBJECT_SIZE(2) + 20;

void setup() {
  Serial.begin(115200);

  // Inicializamos la comunicación serial a 115200 baudios
  Serial.begin(115200);

  // Inicializamos los canales de PWM
  ledcSetup(servoChannel1, servoFreq, pwmResolution);
  ledcSetup(servoChannel2, servoFreq, pwmResolution);
  ledcSetup(servoChannel3, servoFreq, pwmResolution);
  
  // Asignamos los canales PWM a los pines definidos
  ledcAttachPin(servoPin1, servoChannel1);
  ledcAttachPin(servoPin2, servoChannel2);
  ledcAttachPin(servoPin3, servoChannel3);

  connectToWiFi();
}

void loop() {
  // Enviamos los valores de PWM a los servomotores
  int dutyCycle1 = map(PWM1, 0, 180, minDutyCycle, maxDutyCycle);
  int dutyCycle2 = map(PWM2, 0, 180, minDutyCycle, maxDutyCycle);
  int dutyCycle3 = map(PWM3, 0, 180, minDutyCycle, maxDutyCycle);

  ledcWrite(servoChannel1, dutyCycle1);
  ledcWrite(servoChannel2, dutyCycle2);
  ledcWrite(servoChannel3, dutyCycle3);

  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;

    // Enviar solicitud GET al servidor
    http.begin(serverAddress);
    int httpResponseCode = http.GET();

    if (httpResponseCode == HTTP_CODE_OK) {
      String payload = http.getString();
      DynamicJsonDocument doc(capacity);
      DeserializationError error = deserializeJson(doc, payload); // Deserializar el JSON
      
      if (!error) {
        int x = doc["x"];
        int y = doc["y"];
        Serial.print("x = ");
        Serial.print(x);
        Serial.print(", y = ");
        Serial.println(y);
        Serial.print(PWM1);
        Serial.print(" ");
        Serial.print(PWM2);
        Serial.print(" ");
        Serial.print(PWM3);
        Serial.print(" ");
        Serial.println(PWM4);
        if(x <= -2000){
          if (PWM1 < 180){
            PWM1 = PWM1 + 10;
          }else{
            PWM1 = 180;
          }
        }else if(x >= 2000){
          if (PWM1 > 0){
            PWM1 = PWM1 - 10;
          }else{
            PWM1 = 0;
          }
        }else if(y >= 2000){
          if (PWM2 < 110){
            PWM2 = PWM2 + 10;
          }else if (PWM3 < 180){
            PWM2 = 110;
            PWM3 = PWM3 + 10;
          }else{
            PWM3 = 180;
          }
        }else if(y <= -2000){
          if (PWM3 > 0){
            PWM3 = PWM3 - 10;
          }else if (PWM2 > 10){
            PWM3 = 0;
            PWM2 = PWM2 - 10;
          }else{
            PWM2 = 10;
          }
        }
        if(x <= -1000){
          if (PWM1 < 180){
            PWM1 = PWM1 + 5;
          }else{
            PWM1 = 180;
          }
        }else if(x >= 1000){
          if (PWM1 > 0){
            PWM1 = PWM1 - 5;
          }else{
            PWM1 = 0;
          }
        }else if(y >= 1000){
          if (PWM2 < 110){
            PWM2 = PWM2 + 5;
          }else if (PWM3 < 180){
            PWM2 = 110;
            PWM3 = PWM3 + 5;
          }else{
            PWM3 = 180;
          }
        }else if(y <= -1000){
          if (PWM3 > 0){
            PWM3 = PWM3 - 5;
          }else if (PWM2 > 10){
            PWM3 = 0;
            PWM2 = PWM2 - 5;
          }else{
            PWM2 = 10;
          }
        }
        if(x <= -500){
          if (PWM1 < 180){
            PWM1 = PWM1 + 2;
          }else{
            PWM1 = 180;
          }
        }else if(x >= 500){
          if (PWM1 > 0){
            PWM1 = PWM1 - 2;
          }else{
            PWM1 = 0;
          }
        }else if(y >= 500){
          if (PWM2 < 110){
            PWM2 = PWM2 + 2;
          }else if (PWM3 < 180){
            PWM2 = 110;
            PWM3 = PWM3 + 2;
          }else{
            PWM3 = 180;
          }
        }else if(y <= -500){
          if (PWM3 > 0){
            PWM3 = PWM3 - 2;
          }else if (PWM2 > 10){
            PWM3 = 0;
            PWM2 = PWM2 - 2;
          }else{
            PWM2 = 10;
          }
        }
      } else {
        Serial.print("Error en la deserialización: ");
        Serial.println(error.c_str());
      }
    } else {
      Serial.print("Error en la solicitud: ");
      Serial.println(httpResponseCode);
    }

    http.end();
  } else {
    Serial.println("WiFi no conectado");
    connectToWiFi(); // Intentar reconectar
  }

  delay(500); // Esperar 0.5 segundos antes de la siguiente solicitud
}

void connectToWiFi() {
  Serial.println("Conectando a WiFi...");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Conectando a WiFi...");
  }
  Serial.println("Conectado a WiFi");
}
