#include <stdint.h>
#include "../include/utils.h"

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
	int Temperature;
	*(unsigned int *)0x30000000 = 1;	// 将uart设置到发送数据的模式
	
	Temperature = rT();
	*(unsigned int *)0x3000000c = Temperature;
	
    return 0;
}
