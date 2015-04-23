import serial, time, sys

port = serial.Serial("/dev/ttyUSB0", baudrate=115200, timeout=0.1)

check = 0
for send in range(1,10000):
    sys.stdout.write( "Send: " + str(send) + "      ")
    port.write(chr(27))
    check = check + 27
    total = 0
    loop = 0
    for i in range(1,16):
        data = ord(port.read(1))
        sys.stdout.write(str(data) + "\t")
        total = total + (data << (loop*8))
        loop = loop + 1
    print
    print total
    print check
