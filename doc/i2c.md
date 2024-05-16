# I2C protocol

## 概述
I2C (Inter-Integrated Circuit, IIC) 是一种串行通信协议, 属于半双工同步传输类型总线, 可以有多个主设备 (master) 和从设备 (slave). IIC 1982 年由 Philips 公司开发

## 接口
主设备与从设备之间使用两条线进行通信, 都是双向信号并通过电阻上拉:
- 串行数据线 SDA (Serial Data Line)
- 串行时钟线 SCL (Serial Clock Line)

有两个微处理器的I2C配置示例:

<img src="../figs/i2c_example.png"  width="520" />

## 框图
最小配置: (Single controller)
- START condition
- STOP condition
- Acknowledge
- 7-bit target address

## 工作流程与时序
### 空闲状态
总线空闲时, SDA 和 SCL 被所接的上拉电阻拉高，保持着高电平

### 起始与结束条件
所有总线事务以 START 开始, 以 STOP 结束:
- 当 SCL 为 HIGH 时, SDA 线上的信号拉低表示开始传输 (START condition)
- 当 SCL 为 HIGH 时，SDA 线上信号拉高表示结束传输 (STOP condition)

<img src="../figs/i2c_timing1.png"  width="520" />

### 数据格式
SDA 线上按8位 byte 传输数据, 每次传输可以传输的字节数是不受限制的, 先传输最高有效位 (MSB). 每个字节后面必须跟一个应答信号 ack/nack

伪握手机制: 可以通过 SCL 进行主机与从机之间的伪握手, 即从机收到地址后, 由于内部寄存器还没准备好, 可以通过主动拉低 SCL 使主机被迫等待, 直到从机准备好后拉高 SCL 时钟线继续通信

<img src="../figs/i2c_byte_format.png"  width="650" />

应答信号: 每个字节传输之后需要 1-bit 应答信号, 应答信号是接收方通知发送方该字节已被成功接收, 并且可以发送另一个字节. 控制器需要产生包括用于 ack/nack 的第9时钟脉冲在内的所有时钟脉冲

- Acknowledge (ack): 发射方在应答信号时钟脉冲期间释放 SDA 线, 因此接收器可以将 SDA 线拉低, 并且在该时钟脉冲的 HIGH 周期内保持稳定低电平 (还必须考虑设置和保持时间)
- Not Acknowledge (nack): 当 SDA 在第9时钟脉冲期间保持高电平时, 这被定义为非确认信号. 然后控制器可以生成中止传输的 STOP 条件，或者生成开始新传输的重复 START 条件. 有五种情况会导致 nack 的产生
    1. 传输的地址上不存在接收方, 因此没有设备发送 ack
    2. 接受器正在执行一些实时功能, 没有准备好开始与控制器通信, 因此无法接收或发送 ack
    3. 传输过程中, 接收方收到它不理解的数据或命令
    4. 在传输期间，接收方不能再接收任何数据字节
    5. 可作为主机的接收方必须向目标发射方发送传输结束的信号

### 数据有效性
SDA 线上的数据必须在时钟的 HIGH 周期内保持稳定; 只有当 SCL 线上的时钟信号为 LOW 时, 数据线的状态才能改变. 即为传输的每个数据位生成一个时钟脉冲, 如下所示:

<img src="../figs/i2c_timing2.png"  width="370" />


## 时钟与通信速率
IIC 协议的时钟频率是可以根据具体应用和设备支持的情况进行调节, 支持的速率如下: 

| 模式 | 速率 |
|:-------|:--------|
|标准模式（Standard Mode）|100kb/s|
|快速模式（Fast Mode）|400kb/s|
|增强快速模式（Fast Mode Plus）|1Mb/s|
|高速模式（High Speed Mode）|3.4Mb/s|
|极速模式（Ultra-FastMode）|5Mb/s|
