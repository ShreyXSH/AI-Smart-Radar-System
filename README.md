# 🤖 AI Smart Radar System

> An AI-powered smart radar system combining **computer vision, hand gesture recognition, Arduino, ultrasonic sensing, and servo control**.

![Project Status](https://img.shields.io/badge/Status-Completed-success)
![Python](https://img.shields.io/badge/Python-3.x-blue)
![Arduino](https://img.shields.io/badge/Arduino-Uno-00979D)
![OpenCV](https://img.shields.io/badge/OpenCV-Computer%20Vision-red)
![MediaPipe](https://img.shields.io/badge/MediaPipe-Hand%20Tracking-orange)

---

## 📌 Overview

The **AI Smart Radar System** is a hardware-software project that combines an Arduino-based radar system with AI-powered hand gesture recognition.

The system uses a webcam to detect hand gestures through **MediaPipe**, processes the gesture using **Python and OpenCV**, and sends commands to an **Arduino Uno** through serial communication.

The Arduino then controls a servo motor while an **HC-SR04 ultrasonic sensor** measures the distance of objects.

---

## ✨ Features

- 🖐️ Hand gesture-based radar control
- 📷 Real-time hand tracking
- 🤖 Arduino Uno hardware control
- 📡 HC-SR04 ultrasonic distance measurement
- 🔄 Servo-based radar scanning
- 📺 I2C LCD display
- 💻 Python ↔ Arduino serial communication
- ⚡ Real-time gesture detection
- 🎯 Gesture-controlled servo positioning

---

## 🧠 How It Works

```text
                    ┌──────────────┐
                    │    WEBCAM    │
                    └──────┬───────┘
                           │
                           ▼
                    ┌──────────────┐
                    │    OpenCV    │
                    └──────┬───────┘
                           │
                           ▼
                    ┌──────────────┐
                    │   MediaPipe  │
                    │ Hand Tracking │
                    └──────┬───────┘
                           │
                           ▼
                    ┌──────────────┐
                    │    Python    │
                    │ Gesture Logic│
                    └──────┬───────┘
                           │
                     Serial USB
                           │
                           ▼
                    ┌──────────────┐
                    │  Arduino Uno │
                    └──────┬───────┘
                           │
                 ┌─────────┴─────────┐
                 │                   │
                 ▼                   ▼
          ┌────────────┐      ┌────────────┐
          │    Servo   │      │  HC-SR04   │
          │    Motor   │      │  Ultrasonic│
          └────────────┘      └──────┬─────┘
                                     │
                                     ▼
                              ┌────────────┐
                              │    LCD     │
                              └────────────┘

<img width="480" height="410" alt="image" src="https://github.com/user-attachments/assets/361d8aa4-8e02-45aa-9f90-939010a09bf7" />
<img width="492" height="156" alt="image" src="https://github.com/user-attachments/assets/4c691138-02a1-43c5-ac70-09e4893518a5" />





















