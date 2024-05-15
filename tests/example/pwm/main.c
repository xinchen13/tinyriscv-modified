#include <stdint.h>

#include "../include/pwm.h"
#include "../include/utils.h"


int main()
{
    PWM_REG(PWM_A0) = 0x00000008;
    PWM_REG(PWM_B0) = 0x00000004;

    PWM_REG(PWM_A1) = 0x0000000f;
    PWM_REG(PWM_B1) = 0x00000002;

    PWM_REG(PWM_A2) = 0x00000002;
    PWM_REG(PWM_B2) = 0x00000001;

    PWM_REG(PWM_A3) = 0x0000001f;
    PWM_REG(PWM_B3) = 0x0000000f;

    PWM_REG(PWM_C)  = 0x0000000f;
    while(1){
        ;
    }

    return 0;
}
