import serial
 
ser = serial.Serial('COM5', 115200)
while True:
    data = ser.read()  # 读取一个字节的数据

    # temp = bin(ord(data.decode()))

    print(data)
    # print(temp)
    # print(temp[2])
    # print(temp[3])
    # print(temp[4])
    # print(temp[5])
    # print(temp[6])
    # print(temp[7])
    # print(float(temp[2]))
    # print("temp = ", 16*float(temp[2]) + 8*float(temp[3]) + 4*float(temp[4]) + 2*float(temp[5])
    #        + float(temp[6]) + 0.5*float(temp[7]))
    # print("temp = ", 32*float(temp[2]) + 16*float(temp[3]) + 8*float(temp[4]) + 4*float(temp[5])
    #        + 2*float(temp[6]) + 0.5*float(temp[8]) + float(temp[7]))
    # print(temp[8])
    # print(temp[9])


ser.close()