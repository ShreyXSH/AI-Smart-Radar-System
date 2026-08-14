/**
 * @file    radar_visualization.pde
 * @brief   Processing visualization for Smart Radar System
 * @author  Your Name
 * @date    2026-08-14
 * @version 1.0
 * 
 * @description
 * This Processing sketch reads serial data from Arduino and creates
 * a real-time radar display showing detected objects.
 * 
 * @dependencies
 * - Processing 3.0 or higher
 * - Serial library (included)
 */

import processing.serial.*;

// ==============================
// SERIAL CONFIGURATION
// ==============================
Serial myPort;           ///< Serial port object
String portName = "COM5"; ///< Change to your Arduino port
int baudRate = 9600;     ///< Must match Arduino's baud rate

// ==============================
// RADAR DISPLAY SETTINGS
// ==============================
int radarRadius = 300;      ///< Radius of radar display
int centerX;                ///< X-coordinate of radar center
int centerY;                ///< Y-coordinate of radar center
float angleRadians;         ///< Current angle in radians
float distance;             ///< Current distance in cm

// ==============================
// DATA STORAGE
// ==============================
ArrayList<Float> angles = new ArrayList<Float>();
ArrayList<Float> distances = new ArrayList<Float>();

// ==============================
// SETUP FUNCTION
// ==============================
void setup() {
  size(800, 700);
  smooth();
  
  // Calculate radar center
  centerX = width / 2;
  centerY = height - 100;
  
  // Initialize serial communication
  try {
    myPort = new Serial(this, portName, baudRate);
    myPort.bufferUntil('\n');
  } catch (Exception e) {
    println("Error opening serial port: " + e);
    println("Please check your port name in the code!");
  }
}

// ==============================
// DRAW FUNCTION
// ==============================
void draw() {
  background(0);
  
  // Draw radar display
  drawRadarBackground();
  drawRadarData();
  drawRadarSweep();
  
  // Draw information panel
  drawInfoPanel();
}

// ==============================
// SERIAL EVENT HANDLER
// ==============================
void serialEvent(Serial p) {
  String data = p.readStringUntil('\n');
  if (data != null) {
    data = trim(data);
    
    // Parse angle and distance from "angle,distance"
    String[] parts = split(data, ',');
    if (parts.length == 2) {
      try {
        float angle = Float.parseFloat(parts[0]);
        float dist = Float.parseFloat(parts[1]);
        
        // Add to dataset
        angles.add(angle);
        distances.add(dist);
        
        // Limit dataset size for performance
        if (angles.size() > 360) {
          angles.remove(0);
          distances.remove(0);
        }
      } catch (Exception e) {
        // Skip invalid data
      }
    }
  }
}

// ==============================
// DRAWING FUNCTIONS
// ==============================

/**
 * @brief   Draws the radar background with range rings
 */
void drawRadarBackground() {
  // Draw radar outer circle
  noFill();
  stroke(0, 255, 0, 50);
  strokeWeight(1);
  ellipse(centerX, centerY, radarRadius * 2, radarRadius * 2);
  
  // Draw range rings (10cm, 20cm, 30cm)
  for (int r = 100; r <= radarRadius; r += 100) {
    stroke(0, 255, 0, 30);
    ellipse(centerX, centerY, r * 2, r * 2);
    
    // Add distance labels
    fill(0, 255, 0, 50);
    noStroke();
    textAlign(CENTER, CENTER);
    textSize(12);
    text(r / 2.5 + "cm", centerX + r, centerY);
  }
  
  // Draw angle lines (30° intervals)
  stroke(0, 255, 0, 30);
  strokeWeight(1);
  for (int angle = 0; angle < 180; angle += 30) {
    float rad = radians(angle);
    float x = centerX + cos(rad - PI/2) * radarRadius;
    float y = centerY + sin(rad - PI/2) * radarRadius;
    line(centerX, centerY, x, y);
  }
  
  // Draw crosshair
  stroke(0, 255, 0, 80);
  strokeWeight(1);
  line(centerX - 20, centerY, centerX + 20, centerY);
  line(centerX, centerY - 20, centerX, centerY + 20);
}

/**
 * @brief   Draws the collected radar data points
 */
void drawRadarData() {
  // Draw data points
  for (int i = 0; i < angles.size(); i++) {
    float angle = angles.get(i);
    float dist = distances.get(i);
    
    // Convert to pixel coordinates
    float rad = radians(angle);
    float maxDist = 400; // Max range of HC-SR04
    float scaledDist = map(dist, 0, maxDist, 0, radarRadius);
    float x = centerX + cos(rad - PI/2) * scaledDist;
    float y = centerY + sin(rad - PI/2) * scaledDist;
    
    // Color based on distance (green = close, red = far)
    float hue = map(dist, 0, 100, 255, 0);
    fill(0, hue, 0, 200);
    noStroke();
    
    // Draw point
    float size = map(dist, 0, 400, 10, 3);
    ellipse(x, y, size, size);
  }
}

/**
 * @brief   Draws the current radar sweep line
 */
void drawRadarSweep() {
  if (angles.size() > 0) {
    float lastAngle = angles.get(angles.size() - 1);
    float rad = radians(lastAngle);
    float sweepLength = radarRadius;
    
    // Draw sweep line with gradient
    noFill();
    for (int i = 0; i < 20; i++) {
      float alpha = map(i, 0, 20, 150, 0);
      stroke(0, 255, 0, alpha);
      strokeWeight(2);
      
      float len = map(i, 0, 20, sweepLength, 0);
      float x = centerX + cos(rad - PI/2) * len;
      float y = centerY + sin(rad - PI/2) * len;
      line(centerX, centerY, x, y);
    }
  }
}

/**
 * @brief   Draws the information panel
 */
void drawInfoPanel() {
  fill(0, 255, 0, 150);
  noStroke();
  rect(10, 10, 200, 100, 10);
  
  fill(0);
  textAlign(LEFT, TOP);
  textSize(14);
  text("RADAR SYSTEM", 20, 20);
  textSize(12);
  
  if (angles.size() > 0) {
    float lastAngle = angles.get(angles.size() - 1);
    float lastDist = distances.get(distances.size() - 1);
    text("Angle: " + round(lastAngle) + "°", 20, 45);
    text("Distance: " + round(lastDist) + " cm", 20, 65);
    text("Points: " + angles.size(), 20, 85);
  } else {
    text("Waiting for data...", 20, 45);
  }
  
  // Draw title
  fill(0, 255, 0);
  textAlign(CENTER, TOP);
  textSize(24);
  text("SMART RADAR SYSTEM", width/2, 20);
}
