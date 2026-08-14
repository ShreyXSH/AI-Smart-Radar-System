# AI-Smart-Radar-System
AI-powered smart radar system using computer vision, hand gestures, Arduino, ultrasonic sensing, and servo control.
AI Smart Radar System

An AI-powered radar system that combines computer vision, hand gesture recognition, Arduino, ultrasonic sensing, and servo control.

✨ Features
🖐️ Hand gesture-based control
📷 Real-time hand tracking using MediaPipe
🤖 Arduino-based hardware control
📡 HC-SR04 ultrasonic distance measurement
🔄 Servo-based radar scanning
📺 LCD distance/angle display
💻 Python ↔ Arduino serial communication
🎯 Real-time gesture commands
🧠 Technology Stack
Technology	Purpose
Python	Computer vision & control
OpenCV	Webcam processing
MediaPipe	Hand tracking
Arduino Uno	Hardware controller
HC-SR04	Distance measurement
Servo Motor	Radar scanning
I2C LCD	Display
Serial Communication	Python ↔ Arduino
🖐️ Gesture Controls
Gesture	Action
☝️ Index finger	Move radar right
👍 Thumb	Move radar left
✋ Other/neutral	Center servo
🔌 Hardware
Arduino Uno
│
├── HC-SR04
│   ├── VCC → 5V
│   ├── GND → GND
│   ├── TRIG → D9
│   └── ECHO → D10
│
├── Servo
│   ├── VCC → 5V
│   ├── GND → GND
│   └── Signal → D6
│
└── I2C LCD
    ├── VCC → 5V
    ├── GND → GND
    ├── SDA → A4
    └── SCL → A5
🧩 How it works
             WEBCAM
                │
                ▼
        ┌───────────────┐
        │    OpenCV     │
        └───────┬───────┘
                │
                ▼
        ┌───────────────┐
        │   MediaPipe   │
        │ Hand Tracking │
        └───────┬───────┘
                │
          Gesture detected
                │
                ▼
        ┌───────────────┐
        │ Python Control│
        └───────┬───────┘
                │ Serial
                ▼
        ┌───────────────┐
        │  Arduino Uno  │
        └───────┬───────┘
                │
        ┌───────┴────────┐
        ▼                ▼
     SERVO             HC-SR04
        │                │
        ▼                ▼
   Radar angle       Distance
        │                │
        └───────┬────────┘
                ▼
             LCD
🛠️ Python requirements
We can put this in Python/requirements.txt:

opencv-python
mediapipe
pyserial

Then anyone cloning your project can install everything with:

pip install -r requirements.txt
