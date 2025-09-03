#include <Wire.h>
#include <SPI.h>

const int potPin = 15; // Pin al que está conectado el potenciómetro

void setup() {
  Serial.begin(9600); // Iniciar la comunicación serial a 9600 baudios
  Wire.begin(); // Iniciar la comunicación I2C
    // Configurar pines para SPI
  SPI.begin(18, 19, 23, 5); // SCK, MISO, MOSI, SS
}

void loop() {
  int sensorValue = analogRead(potPin); // Leer el valor analógico del pin
  float voltage = sensorValue * (3.3 / 4095); // Convertir el valor a voltaje (3.3V es el voltaje de referencia del ESP32)

  Serial.println(voltage); // Mostrar el valor del voltaje por comunicación serial

  // Envío por I2C
  Wire.beginTransmission(8); // Dirección del esclavo (cambia según la dirección I2C del otro ESP32)
  Wire.write((byte*)&voltage, sizeof(voltage)); // Enviar el valor del voltaje como un float
  Wire.endTransmission();

  // Envío por SPI
  SPI.beginTransaction(SPISettings(1000000, MSBFIRST, SPI_MODE0)); // Configurar la comunicación SPI
  digitalWrite(5, LOW); // Habilitar el esclavo SPI
  SPI.transfer((byte*)&voltage, sizeof(voltage)); // Enviar el valor del voltaje como un float
  digitalWrite(5, HIGH); // Deshabilitar el esclavo SPI
  SPI.endTransaction(); // Finalizar la comunicación SPI

  delay(500); // Esperar 1 segundo antes de volver a leer
}