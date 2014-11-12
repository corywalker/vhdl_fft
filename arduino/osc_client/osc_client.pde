// Example by Tom Igoe

import processing.serial.*;

Serial s;  // The serial port

void setup() {
  // List all the available serial ports
  println(Serial.list());
  // Open the port you are using at the rate you want:
  s = new Serial(this, "/dev/tty.usbmodem14211", 115200);
  frameRate(15);
}


void delay(int delay)
{
  int time = millis();
  while(millis() - time <= delay);
}

void draw() {
  println("starting read");
  s.write(83);
  for (int i = 0; i < 4; i++) {
    int im = s.read();
    int real = s.read();
    println(real);
  }
  s.clear();
  /*
  int inByte = 0;
  int bytesread = 0;
  while (bytesread < 4) {
    while (s.available() > 0 ) {
      inByte = s.read();
      println(inByte);
      bytesread += 1;
    }
  }*/
  println("done");
}
