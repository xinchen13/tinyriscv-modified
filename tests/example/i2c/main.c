#include <stdint.h>

#include "../include/i2c.h"
#include "../include/utils.h"


int main()
{
    IIC_REG(IIC_DEVICE_ADDR) = 0x00000091;

    IIC_REG(IIC_EN) = 0x00000001;

    while(1){
        ;
    }

    return 0;
}
