int startPin = 2;
int busyPin = 3;
int clockPin = 13;
int dataPin = 12;

byte clr;

void setup() {
  pinMode(startPin, OUTPUT);
  pinMode(busyPin, INPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, INPUT);
  pinMode(10, OUTPUT);
  
  // SPCR = 01010000
  //interrupt disabled,spi enabled,msb 1st,master,clk low when idle,
  //sample on leading edge of clk,system clock/4 rate (fastest)
  SPCR = (1<<SPE)|(1<<MSTR);
  clr=SPSR;
  clr=SPDR;
  
  // initialize serial:
  Serial.begin(500000);
}

char spi_transfer(volatile char data)
{
  SPDR = data;                    // Start the transmission
  while (!(SPSR & (1<<SPIF)))     // Wait the end of the transmission
  {
  };
  return SPDR;                    // return the received byte
}

int iter = 0;
boolean DEBUG = false;

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
    digitalWrite(startPin, HIGH);
    digitalWrite(startPin, LOW);
    
    delayMicroseconds(5);
    
    while(digitalRead(busyPin)) {}
    
    delayMicroseconds(5);
    
    int toread = 512;
    if (DEBUG)
      toread = 4;
    
    for (int j = 0; j < toread*2; j++) {
      
      char val = spi_transfer(0xFF);
      
      // ASCII communication
      if (DEBUG)
        Serial.println((int)val);
      else {
        Serial.write(val);
      }
    }
    if (DEBUG) {
      Serial.println("read done");
      delay(1000);
    }
    //Serial.println("done");
  }
}
