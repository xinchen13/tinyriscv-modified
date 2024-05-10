#include <stdint.h>
#include "../include/utils.h"


int main()
{
	*(unsigned int *)0x40000000 = 0x55555555; // 将GPIO设置为输出
	while(1){
		*(unsigned int *)0x40000004 = 0xFE02;     // 控制最右侧LED显示6
		*(unsigned int *)0x40000004 = 0xFD02;     // 控制右侧第2个LED显示6
		*(unsigned int *)0x40000004 = 0xFB02;     // 控制右侧第3个LED显示6
	}
	
    return 0;
}
