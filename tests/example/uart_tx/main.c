#include <stdint.h>

#include "../include/uart.h"
#include "../include/xprintf.h"



int main()
{
    // uart_init();

    // xprintf("xwjsdhd\n");

    *(unsigned int *)0x30000000 = 1; // 将uart设置到发送数据的模式

    while (UART0_REG(UART0_STATUS) & 0x1);
    UART0_REG(UART0_TXDATA) = 0x36;

    while (UART0_REG(UART0_STATUS) & 0x1);
    *(unsigned int *)0x3000000c = 0xff; // 将uart设置到发送数据的模式
   while (UART0_REG(UART0_STATUS) & 0x1);
    *(unsigned int *)0x3000000c = 0x82; // 将uart设置到发送数据的模式

    while (1);
}
