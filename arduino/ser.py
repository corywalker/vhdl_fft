from vhdlfft import VHDLFFT

vf = VHDLFFT("/dev/tty.usbmodem14211", 512, 9)
while True:
    print vf.read()
