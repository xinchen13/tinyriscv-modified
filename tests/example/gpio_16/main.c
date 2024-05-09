#include <stdint.h>

#include "../include/gpio.h"
#include "../include/utils.h"


int main()
{
    GPIO_REG(GPIO_CTRL) |= 0x55555555;          // 全部输出模式
    GPIO_REG(GPIO_DATA) |= 0x0000FFFF;              // GPIO输出高
    int cnt = 0;
    while (1) {
        cnt++;
        if (cnt %100 == 0) {
            GPIO_REG(GPIO_DATA) ^= 0x0000FFFF;
        }
    }
}
