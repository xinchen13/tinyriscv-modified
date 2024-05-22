'''
 Copyright 2020 Blue Liang, liangkangnan@163.com
                                                                         
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
                                                                         
     http://www.apache.org/licenses/LICENSE-2.0                          
                                                                         
 Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
'''

import os
import sys
import serial

#import serial.tools.list_ports

'''
通过串口下载固件到FPGA开发板，FPGA收到数据后将数据烧写到ROM(Flash)。
有两种包类型：包0和其他包。包0用来传输文件名和文件大小，其他包用来传输文件内容。
每个包的大小固定为35个字节(1字节包号+32字节数据+2字节CRC)。
'''

# 包格式
# number：0，包序号
# data[0] ~ data[23]：文件名
# data[24] ~ data[27]：文件大小(字节)，其中data[24]为MSB
# crc[0]：crc低字节，crc[1]：crc高字节
'''
    0        1         2       ...      32         33       34
|-------------------------------------------------------------------|
| number | data[0] | data[1] | ... | data[31] | crc[0]  | crc[1]    |
|-------------------------------------------------------------------|
'''

# 包1 ~ n格式
# number：包序号
# data[0]~data[31]：文件内容
# crc[0]：crc低字节，crc[1]：crc高字节
'''
    0        1         2       ...     32         33        34
|-------------------------------------------------------------------|
| number | data[0] | data[1] | ... | data[31] | crc[0]  | crc[1]    |
|-------------------------------------------------------------------|
'''


ACK = bytes([0x6])
FIRST_PACKET_LEN = 35
FILE_NAME_INDEX = 1
FILE_SIZE_INDEX = 25
FIRST_PACKET_CRC0_INDEX = 33
FIRST_PACKET_CRC1_INDEX = 34
OTHER_PACKET_LEN = 35



serial_com = serial.Serial()

# 串口初始化
# 串口参数：115200, 8 N 1
def serial_init():
    serial_com.port = sys.argv[1]
    serial_com.baudrate = 115200
    serial_com.bytesize = serial.EIGHTBITS
    serial_com.parity = serial.PARITY_NONE
    serial_com.stopbits = serial.STOPBITS_ONE
    serial_com.xonxoff = False
    serial_com.rtscts = False
    serial_com.dsrdtr = False

    if serial_com.is_open == False:
        serial_com.open()
        if serial_com.is_open:
            return 0
    else:
        return -1

def serial_deinit():
    if serial_com.is_open == True:
        serial_com.close()

# 串口写数据
def serial_write(b):
    if serial_com.is_open == True:
        serial_com.write(b)
        return len(b)
    else:
       return 0

# 串口读数据
def serial_read(length, timeout):
    if (timeout > 0):
        serial_com.timeout = timeout

    if serial_com.is_open == True:
        data = serial_com.read(length)
        if len(data) > 0:
            return data
        else:
            return -1
    else:
        return -1

# CRC计算
def calc_crc16(data):
    crc = 0xFFFF
    for pos in data:
        crc ^= pos
        for i in range(8):
            if ((crc & 1) != 0):
                crc >>= 1
                crc ^= 0xA001
            else:
                crc >>= 1
    return crc

# 主函数
def main(filename):
    if serial_init() == 0:
        bin_file_size = os.path.getsize(filename)
        print('bin file size: %d bytes' % bin_file_size)
        bin_file_name = os.path.basename(filename)
        print('bin file name: ' + bin_file_name)
        print('Total %d packets to be sent' % (int(bin_file_size / 32) + 1))

        ############### 第一个包 ###############
        print('send #0 packet')
        packet = [0] * FIRST_PACKET_LEN
        # 1.包号
        packet[0] = 0
        i = FILE_NAME_INDEX
        # 2.文件名
        for c in bin_file_name:
            packet[i] = ord(c)
            i = i + 1
        # 3.文件大小
        packet[FILE_SIZE_INDEX] = (bin_file_size >> 24) & 0xff
        packet[FILE_SIZE_INDEX + 1] = (bin_file_size >> 16) & 0xff
        packet[FILE_SIZE_INDEX + 2] = (bin_file_size >> 8) & 0xff
        packet[FILE_SIZE_INDEX + 3] = (bin_file_size >> 0) & 0xff
        crc = calc_crc16(packet[1:33])
        # 4.CRC
        packet[FIRST_PACKET_CRC0_INDEX] = (crc >> 0) & 0xff
        packet[FIRST_PACKET_CRC1_INDEX] = (crc >> 8) & 0xff

        #print(packet)
        # 5.发送
        serial_write(packet)

        ############### 剩余包 ###############
        bin_file = open(filename, 'rb')
        data = bin_file.read(bin_file_size)
        remain_data_len = bin_file_size
        remain_data_index = 0
        # 文件有多少个128字节
        for i in range(int(bin_file_size / 32) + 1):
            print('send #%d packet' % (i + 1))
            packet = [0] * OTHER_PACKET_LEN
            packet[0] = i + 1
            j = 1
            k = remain_data_index
            if (remain_data_len >= 32):
                for r in range(32):
                    packet[j] = data[k]
                    j = j + 1
                    k = k + 1
                crc = calc_crc16(packet[1:33])
                packet[FIRST_PACKET_CRC0_INDEX] = (crc >> 0) & 0xff
                packet[FIRST_PACKET_CRC1_INDEX] = (crc >> 8) & 0xff
                serial_write(packet)
                remain_data_len = remain_data_len - 32
                remain_data_index = remain_data_index + 32
            else:
                for r in range(remain_data_len):
                    packet[j] = data[k]
                    j = j + 1
                    k = k + 1
                crc = calc_crc16(packet[1:33])
                packet[FIRST_PACKET_CRC0_INDEX] = (crc >> 0) & 0xff
                packet[FIRST_PACKET_CRC1_INDEX] = (crc >> 8) & 0xff
                serial_write(packet)

        bin_file.close()

        print('Send successfully...')
    else:
        print('!!! serial init failed !!!')

    serial_deinit()

def convert_data(filename):
    fp = open(filename, "r")
    all_data_str = fp.readlines()
    fp.close()
    
    fp = open(filename+'.bin', 'wb')
    for data in all_data_str:
        for i in range(4):
            fp.write(int(data[2*(3-i):2*(3-i)+2], 16).to_bytes(1,'big'))
    fp.close()
    

# 程序入口
if __name__ == "__main__":
    if (len(sys.argv) != 3):
        print('Usage: python ' + sys.argv[0] + ' COMx ' + '.data file')
    else:
        convert_data(sys.argv[2])
        main(sys.argv[2]+'.bin')
