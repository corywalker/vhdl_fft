int convPin = 2;
int clockPin = 13;
int dataPin = 12;

void setup() {
  pinMode(convPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, INPUT);
  // initialize serial:
  Serial.begin(115200);
}

void loop() {
  //Serial.println("hello");
  takeSample();
  delay(100);
}

void takeSample() {
  
  int dly = 2;
  
  // Set to conv
  digitalWrite(convPin, HIGH);
  digitalWrite(convPin, LOW);
  
  // Throw out first two bits
  for (int i = 0; i < 2; i++) {
    digitalWrite(clockPin, HIGH);
    digitalWrite(clockPin, LOW);
  }
  // Read the 12 bit value
  int val = 0;
  for (int i = 0; i < 12; i++) {
    digitalWrite(clockPin, HIGH);
    val += digitalRead(dataPin) << (11-i);
    digitalWrite(clockPin, LOW);
  }
  // Throw out first two bits
  for (int i = 0; i < 2; i++) {
    digitalWrite(clockPin, HIGH);
    digitalWrite(clockPin, LOW);
  }
  
  Serial.println(val);
}
