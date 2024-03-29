import serial, time, sys

port = serial.Serial("/dev/ttyUSB0", baudrate=115200, timeout=0.1)

test=[  100,0,32,32,11,0,
        100,1,16,16,11,0,
        100,5,10,20,30,40,
        100,6,10,20,30,40,
        100,2,10,20,30,40]

port.flushInput()

for i in range(0,30):
    sys.stdout.write( "Send " + str(i) + " " + str(test[i]) + "      \n\r")
    time.sleep(0.05)
    port.write(chr(test[i]))

time.sleep(0.1)
#print port.inWaiting()

total = 0
loop = 0
for i in range(0,14):
    data = ord(port.read(1))
    print data
    total = total + (data << (loop*8))
    loop = loop + 1
print total
