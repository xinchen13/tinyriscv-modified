#include <stdint.h>

#include "../include/i2c.h"
#include "../include/utils.h"


int main()
{
    IIC_REG(IIC_DEVICE_ADDR) = 0x00000091;

    *(unsigned int *)0x60000000 = IIC_REG(IIC_READ_DATA);

    *(unsigned int *)0x30000000 = 1;	// 将uart设置到发送数据的模式

    while(1){
        ;
    }

    return 0;
}
