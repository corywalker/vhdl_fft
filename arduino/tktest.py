from Tkinter import *
import serial
import struct
import itertools

def grouper(n, iterable):
    it = iter(iterable)
    while True:
       chunk = tuple(itertools.islice(it, n))
       if not chunk:
           return
       yield chunk

root = Tk()
root.title("move-and-erase")
cw = 512 # canvas width
ch = 256 # canvas height

chart_1 = Canvas(root, width=cw, height=ch, background="white")
chart_1.grid(row=0, column=0)
cycle_period = 50 # time between new positions of the ball
                             # (milliseconds).

SIZE = 512
ser = serial.Serial("/dev/tty.usbmodem14211", 500000, timeout=0.05)

for i in range(1,500):   # end the program after 500 position shifts.
    ser.write("S")
    data = ser.read(SIZE*2)
    print len(data)
    if len(data) == SIZE*2:
        data = struct.unpack('BB'*SIZE, data)

        for x, sample in enumerate(grouper(2, data)):
            real, im = sample
            chart_1.create_line(x, 0, x, real)

        chart_1.update() # This refreshes the drawing on the canvas.
        chart_1.after(cycle_period) # This makes execution pause for 200
        chart_1.delete(ALL) # This erases everything on the canvas.

root.mainloop()
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
