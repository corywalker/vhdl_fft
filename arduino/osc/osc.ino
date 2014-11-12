int startPin = 2;
int busyPin = 3;
int clockPin = 13;
int dataPin = 12;

void setup() {
  pinMode(startPin, OUTPUT);
  pinMode(busyPin, INPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, INPUT);
  // initialize serial:
  Serial.begin(115200);
}

int iter = 0;

void loop() {
  
  // Throw out first bit
  digitalWrite(clockPin, LOW);
  digitalWrite(startPin, HIGH);
  digitalWrite(startPin, LOW);
  
  delayMicroseconds(5);
  
  while(digitalRead(busyPin)) {}
  
  delayMicroseconds(5);
  
  for (int j = 0; j < 4; j++) {
    // Read the 16 bit value
    unsigned int val = 0;
    for (int i = 0; i < 16; i++) {
      digitalWrite(clockPin, HIGH);
      val += digitalRead(dataPin) << (15-i);
      digitalWrite(clockPin, LOW);
    }
    // ASCII communication
    Serial.println(val);
  }
  
  delay(1);
}
