int startPin = 12;
int busyPin = 11;
int clockPin = 10;
int dataPin = 13;

void setup() {
  pinMode(startPin, OUTPUT);
  pinMode(busyPin, INPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, INPUT);
  // initialize serial:
  Serial.begin(115200);
}

int iter = 0;
boolean DEBUG = true;

void loop() {
  boolean tostart = DEBUG;
  if (!DEBUG && Serial.available() > 0) {
    // read the incoming byte:
    char incomingByte = Serial.read();
    
    if (incomingByte == 'S')
      tostart = true;
  }
  
  if (tostart) {
    
    if (DEBUG)
      Serial.println("read starting");
      
    // Throw out first bit
    digitalWrite(clockPin, LOW);
    digitalWrite(startPin, HIGH);
    digitalWrite(startPin, LOW);
    
    delayMicroseconds(5);
    
    while(digitalRead(busyPin)) {}
    
    delayMicroseconds(5);
    
    int toread = 512;
    if (DEBUG)
      toread = 4;
    
    for (int j = 0; j < toread; j++) {
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
    if (DEBUG) {
      Serial.println("read done");
      delay(1000);
    }
  }
}
