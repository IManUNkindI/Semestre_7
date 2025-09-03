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

void setup() {
  Serial.begin(9600);
  pinMode(BUTTON_PIN, INPUT);
  pinMode(SPEAKER_PIN, OUTPUT);
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
  } else if (playAudio) { // Si se va a reproducir el audio
    // Reproducir el audio grabado a través de la bocina
    for (int i = 0; i < SAMPLE_WINDOW / SAMPLE_DELAY; i++) {
      dacWrite(SPEAKER_PIN, recordedAudio[i] / 4); // Escalar la amplitud para ajustarla al rango del DAC
      delay(SAMPLE_DELAY); // Esperar el tiempo de muestra
    }
    dacWrite(SPEAKER_PIN, 0); // Detener la reproducción
    playAudio = false; // Desactivar la reproducción del audio
  }
}
