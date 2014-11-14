int startPin = 12;
int busyPin = 11;
int clockPin = 10;
int dataPin = 13; // also led

void setup() {
  pinMode(startPin, OUTPUT);
  pinMode(busyPin, INPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, INPUT);
  // initialize serial:
  Serial.begin(57600);
}

boolean DEBUG = false;

void sendword() {
  // Read the 16 bit value
  unsigned int val = 0;
  for (int i = 0; i < 16; i++) {
    digitalWrite(clockPin, HIGH);
    val += digitalRead(dataPin) << (15-i);
    digitalWrite(clockPin, LOW);
  }
  // ASCII communication
  if (DEBUG)
    Serial.println(val);
  else {
    Serial.write(lowByte(val));
    Serial.write(highByte(val));
  }
}

void loop() {
  if (Serial.available() > 0) {
    // read the incoming byte:
    char incomingByte = Serial.read();
    
    if (incomingByte == 'S') {
        
      // Throw out first bit
      digitalWrite(clockPin, LOW);
      digitalWrite(startPin, HIGH);
      digitalWrite(startPin, LOW);
      
      delayMicroseconds(5);
      while(digitalRead(busyPin)) {}
      delayMicroseconds(5);
      
      sendword();
      
    } else if (incomingByte == 'R') {
      sendword();
    }
  }
}
