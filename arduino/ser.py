import serial

ser = serial.Serial("/dev/tty.usbmodem14211", 57600, timeout=1)

for i in range(5):
    ser.write("S")
    print repr(ser.read(2))
    ser.write("R")
    print repr(ser.read(2))
