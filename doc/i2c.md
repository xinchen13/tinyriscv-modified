# I2C protocol

## 概述
I2C (Inter-Integrated Circuit, IIC) 是一种串行通信协议, 属于半双工同步传输类型总线, 可以有多个主设备 (master) 和从设备 (slave). IIC 1982 年由 Philips 公司开发

## 接口
主设备与从设备之间使用两条线进行通信, 都是双向信号并通过电阻上拉:
- 串行数据线 SDA (Serial Data Line)
- 串行时钟线 SCL (Serial Clock Line)

两个微处理器的I2C配置示例:

<img src="../figs/i2c_example.png"  width="520" />

## 框图
最小配置: (Single controller)
- START condition
- STOP condition
- Acknowledge
- 7-bit target address

## 工作流程与时序

## 时钟与通信速率
IIC 协议的时钟频率是可以根据具体应用和设备支持的情况进行调节, 支持的速率如下: 

| 模式 | 速率 |
|:-------|:--------|
|标准模式（Standard Mode）|100kb/s|
|快速模式（Fast Mode）|400kb/s|
|增强快速模式（Fast Mode Plus）|1Mb/s|
|高速模式（High Speed Mode）|3.4Mb/s|
|极速模式（Ultra-FastMode）|5Mb/s|
