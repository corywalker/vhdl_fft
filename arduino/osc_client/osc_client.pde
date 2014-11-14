// Example by Tom Igoe

import processing.serial.*;

Serial s;  // The serial port

void setup() {
  // List all the available serial ports
  println(Serial.list());
  // Open the port you are using at the rate you want:
  s = new Serial(this, "/dev/tty.usbmodem14211", 115200);
  
  size(550, 256);
  frameRate(3);
}

void delay(int delay)
{
  int time = millis();
  while(millis() - time <= delay);
}

void draw() {
  println("starting read");
  s.write(83);
  int x = 0;
  background(220);
  for (int i = 0; i < 512; i++) {
    int im = s.read();
    int real = s.read();
    println(real);
    stroke(90, 76, 99);
    line(x, height, x, height - real);
    x++;
  }
  s.clear();
  println("done");
}
