#include "Nano33BleHID.h"
#include "signal_utils.h"
#include "Arduino_BMI270_BMM150.h"

Nano33BleKeyboard bleKb("Strum Keyboard");

// Strumming detection parameters
const float accelerationThreshold = 2.2; // G-force threshold for detecting a strum
unsigned int last_strum = millis();
const unsigned int strum_debounce = 180; // Debounce time (ms)


void setup() {
  Serial.begin(115200);

  // Initialize IMU sensor
  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
    while (1);
  }

  // Initialize BLE HID keyboard
  bleKb.initialize();
  
  // Start BLE event queue
  MbedBleHID_RunEventThread();
}

void loop() {
  float aX, aY, aZ;
  
  // Read acceleration data
  if (IMU.accelerationAvailable()) {
    IMU.readAcceleration(aX, aY, aZ);
    float aSum = fabs(aX) + fabs(aY) + fabs(aZ); // Sum of absolute accelerations

    if (aSum >= accelerationThreshold && millis() - last_strum > strum_debounce) {
      Serial.println("Strum detected!");
      bleKb.hid()->sendCharacter(' '); // ✅ Send SPACE key via Bluetooth
      last_strum = millis(); // Update last strum time
    }
  }
}
