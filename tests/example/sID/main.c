// #include <stdint.h>
// #include "../include/uart.h"

// int main()
// {
//     *(unsigned int *)0x30000000 = 0x00000005; // 将uart设置到sID模式

//     while (1);
// }


#include <stdint.h>
#include "../include/utils.h"


static void sID(){ // sID拓展指令
	asm volatile(".insn i 0x2f, 0, x0, x0, 0");
}

int main()
{
	// *(unsigned int *)0x30000008 = 550;	// uart 分频系数： 62.5MHz
	*(unsigned int *)0x30000000 = 1; // 将uart设置到发送数据的模式
	sID();
    return 0;
}


