#include <Wire.h>
#include <SPI.h>

void setup() {
  Serial.begin(9600); // Iniciar la comunicación serial a 9600 baudios

  // Configurar pines para SPI
  SPI.begin(18, 19, 23, 5); // SCK, MISO, MOSI, SS

  Wire.begin(8); // Iniciar la comunicación I2C con dirección 8
  Wire.onReceive(receiveEvent); // Configurar la función de callback para el evento de recepción I2C
}

void loop() {
  // Recepción por SPI
  receiveSPI();

  // Recepción por I2C
  receiveEvent(Wire.available());

  // Recepción por Serial
  receiveSerial();
}

// Función de callback para el evento de recepción I2C
void receiveEvent(int byteCount) {
  while (Wire.available()) {
    float receivedVoltage0;
    Wire.readBytes((char*)&receivedVoltage0, sizeof(receivedVoltage0)); // Leer el voltaje recibido como un float
    Serial.print("Voltaje recibido por I2C: ");
    Serial.println(receivedVoltage0);
  }
}

// Función para recibir datos por SPI
void receiveSPI() {
  uint16_t receivedRawValue = SPI.transfer16(0); // Leer el valor crudo recibido como un valor de 16 bits
  float receivedVoltage1 = Serial.parseFloat(); // Convertir el valor crudo a voltaje
  Serial.print("Voltaje recibido por SPI: ");
  Serial.println(receivedVoltage1);
}

// Función para recibir datos por comunicación serial
void receiveSerial() {
  float receivedVoltage2 = Serial.parseFloat(); // Leer el voltaje recibido como un float
  Serial.print("Voltaje recibido por Serial: ");
  Serial.println(receivedVoltage2);
}