#ifndef _PWM_H_
#define _PWM_H_

#define PWM_A0      (0x60000000)
#define PWM_A1      (0x60010000)
#define PWM_A2      (0x60020000)
#define PWM_A3      (0x60030000)

#define PWM_B0      (0x60100000)
#define PWM_B1      (0x60110000)
#define PWM_B2      (0x60120000)
#define PWM_B3      (0x60130000)

#define PWM_C       (0x60040000)

#define PWM_REG(addr) (*((volatile uint32_t *)addr))

#endif