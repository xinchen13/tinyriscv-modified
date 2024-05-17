#ifndef _I2C_H_
#define _I2C_H_

#define IIC_BASE            (0x70000000)
#define IIC_DEVICE_ADDR     (0x70010000)
#define IIC_WRITE_DATA      (0x70020000)
#define IIC_READ_DATA       (0x70030000)
#define IIC_EN              (0x70040000)

#define IIC_REG(addr) (*((volatile uint32_t *)addr))

#endif