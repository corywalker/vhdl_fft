import serial
import struct
from math import sqrt, pow

def chunks(l, n):
    """ Yield successive n-sized chunks from l.
    """
    for i in xrange(0, len(l), n):
        yield l[i:i+n]

def reverse_bit_order(buf, width):

    # Just to get the length the same
    newbuf = range(len(buf))

    for i in range(len(buf)):
        origbin = bin(i)[2:].zfill(width)
        newbin = origbin[::-1]
        newi = int(newbin, 2)
        #print i, origbin, newbin, newi
        newbuf[newi] = buf[i]
    return newbuf

class VHDLFFT(object):
    def __init__(self, port, thesize, thelogsize):
        self.SIZE = thesize
        self.LOGSIZE = thelogsize
        self.ser = serial.Serial(port, 500000, timeout=0.05)

    def read_raw(self):
        self.ser.write("S")
        data = self.ser.read(self.SIZE*2)
        if len(data) == self.SIZE*2:
            outbuf = struct.unpack('BB'*self.SIZE, data)
            outbuf = list(chunks(outbuf, 2))
            #outbuf = reverse_bit_order(outbuf, self.LOGSIZE)
            return outbuf
        return []

    def read(self):
        outbuf = self.read_raw()
        newoutbuf = []
        for re, im in outbuf:
            mag = sqrt(pow(float(re),2)+pow(float(im),2))
            newoutbuf.append(mag)
        return newoutbuf
