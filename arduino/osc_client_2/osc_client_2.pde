// Example by Tom Igoe

import processing.serial.*;

Serial myPort;  // The serial port

void setup() {
  // List all the available serial ports
  println(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, "/dev/tty.usbmodem14211", 57600);
  loop();
}

void draw() {
  int time = millis();
  int i = 0;
  while (millis() - time < 500) {
    while (myPort.available() > 0) {
      int inByte = myPort.read();
      println(i, inByte);
      i++;
      time = millis();
    }
  }
  myPort.write(83);
}
