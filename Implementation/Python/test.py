import serial, time

port = serial.Serial("/dev/ttyUSB0", baudrate=115200, timeout=0.1)

for send in range(1,10000):
    print "Send: " + str(255)
    port.write(chr(255))
    time.sleep(0.01)
    while(port.inWaiting()):
        print ord(port.read(1))
