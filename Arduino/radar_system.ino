/**
 * @file    radar_system.ino
 * @brief   Smart Radar System using HC-SR04 Ultrasonic Sensor and Servo
 * @author  Your Name
 * @date    2026-08-14
 * @version 1.0
 * 
 * @description
 * This code sweeps a servo motor from 0° to 180° while continuously
 * measuring distance using an HC-SR04 ultrasonic sensor. The data is
 * transmitted over serial in the format: angle,distance
 * 
 * @hardware
 * - Arduino Uno/Nano/Mega
 * - HC-SR04 Ultrasonic Sensor
 * - SG90/MG995 Servo Motor
 * 
 * @connections
 * - HC-SR04 VCC  -> 5V
 * - HC-SR04 GND  -> GND
 * - HC-SR04 TRIG -> Pin 9
 * - HC-SR04 ECHO -> Pin 10
 * - Servo VCC    -> 5V
 * - Servo GND    -> GND
 * - Servo Signal -> Pin 11
 */

#include <Servo.h>

// ==============================
// PIN DEFINITIONS
// ==============================
#define TRIG_PIN  9   ///< HC-SR04 Trigger pin
#define ECHO_PIN  10  ///< HC-SR04 Echo pin
#define SERVO_PIN 11  ///< Servo motor signal pin

// ==============================
// CONSTANTS
// ==============================
#define BAUD_RATE      9600   ///< Serial communication speed
#define SERVO_DELAY    30     ///< Delay for servo to reach position (ms)
#define MEASURE_DELAY  10     ///< Delay between measurements (ms)
#define SOUND_SPEED    0.034  ///< Speed of sound in cm/μs

// ==============================
// GLOBAL OBJECTS
// ==============================
Servo radarServo;  ///< Servo motor object

// ==============================
// VARIABLES
// ==============================
int currentAngle = 0;      ///< Current servo angle (0-180)
long pulseDuration;        ///< Echo pulse duration (μs)
int measuredDistance;      ///< Calculated distance (cm)

// ==============================
// SETUP FUNCTION
// ==============================
void setup() {
  // Initialize serial communication
  Serial.begin(BAUD_RATE);
  
  // Configure sensor pins
  pinMode(TRIG_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);
  
  // Attach servo motor
  radarServo.attach(SERVO_PIN);
  
  // Wait for system to stabilize
  delay(1000);
  
  // Send initialization message
  Serial.println("RADAR_SYSTEM_START");
}

// ==============================
// MAIN LOOP
// ==============================
void loop() {
  // Sweep from 0° to 180°
  for (currentAngle = 0; currentAngle <= 180; currentAngle++) {
    performRadarScan(currentAngle);
  }
  
  // Sweep back from 180° to 0°
  for (currentAngle = 180; currentAngle >= 0; currentAngle--) {
    performRadarScan(currentAngle);
  }
}

// ==============================
// HELPER FUNCTIONS
// ==============================

/**
 * @brief   Performs a single radar scan at a given angle
 * @param   angle - Servo position in degrees (0-180)
 * @return  void
 * 
 * @details
 * 1. Moves servo to specified angle
 * 2. Triggers ultrasonic pulse
 * 3. Measures echo duration
 * 4. Calculates distance in centimeters
 * 5. Sends data over serial
 */
void performRadarScan(int angle) {
  // Move servo to target angle
  radarServo.write(angle);
  delay(SERVO_DELAY);
  
  // Measure distance
  measuredDistance = measureDistance();
  
  // Send data to visualization software
  sendRadarData(angle, measuredDistance);
  
  // Small delay between measurements
  delay(MEASURE_DELAY);
}

/**
 * @brief   Measures distance using HC-SR04 sensor
 * @return  int - Distance in centimeters (0-400)
 * 
 * @details
 * Triggers the ultrasonic sensor and measures the echo
 * return time to calculate distance using the speed of sound.
 */
int measureDistance() {
  // Clear trigger pin
  digitalWrite(TRIG_PIN, LOW);
  delayMicroseconds(2);
  
  // Send 10μs pulse to trigger
  digitalWrite(TRIG_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG_PIN, LOW);
  
  // Measure echo pulse duration
  pulseDuration = pulseIn(ECHO_PIN, HIGH);
  
  // Calculate distance (cm) = duration * speed_of_sound / 2
  int distance = pulseDuration * SOUND_SPEED / 2;
  
  // Clamp invalid readings
  if (distance <= 0 || distance > 400) {
    distance = 400;  // Max range for HC-SR04
  }
  
  return distance;
}

/**
 * @brief   Sends radar data over serial port
 * @param   angle - Current servo angle (0-180)
 * @param   distance - Measured distance in cm
 * @return  void
 * 
 * @details
 * Formats data as: "angle,distance"
 * This format is compatible with Processing/Python visualization
 */
void sendRadarData(int angle, int distance) {
  Serial.print(angle);
  Serial.print(",");
  Serial.println(distance);
}
