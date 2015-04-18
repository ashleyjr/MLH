import serial

port = serial.Serial("/dev/ttyUSB0", baudrate=115200, timeout=3.0)
send = 1

for send in range(1,200):
    print "Send: " + str(send)
    port.write(chr(send))
    print ord(port.read(1))
