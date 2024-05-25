#include <stdint.h>
#include "../include/utils.h"
#include "../include/i2c.h"

static int rT(){ // sID拓展指令
	int Temperature;
	asm volatile(
		".insn i 0x2f, 1, %0, x0, 0"
		:"=r"(Temperature)
	);
	return Temperature;
}

int main()
{
	*(unsigned int *)0x70050000 = 625;	// i2c 分频系数： 62.5MHz
	// *(unsigned int *)0x70050000 = 500;	// i2c 分频系数： 50 MHz

	int Temperature;
	*(unsigned int *)0x30000000 = 1;	// 将uart设置到发送数据的模式
	
	Temperature = rT();
	*(unsigned int *)0x3000000c = Temperature;

    while(1);
	
    return 0;
}

