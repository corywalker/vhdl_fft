int convPin = 2;
int clockPin = 13;
int dataPin = 12;

void setup() {
  pinMode(convPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, INPUT);
  // initialize serial:
  Serial.begin(115200);
  
  digitalWrite(convPin, HIGH);
}

int i = 0;

void loop() {
  
  // Throw out first bit
  digitalWrite(clockPin, HIGH);
  digitalWrite(clockPin, LOW);
  
  // Read the 12 bit value
  int val = 0;
  for (int i = 0; i < 12; i++) {
    digitalWrite(clockPin, HIGH);
    val += digitalRead(dataPin) << (11-i);
    digitalWrite(clockPin, LOW);
  }
  // Throw out two bits
  for (int i = 0; i < 2; i++) {
    digitalWrite(clockPin, HIGH);
    digitalWrite(clockPin, LOW);
  }
  
  digitalWrite(convPin, LOW);
  digitalWrite(clockPin, HIGH);
  digitalWrite(clockPin, LOW);
  digitalWrite(convPin, HIGH);
  
  i++;
  if (i == 1000) {
    Serial.println(val);
    i = 0;
  }
}
