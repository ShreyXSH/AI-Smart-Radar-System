"""
AI Smart Radar System
---------------------
Python controller for the Hand Gesture Controlled Smart Radar System.

Features:
- Webcam-based hand tracking with MediaPipe
- OpenCV video processing
- Gesture commands sent to Arduino over Serial
- Index finger up  -> Move Right ('R')
- Thumb gesture    -> Move Left  ('L')
- Other/neutral    -> Center      ('0')

Before running:
1. Connect the Arduino by USB.
2. Change SERIAL_PORT below to your Arduino COM port.
3. Install dependencies:
       pip install opencv-python mediapipe pyserial
"""

import cv2
import mediapipe as mp
import serial
import time


# =========================
# Configuration
# =========================

SERIAL_PORT = "COM8"       # Change this to your Arduino COM port
BAUD_RATE = 9600
CAMERA_INDEX = 0


# =========================
# Arduino Serial Connection
# =========================

try:
    arduino = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=1)
    time.sleep(2)  # Give Arduino time to reset after serial connection
    print(f"[INFO] Connected to Arduino on {SERIAL_PORT}")
except serial.SerialException as error:
    print(f"[ERROR] Could not connect to Arduino: {error}")
    print("[INFO] Check the COM port and make sure Arduino IDE Serial Monitor is closed.")
    raise SystemExit(1)


# =========================
# MediaPipe Setup
# =========================

mp_hands = mp.solutions.hands
mp_draw = mp.solutions.drawing_utils

hands = mp_hands.Hands(
    static_image_mode=False,
    max_num_hands=1,
    min_detection_confidence=0.7,
    min_tracking_confidence=0.7
)


# =========================
# Camera Setup
# =========================

camera = cv2.VideoCapture(CAMERA_INDEX)

if not camera.isOpened():
    print("[ERROR] Could not open webcam.")
    arduino.close()
    raise SystemExit(1)


# =========================
# Gesture Detection
# =========================

def detect_gesture(hand_landmarks):
    """
    Detects a simple gesture using MediaPipe hand landmarks.

    Returns:
        'R' -> Move servo/radar right
        'L' -> Move servo/radar left
        '0' -> Center/neutral
    """

    # Landmark indexes:
    # Thumb tip = 4
    # Index finger tip = 8
    # Index finger PIP = 6

    thumb_tip = hand_landmarks.landmark[4]
    index_tip = hand_landmarks.landmark[8]
    index_pip = hand_landmarks.landmark[6]

    # Index finger pointing upward
    index_up = index_tip.y < index_pip.y

    # Thumb extended toward the left side of the image
    thumb_left = thumb_tip.x < hand_landmarks.landmark[3].x

    if index_up:
        return "R"

    if thumb_left:
        return "L"

    return "0"


# =========================
# Main Loop
# =========================

last_command = None

print("[INFO] Smart Radar started.")
print("[INFO] Press 'q' to quit.")

try:
    while True:
        success, frame = camera.read()

        if not success:
            print("[WARNING] Could not read frame from webcam.")
            continue

        # Mirror the webcam for natural interaction
        frame = cv2.flip(frame, 1)

        # Convert BGR -> RGB for MediaPipe
        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

        # Detect hands
        results = hands.process(rgb_frame)

        command = "0"

        if results.multi_hand_landmarks:
            for hand_landmarks in results.multi_hand_landmarks:

                # Draw hand landmarks
                mp_draw.draw_landmarks(
                    frame,
                    hand_landmarks,
                    mp_hands.HAND_CONNECTIONS
                )

                command = detect_gesture(hand_landmarks)

                # Only use the first detected hand
                break

        # Send command only when it changes
        # This reduces unnecessary serial communication.
        if command != last_command:
            arduino.write(command.encode("utf-8"))
            last_command = command

        # Display current command
        command_text = {
            "R": "MOVE RIGHT",
            "L": "MOVE LEFT",
            "0": "CENTER"
        }.get(command, "UNKNOWN")

        cv2.putText(
            frame,
            f"Command: {command_text}",
            (20, 40),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.9,
            (255, 255, 255),
            2
        )

        cv2.putText(
            frame,
            "Press Q to quit",
            (20, 75),
            cv2.FONT_HERSHEY_SIMPLEX,
            0.6,
            (255, 255, 255),
            2
        )

        # Show webcam window
        cv2.imshow("AI Smart Radar - Hand Gesture Control", frame)

        # Quit with Q
        if cv2.waitKey(1) & 0xFF == ord("q"):
            break

finally:
    # Clean shutdown
    camera.release()
    cv2.destroyAllWindows()
    hands.close()

    if arduino.is_open:
        arduino.write(b"0")
        time.sleep(0.1)
        arduino.close()

    print("[INFO] Smart Radar stopped safely.")
