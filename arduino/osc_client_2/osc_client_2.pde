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

void delay(int delay)
{
  int time = millis();
  while(millis() - time <= delay);
}

void draw() {
  myPort.write(83); //S
  boolean first = true;
  
  int time = millis();
  int i = 0;
  println("drawing");
  while (millis() - time < 500) {
    //println(millis() - time);
    while (myPort.available() > 0) {
      //println("waiting on read");
      int inByte = myPort.read();
      println(i, inByte);
      i++;
      if (i == 1024) {
        return;
      }
      if (i % 2 == 0) {
        myPort.write(82);
      }
      time = millis();
    }
  }
  delay(100);
  
    while (myPort.available() > 0) {
      //println("waiting on read");
      int inByte = myPort.read();
    }
}
