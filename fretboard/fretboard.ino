#include <Keyboard.h>

int RED1 = D0;
int BLU2 = D1;
int YEL3 = D2;
int GRE4 = D3;
const int SEND_PIN = D4;
const int RECEIVE_PIN = D5;
int BUTTON = D6;



// Cap touch global vars
const int NUM_SAMPLES = 1000;
const int windowSize = 10;
int readings[windowSize] = {0};
int readIndex = 0;
long totalSum = 0;
float rollingAvg = 0;

int baseline = 0;

void setup() {
  Serial.begin(115200);
  pinMode(RED1, INPUT_PULLUP);
  pinMode(BLU2, INPUT_PULLUP);
  pinMode(YEL3, INPUT_PULLUP);
  pinMode(GRE4, INPUT_PULLUP);
  pinMode(BUTTON, INPUT);
  int sum = 0;
  for (int i = 0; i < NUM_SAMPLES; i++) {
    sum += capSense(SEND_PIN, RECEIVE_PIN);
  }
  baseline = sum;

  // Initialize the rolling average buffer
  for (int i = 0; i < windowSize; i++) {
    readings[i] = 0;
  }
}

// Fretboard Global Vars
int RED1_PREV = 0;
int BLU2_PREV = 0;
int YEL3_PREV = 0;
int GRE4_PREV = 0;

unsigned long RED1_lastChanged = millis();
unsigned long BLU2_lastChanged = millis();
unsigned long YEL3_lastChanged = millis();
unsigned long GRE4_lastChanged = millis();

unsigned long startTime = millis();

unsigned long debounce = 100;

// Button Global Vars
int BUTTON_PREV = 1;



void loop() {
  int RED1_VAL = !digitalRead(RED1);
  int BLU2_VAL = !digitalRead(BLU2);
  int YEL3_VAL = !digitalRead(YEL3);
  int GRE4_VAL = !digitalRead(GRE4); 
  int press = digitalRead(BUTTON);

  // Button to toggle instruments
  if (press != BUTTON_PREV) {
    if (!press && BUTTON_PREV) {
      Keyboard.write('A');
    }
    BUTTON_PREV = press;
  }

  // Red button
  if (RED1_VAL != RED1_PREV && millis() - RED1_lastChanged >= debounce) {
    if (RED1_VAL == 1) {
      Keyboard.press('1');
    }
    else {
      Keyboard.release('1');
    }
    RED1_PREV = RED1_VAL;
    RED1_lastChanged = millis();
  }
  // Blue button
  if (BLU2_VAL != BLU2_PREV && millis() - BLU2_lastChanged >= debounce) {
    if (BLU2_VAL == 1) {
      Keyboard.press('2');
    }
    else {
      Keyboard.release('2');
    }
    BLU2_PREV = BLU2_VAL;
    BLU2_lastChanged = millis();
  }
  // Yellow Button
  if (YEL3_VAL != YEL3_PREV && millis() - YEL3_lastChanged >= debounce) {
    if (YEL3_VAL == 1) {
      Keyboard.press('3');
    }
    else {
      Keyboard.release('3');
    }
    YEL3_PREV = YEL3_VAL;
    YEL3_lastChanged = millis();
  }
  // Green Button
  if (GRE4_VAL != GRE4_PREV && millis() - GRE4_lastChanged >= debounce) {
    if (GRE4_VAL == 1) {
      Keyboard.press('4');
    }
    else {
      Keyboard.release('4');
    }
    GRE4_PREV = GRE4_VAL;
    GRE4_lastChanged = millis();
  }

  // Capactive touch
  int total = 0;
  for (int i = 0; i < NUM_SAMPLES; i++) {
    total += capSense(SEND_PIN, RECEIVE_PIN);
  }
  int sensorValue = total - baseline;

  totalSum = totalSum - readings[readIndex] + sensorValue;
  readings[readIndex] = sensorValue;
  readIndex = (readIndex + 1) % windowSize;
  rollingAvg = totalSum / (float)windowSize;

  // Also printing dummy values (100000 and -2000) to fix the Serial Plotter scale.
  Serial.println(rollingAvg);
}

int capSense(int sendPin, int receivePin) {
  pinMode(receivePin, OUTPUT);
  digitalWrite(receivePin, LOW);

  pinMode(sendPin, OUTPUT);
  digitalWrite(sendPin, LOW);
  delayMicroseconds(1); // Adding some delay before switching to HIGH

  pinMode(receivePin, INPUT);
  digitalWrite(sendPin, HIGH);

  int count = 0;
  while (digitalRead(receivePin) == LOW) {
    count++;
    // Safety break to avoid infinite loop if permanently grounded
    if (count > 32000) {
      break;
    }
  }
  return count;
}

