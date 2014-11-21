from Tkinter import *
from vhdlfft import VHDLFFT

root = Tk()
root.title("move-and-erase")
cw = 512 # canvas width
ch = 256 # canvas height

chart_1 = Canvas(root, width=cw, height=ch, background="white")
chart_1.grid(row=0, column=0)
cycle_period = 1000 # time between new positions of the ball
                             # (milliseconds).
cycle_period = 50 # time between new positions of the ball
                             # (milliseconds).

SIZE = 512
vf = VHDLFFT("/dev/tty.usbmodem14211", 512, 9)

for i in range(1,500):   # end the program after 500 position shifts.
    data = vf.read()
    print len(data)
    if len(data) == SIZE:
        for x, mag in enumerate(data):
            chart_1.create_line(x, 0, x, mag)

        chart_1.update() # This refreshes the drawing on the canvas.
        #chart_1.after(cycle_period) # This makes execution pause for 200
        chart_1.delete(ALL) # This erases everything on the canvas.

root.mainloop()
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
