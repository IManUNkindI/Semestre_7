const int pinADC = 36; // Pin del ADC a utilizar
const int numSamples = 80000; // Número de muestras a capturar
unsigned char samples[numSamples]; // Arreglo para almacenar las muestras
bool samplesCaptured = false; // Flag para indicar si las muestras han sido capturadas

void setup() {
  Serial.begin(115200);
}

void loop() {
  if (!samplesCaptured) { // Si las muestras aún no han sido capturadas
    // Captura de muestras
    for (int i = 0; i < numSamples; ) {
      int val = analogRead(pinADC);
      if (val < 1000 ){ // Solo almacenar valores menores a 1024
        samples[i] = val;
        if (samples[i] > 0) {
          i++; // Avanzar solo si el valor es mayor que 0
        }
      }
    }
    delay(10);

    samplesCaptured = true; // Marcar las muestras como capturadas

    // Impresión de las muestras capturadas en una sola línea
    Serial.println("Muestras capturadas:");
    for (int i = 0; i < numSamples; i++) {
      Serial.print(samples[i]);
      if (i < numSamples - 1) {
        Serial.print(", "); // Agregar coma y espacio después de cada valor excepto el último
      }
    }
    Serial.println(); // Imprimir nueva línea al final
    delay(1000);
  }

  // Espera infinita
  while (true) {}
}
