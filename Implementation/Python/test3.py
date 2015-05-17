import serial, time, sys

port = serial.Serial("/dev/ttyUSB0", baudrate=9600, timeout=0.1)

test=[  0,0,1,1,1,1,
        0,1,1,0,0,0,
        0,5,
        0,6,
        0,2]

port.flushInput()


def load_weight(node,data1,data2,data3,data4):
    port.write(chr(int(node)))
    port.write(chr(0))
    port.write(chr(int(data1)))
    port.write(chr(int(data2)))
    port.write(chr(int(data3)))
    port.write(chr(int(data4)))

def load_data(node,data1,data2,data3,data4):
    port.write(chr(int(node)))
    port.write(chr(1))
    port.write(chr(int(data1)))
    port.write(chr(int(data2)))
    port.write(chr(int(data3)))
    port.write(chr(int(data4)))

def mul(node):
    port.write(chr(int(node)))
    port.write(chr(5))

def mul_add(node):
    port.write(chr(int(node)))
    port.write(chr(6))

def out(node):
    port.write(chr(int(node)))
    port.write(chr(2))




while(1):
    load_data(4,1,0,0,0)
    load_weight(4,1,0,0,0)
    out(4)


    time.sleep(0.2)

    #print port.inWaiting()

    total = 0
    loop = 0

    for i in range(0,16):
        data = ord(port.read(1))
        #print data
        total = total + (data << (loop*8))
        loop = loop + 1
    print total


