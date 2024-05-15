#include <stdint.h>
#include "../include/utils.h"


int main()
{
	*(unsigned int *)0x60000000 = 100000000; //1秒2闪
	*(unsigned int *)0x60100000 = 50000000;
	
	*(unsigned int *)0x60010000 = 50000000; //1秒1闪
	*(unsigned int *)0x60110000 = 25000000;
	
	*(unsigned int *)0x60020000 = 4000000;
	*(unsigned int *)0x60120000 = 2000000;
	
	*(unsigned int *)0x60030000 = 8000000;
	*(unsigned int *)0x60130000 = 4000000;
	
	*(unsigned int *)0x60040000 = 15;
    while(1){
        ;
    }
	
    return 0;
}
