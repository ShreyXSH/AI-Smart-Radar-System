🖐️ Gesture Controls
-------------------------------------------------
| Gesture           | Command | Action           |
| ----------------- | ------- | ---------------- |
| ☝️ Index finger   | `R`     | Move radar right |
| 👍 Thumb          | `L`     | Move radar left  |
| ✋ Neutral / other | `0`     | Center servo     |

🔧 Hardware Components
--------------------------------------------
| Component    | Purpose                |
| ------------ | ---------------------- |
| Arduino Uno  | Main controller        |
| HC-SR04      | Distance measurement   |
| Servo Motor  | Radar rotation         |
| I2C LCD      | Display information    |
| Webcam       | Hand gesture detection |
| Jumper Wires | Connections            |
| USB Cable    | Arduino ↔ Computer     |

🔌 Circuit Connections
------------------------------------------------
| HC-SR04 | Arduino Uno |
| ------- | ----------- |
| VCC     | 5V          |
| GND     | GND         |
| TRIG    | D9          |
| ECHO    | D10         |
-----------------------------------------------
| Servo  | Arduino Uno |
| ------ | ----------- |
| VCC    | 5V          |
| GND    | GND         |
| Signal | D6          |
-------------------------------------------------
| LCD | Arduino Uno |
| --- | ----------- |
| VCC | 5V          |
| GND | GND         |
| SDA | A4          |
| SCL | A5          |
-------------------------------------------------------
| Technology  | Purpose                        |
| ----------- | ------------------------------ |
| Python      | Gesture processing & control   |
| OpenCV      | Webcam processing              |
| MediaPipe   | Hand landmark detection        |
| PySerial    | Python ↔ Arduino communication |
| Arduino IDE | Arduino programming            |
| C/C++       | Arduino firmware               |
