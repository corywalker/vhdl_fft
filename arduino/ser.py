import serial
import struct

SIZE = 512
ser = serial.Serial("/dev/tty.usbmodem14211", 500000, timeout=0.2)

for i in range(50):
    ser.write("S")
    data = ser.read(SIZE*2)
    if len(data) == SIZE*2:
        print struct.unpack('BB'*SIZE, data)
